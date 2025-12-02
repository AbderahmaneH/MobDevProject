import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/app_colors.dart';
import '../../logic/queue_cubit.dart';
import '../../database/db_helper.dart';
import '../../database/tables.dart';
import '../../core/common_widgets.dart';
import '../../core/localization.dart';
class QueuePage extends StatelessWidget {
  final Queue queue;

  const QueuePage({super.key, required this.queue});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => QueueCubit(
        dbHelper: DatabaseHelper(),
        businessOwnerId: queue.businessOwnerId,
      )..loadQueues(),
      child: QueueView(queue: queue),
    );
  }
}

class QueueView extends StatefulWidget {
  final Queue queue;

  const QueueView({super.key, required this.queue});

  @override
  State<QueueView> createState() => _QueueViewState();
}

class _QueueViewState extends State<QueueView> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addClientFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController.text = '';
    _phoneController.text = '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _refreshQueue() {
    context.read<QueueCubit>().refreshQueues();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(context.loc('refreshed')),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _showAddClientDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.backgroundLight,
          title: Text(context.loc('add_customer')),
          content: Form(
            key: _addClientFormKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppTextFields.textField(
                  context: dialogContext,
                  hintText: context.loc('name'),
                  controller: _nameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return context.loc('required_field');
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                AppTextFields.textField(
                  context: dialogContext,
                  hintText: context.loc('phone'),
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return context.loc('required_field');
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                _nameController.clear();
                _phoneController.clear();
                Navigator.pop(dialogContext);
              },
              child: Text(context.loc('cancel')),
            ),
            ElevatedButton(
              onPressed: () {
                if (_addClientFormKey.currentState!.validate()) {
                  // Use the outer context to access QueueCubit
                  context.read<QueueCubit>().addClientToQueue(
                    queueId: widget.queue.id,
                    name: _nameController.text.trim(),
                    phone: _phoneController.text.trim(),
                  );
                  _nameController.clear();
                  _phoneController.clear();
                  Navigator.pop(dialogContext);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(context.loc('person_added')),
                      backgroundColor: AppColors.success,
                    ),
                  );
                }
              },
              child: Text(context.loc('add')),
            ),
          ],
        );
      },
    );
  }

  void _serveClient(QueueClient client) {
  showDialog(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: Text(context.loc('serve_customer')),
        content: Text('${context.loc('serve_confirm')} ${client.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(context.loc('cancel')),
          ),
          ElevatedButton(
            onPressed: () {
              // Use context from QueueView, not dialog context
              context.read<QueueCubit>().serveClient(client.id);
              Navigator.pop(dialogContext);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${client.name} ${context.loc('served')}'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            child: Text(context.loc('serve')),
          ),
        ],
      );
    },
  );
}
  void _notifyClient(QueueClient client) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.loc('notify_customer')),
        content: Text('${context.loc('notify_confirm')} ${client.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.loc('cancel')),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<QueueCubit>().notifyClient(client.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${client.name} ${context.loc('notified')}'),
                  backgroundColor: AppColors.info,
                ),
              );
            },
            child: Text(context.loc('notify')),
          ),
        ],
      ),
    );
  }

  void _removeClient(QueueClient client) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.loc('remove_customer')),
        content: Text('${context.loc('remove_confirm')} ${client.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.loc('cancel')),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<QueueCubit>().removeClientFromQueue(client.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${client.name} ${context.loc('removed')}'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: Text(context.loc('remove')),
          ),
        ],
      ),
    );
  }

  Widget _buildClientCard(QueueClient client) {
    return AppContainers.card(
      context: context,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Client avatar
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _getStatusColor(client.status),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(Icons.person, color: AppColors.white, size: 20),
              ),
              const SizedBox(width: 12),

              // Client info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      client.name,
                      style: AppTextStyles.getAdaptiveStyle(
                        context,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.phone,
                          size: 14,
                          color: AppColors.textSecondaryLight,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          client.phone,
                          style: AppTextStyles.getAdaptiveStyle(
                            context,
                            fontSize: 14,
                            lightColor: AppColors.textSecondaryLight,
                            darkColor: AppColors.textSecondaryDark,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: _getStatusColor(client.status),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            _getStatusText(client.status),
                            style: AppTextStyles.getAdaptiveStyle(
                              context,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              lightColor: AppColors.white,
                              darkColor: AppColors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Position
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '#${client.position}',
                  style: AppTextStyles.getAdaptiveStyle(
                    context,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    lightColor: AppColors.primary,
                    darkColor: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Actions
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: client.notified
                      ? null
                      : () => _notifyClient(client),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: client.notified
                          ? AppColors.buttonDisabledLight
                          : AppColors.warning,
                    ),
                  ),
                  child: Text(
                    client.notified
                        ? context.loc('notified')
                        : context.loc('notify'),
                    style: TextStyle(
                      color: client.notified
                          ? AppColors.buttonDisabledLight
                          : AppColors.warning,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: client.served ? null : () => _serveClient(client),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: client.served
                        ? AppColors.buttonDisabledLight
                        : AppColors.success,
                  ),
                  child: Text(
                    client.served
                        ? context.loc('served')
                        : context.loc('serve'),
                    style: TextStyle(
                      color: client.served
                          ? AppColors.textSecondaryLight
                          : AppColors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              IconButton(
                icon: Icon(Icons.delete, color: AppColors.error),
                onPressed: () => _removeClient(client),
              ),
            ],
          ),

          // Timestamps
          if (client.notifiedAt != null || client.servedAt != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                const Divider(),
                const SizedBox(height: 8),
                if (client.notifiedAt != null)
                  _buildTimestamp(
                    icon: Icons.notifications,
                    text:
                        '${context.loc('notified_at')}: '
                        '${_formatTime(client.notifiedAt!)}',
                  ),
                if (client.servedAt != null)
                  _buildTimestamp(
                    icon: Icons.check_circle,
                    text:
                        '${context.loc('served_at')}: '
                        '${_formatTime(client.servedAt!)}',
                  ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildTimestamp({required IconData icon, required String text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(icon, size: 14, color: AppColors.textSecondaryLight),
          const SizedBox(width: 8),
          Text(
            text,
            style: AppTextStyles.getAdaptiveStyle(
              context,
              fontSize: 12,
              lightColor: AppColors.textSecondaryLight,
              darkColor: AppColors.textSecondaryDark,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'waiting':
        return AppColors.primary;
      case 'notified':
        return AppColors.warning;
      case 'served':
        return AppColors.success;
      default:
        return AppColors.grey500;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'waiting':
        return context.loc('waiting');
      case 'notified':
        return context.loc('notified');
      case 'served':
        return context.loc('served');
      default:
        return status;
    }
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:'
        '${time.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: BlocListener<QueueCubit, QueueState>(
          listener: (context, state) {
            if (state is ClientAdded) {
              setState(() {});
            } else if (state is QueueError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error),
                  backgroundColor: AppColors.error,
                ),
              );
            }
          },
          child: BlocBuilder<QueueCubit, QueueState>(
            builder: (context, state) {
              final currentQueue = (state is QueueLoaded)
                  ? state.queues.firstWhere(
                      (q) => q.id == widget.queue.id,
                      orElse: () => widget.queue,
                    )
                  : widget.queue;

              return CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  // App Bar
                  SliverAppBar(
                    title: Text(currentQueue.name),
                    backgroundColor: AppColors.backgroundLight,
                    elevation: 0,
                    leading: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.pop(context),
                    ),
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.refresh),
                        onPressed: _refreshQueue,
                      ),
                    ],
                  ),

                  // Queue Info
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      child: Column(
                        children: [
                          // Queue Stats
                          AppContainers.card(
                            context: context,
                            padding: const EdgeInsets.all(20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildStatItem(
                                  title: context.loc('total'),
                                  value: '${currentQueue.clients.length}',
                                ),
                                _buildStatItem(
                                  title: context.loc('waiting'),
                                  value: '${currentQueue.waitingCount}',
                                ),
                                _buildStatItem(
                                  title: context.loc('served'),
                                  value: '${currentQueue.servedCount}',
                                ),
                                _buildStatItem(
                                  title: context.loc('notified'),
                                  value: '${currentQueue.notifiedCount}',
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Capacity Info
                          AppContainers.card(
                            context: context,
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      context.loc('capacity'),
                                      style: AppTextStyles.getAdaptiveStyle(
                                        context,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      '${currentQueue.currentSize}/'
                                      '${currentQueue.maxSize}',
                                      style: AppTextStyles.getAdaptiveStyle(
                                        context,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                LinearProgressIndicator(
                                  value:
                                      currentQueue.currentSize /
                                      currentQueue.maxSize,
                                  backgroundColor:
                                      AppColors.buttonSecondaryLight,
                                  color:
                                      currentQueue.currentSize >=
                                          currentQueue.maxSize
                                      ? AppColors.error
                                      : AppColors.primary,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  currentQueue.currentSize >=
                                          currentQueue.maxSize
                                      ? context.loc('queue_full')
                                      : '${currentQueue.maxSize - currentQueue.currentSize} '
                                            '${context.loc('spots_available')}',
                                  style: AppTextStyles.getAdaptiveStyle(
                                    context,
                                    fontSize: 12,
                                    lightColor:
                                        currentQueue.currentSize >=
                                            currentQueue.maxSize
                                        ? AppColors.error
                                        : AppColors.success,
                                    darkColor:
                                        currentQueue.currentSize >=
                                            currentQueue.maxSize
                                        ? AppColors.error
                                        : AppColors.success,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Clients List Header
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            context.loc('waiting_list'),
                            style: AppTextStyles.getAdaptiveStyle(
                              context,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '${currentQueue.clients.length} ${context.loc('customers')}',
                            style: AppTextStyles.getAdaptiveStyle(
                              context,
                              fontSize: 14,
                              lightColor: AppColors.textSecondaryLight,
                              darkColor: AppColors.textSecondaryDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Clients List
                  if (currentQueue.clients.isEmpty)
                    SliverToBoxAdapter(
                      child: AppStates.emptyState(
                        message: context.loc('no_customers'),
                        subtitle: context.loc('add_customer_hint'),
                        icon: Icons.people_outline,
                        context: context,
                      ),
                    )
                  else
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 8,
                          ),
                          child: _buildClientCard(currentQueue.clients[index]),
                        ),
                        childCount: currentQueue.clients.length,
                      ),
                    ),

                  // Bottom padding
                  const SliverToBoxAdapter(child: SizedBox(height: 100)),
                ],
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddClientDialog,
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        icon: const Icon(Icons.person_add),
        label: Text(context.loc('add_customer')),
      ),
    );
  }

  Widget _buildStatItem({required String title, required String value}) {
    return Column(
      children: [
        Text(
          value,
          style: AppTextStyles.getAdaptiveStyle(
            context,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: AppTextStyles.getAdaptiveStyle(
            context,
            fontSize: 12,
            lightColor: AppColors.textSecondaryLight,
            darkColor: AppColors.textSecondaryDark,
          ),
        ),
      ],
    );
  }
}
