import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qnow/presentation/drawer/help_support_page.dart';
import '../../core/app_colors.dart';
import '../../core/localization.dart';
import '../../logic/queue_cubit.dart';
import '../../core/common_widgets.dart';
import '../../database/models/queue_model.dart';
import '../../database/models/user_model.dart';
import '../../database/repositories/queue_repository.dart';
import '../../database/repositories/queue_client_repository.dart';
import '../../database/repositories/manual_customer_repository.dart';
import '../../database/repositories/notification_repository.dart';
import '../drawer/profile_page.dart';
import '../drawer/settings_page.dart';
import '../drawer/about_us_page.dart';
import '../login_signup/login_page.dart';
import '../business/queue_page.dart';

class BusinessOwnerPage extends StatelessWidget {
  final User user;

  const BusinessOwnerPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => QueueCubit(
        queueRepository: RepositoryProvider.of<QueueRepository>(context),
        queueClientRepository:
          RepositoryProvider.of<QueueClientRepository>(context),
          notificationRepository: RepositoryProvider.of<NotificationRepository>(context),
        manualCustomerRepository:
          RepositoryProvider.of<ManualCustomerRepository>(context),
        businessOwnerId: user.id),
      child: BusinessOwnerView(user: user),
    );
  }
}

class BusinessOwnerView extends StatefulWidget {
  final User user;

  const BusinessOwnerView({super.key, required this.user});

  @override
  State<BusinessOwnerView> createState() => _BusinessOwnerViewState();
}

class _BusinessOwnerViewState extends State<BusinessOwnerView> {
  final _queueNameController = TextEditingController();
  late QueueCubit _queueCubit;

  @override
  void initState() {
    super.initState();
    _queueCubit = context.read<QueueCubit>();
  }

  @override
  void dispose() {
    _queueNameController.dispose();
    super.dispose();
  }

  void _addQueue() {
    final queueNameController = TextEditingController();
    final queueSizeController = TextEditingController(text: '50');
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.backgroundLight,
          title: Text(context.loc('add_queue')),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppTextFields.textField(
                    context: dialogContext,
                    hintText: context.loc('queue_name'),
                    controller: queueNameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return context.loc('required_field');
                      }
                      if (value.length < 2) {
                        return context.loc('invalid_name');
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  AppTextFields.textField(
                    context: dialogContext,
                    hintText: 'Queue size (default 50)',
                    controller: queueSizeController,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return context.loc('required_field');
                      }
                      final intValue = int.tryParse(value);
                      if (intValue == null || intValue < 1) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                queueNameController.clear();
                queueSizeController.clear();
                Navigator.pop(dialogContext);
              },
              child: Text(context.loc('cancel')),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  final maxSize = int.parse(queueSizeController.text);
                  _queueCubit.createQueue(
                    name: queueNameController.text.trim(),
                    maxSize: maxSize,
                  );
                  queueNameController.clear();
                  queueSizeController.clear();
                  Navigator.pop(dialogContext);
                }
              },
              child: Text(context.loc('add')),
            ),
          ],
        );
      },
    );
  }

  void _deleteQueue(int queueId) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(context.loc('delete')),
        content: Text(context.loc('delete_queue_confirm')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(context.loc('cancel')),
          ),
          TextButton(
            onPressed: () {
              _queueCubit.deleteQueue(queueId);
              Navigator.pop(dialogContext);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(context.loc('queue_deleted')),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: Text(context.loc('delete')),
          ),
        ],
      ),
    );
  }

  void _toggleQueueStatus(int queueId) {
    _queueCubit.toggleQueueStatus(queueId);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(context.loc('queue_updated')),
        backgroundColor: AppColors.success,
      ),
    );
  }

  Widget _buildQueueCard(Queue queue) {
    return AppContainers.card(
      context: context,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QueuePage(
              queue: queue,
              parentCubit: _queueCubit,
            ),
          ),
        );
      },
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.access_time,
                  color: AppColors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      queue.name,
                      style: AppTextStyles.getAdaptiveStyle(
                        context,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${queue.waitingCount} ${context.loc('waiting')} • '
                      '${queue.servedCount} ${context.loc('served')}',
                      style: AppTextStyles.getAdaptiveStyle(
                        context,
                        fontSize: 14,
                        lightColor: AppColors.textSecondaryLight,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert),
                onSelected: (value) {
                  if (value == 'toggle') {
                    _toggleQueueStatus(queue.id);
                  } else if (value == 'delete') {
                    _deleteQueue(queue.id);
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'toggle',
                    child: Row(
                      children: [
                        Icon(
                          queue.isActive ? Icons.pause : Icons.play_arrow,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          queue.isActive
                              ? context.loc('pause')
                              : context.loc('activate'),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        const Icon(Icons.delete, size: 20, color: Colors.red),
                        const SizedBox(width: 8),
                        Text(
                          context.loc('delete'),
                          style: const TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatItem(
                icon: Icons.people_outline,
                title: context.loc('waiting'),
                value: '${queue.waitingCount}',
              ),
              _buildStatItem(
                icon: Icons.check_circle,
                title: context.loc('served'),
                value: '${queue.servedCount}',
              ),
              // avg/wait time removed
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: queue.currentSize / queue.maxSize,
            backgroundColor: AppColors.buttonSecondaryLight,
            color: queue.currentSize >= queue.maxSize
                ? AppColors.error
                : AppColors.primary,
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${queue.currentSize}/${queue.maxSize}',
                style: AppTextStyles.getAdaptiveStyle(
                  context,
                  fontSize: 12,
                  lightColor: AppColors.textSecondaryLight,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: queue.isActive
                      ? AppColors.success.withAlpha((0.1 * 255).round())
                      : AppColors.error.withAlpha((0.1 * 255).round()),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  queue.isActive
                      ? context.loc('active')
                      : context.loc('inactive'),
                  style: AppTextStyles.getAdaptiveStyle(
                    context,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    lightColor:
                        queue.isActive ? AppColors.success : AppColors.error,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: AppColors.primary),
            const SizedBox(width: 4),
            Text(
              value,
              style: AppTextStyles.getAdaptiveStyle(
                context,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: AppTextStyles.getAdaptiveStyle(
            context,
            fontSize: 12,
            lightColor: AppColors.textSecondaryLight,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      endDrawer: _buildDrawer(context),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addQueue,
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        icon: const Icon(Icons.add),
        label: Text(context.loc('add_queue')),
      ),
      body: SafeArea(
        child: BlocListener<QueueCubit, QueueState>(
          listener: (context, state) {
            if (state is QueueError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error),
                  backgroundColor: AppColors.error,
                ),
              );
            }
          },
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                title: Text(context.loc('your_queues')),
                automaticallyImplyLeading: false,
                backgroundColor: AppColors.backgroundLight,
                elevation: 0,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: () => context.read<QueueCubit>().refreshQueues(),
                  ),
                  Builder(
                    builder: (context) => IconButton(
                      icon: const Icon(Icons.menu),
                      onPressed: () => Scaffold.of(context).openEndDrawer(),
                    ),
                  ),
                ],
              ),
              BlocBuilder<QueueCubit, QueueState>(
                builder: (context, state) {
                  if (state is QueueError) {
                    return SliverToBoxAdapter(
                      child: AppStates.errorState(
                        message: state.error,
                        onRetry: () => context.read<QueueCubit>().loadQueues(),
                        context: context,
                      ),
                    );
                  } else if (state is QueueLoaded) {
                    final queues = state.queues;
                    final activeQueues = queues.where((q) => q.isActive).length;

                    if (queues.isEmpty) {
                      return SliverToBoxAdapter(
                        child: AppStates.emptyState(
                          message: context.loc('no_queues'),
                          subtitle: context.loc('add_queue_hint'),
                          context: context,
                        ),
                      );
                    }

                    return SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          if (index == 0) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 16,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${context.loc('welcome')}, ${widget.user.name}!',
                                    style: AppTextStyles.getAdaptiveStyle(
                                      context,
                                      fontSize: 16,
                                      lightColor: AppColors.textSecondaryLight,
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: AppContainers.statCard(
                                          title: context.loc('total_queues'),
                                          value: '${queues.length}',
                                          context: context,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: AppContainers.statCard(
                                          title: context.loc('active_now'),
                                          value: '$activeQueues',
                                          context: context,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                ],
                              ),
                            );
                          }

                          final queueIndex = index - 1;
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 8,
                            ),
                            child: _buildQueueCard(queues[queueIndex]),
                          );
                        },
                        childCount: queues.length + 1,
                      ),
                    );
                  }

                  return SliverToBoxAdapter(
                    child: AppStates.loadingState(context: context),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: Container(
        color: AppColors.backgroundLight,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: AppColors.primary),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Icon(Icons.business, color: AppColors.white, size: 48),
                  const SizedBox(height: 8),
                  Text(
                    context.loc('app_title'),
                    style: AppTextStyles.getAdaptiveStyle(
                      context,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      lightColor: AppColors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.user.businessName ?? widget.user.name,
                    style: AppTextStyles.getAdaptiveStyle(
                      context,
                      fontSize: 14,
                      lightColor:
                          AppColors.white.withAlpha((0.8 * 255).round()),
                    ),
                  ),
                ],
              ),
            ),
            _buildDrawerItem(
              context: context,
              icon: Icons.business,
              title: context.loc('business_profile'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(user: widget.user),
                  ),
                );
              },
            ),
            _buildDrawerItem(
              context: context,
              icon: Icons.settings,
              title: context.loc('settings'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SettingsPage(user: widget.user)),
                );
              },
            ),
            // analytics removed from drawer
            _buildDrawerItem(
              context: context,
              icon: Icons.help,
              title: context.loc('help'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const HelpSupportPage()),
                );
              },
            ),
            _buildDrawerItem(
              context: context,
              icon: Icons.info,
              title: context.loc('about'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AboutUsPage()),
                );
              },
            ),
            const Divider(),
            _buildDrawerItem(
              context: context,
              icon: Icons.logout,
              title: context.loc('sign_out'),
              iconColor: AppColors.error,
              textColor: AppColors.error,
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? iconColor,
    Color? textColor,
  }) {
    return ListTile(
      leading: Icon(icon, color: iconColor ?? AppColors.primary),
      title: Text(
        title,
        style: AppTextStyles.getAdaptiveStyle(
          context,
          fontSize: 16,
          lightColor: textColor ?? AppColors.textPrimaryLight,
        ),
      ),
      onTap: onTap,
    );
  }
}
