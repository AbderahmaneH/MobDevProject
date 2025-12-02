import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/app_colors.dart';
import '../../logic/customer_cubit.dart';
import '../../database/db_helper.dart';
import '../../database/tables.dart';
import '../../core/common_widgets.dart';
import '../../core/localization.dart';
import '../drawer/profile_page.dart';
import '../drawer/settings_page.dart';
import '../drawer/about_us_page.dart';
import '../login_signup/login_page.dart';
import '../customer/join_queue_page.dart';
class CustomerPage extends StatelessWidget {
  final User user;

  const CustomerPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CustomerCubit(
        dbHelper: DatabaseHelper(),
        userId: user.id,
      ),
      child: CustomerView(user: user),
    );
  }
}

class CustomerView extends StatefulWidget {
  final User user;

  const CustomerView({super.key, required this.user});

  @override
  State<CustomerView> createState() => _CustomerViewState();
}

class _CustomerViewState extends State<CustomerView> {
  final _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
        context.read<CustomerCubit>().loadJoinedQueues();
      }
    });
  }

  void _searchQueues(String query) {
    if (query.isEmpty) {
      context.read<CustomerCubit>().loadJoinedQueues();
    } else {
      context.read<CustomerCubit>().searchQueues(query);
    }
  }

  void _leaveQueue(int queueId) {
    final customerCubit = context.read<CustomerCubit>();
    
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(context.loc('confirm')),
          content: Text(context.loc('leave_queue_confirm')),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(context.loc('cancel')),
            ),
            TextButton(
              onPressed: () {
                customerCubit.leaveQueue(queueId);
                Navigator.pop(dialogContext);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(context.loc('left_queue')),
                    backgroundColor: AppColors.success,
                  ),
                );
              },
              style: TextButton.styleFrom(
                foregroundColor: AppColors.error,
              ),
              child: Text(context.loc('leave')),
            ),
          ],
        );
      },
    );
  }

  Widget _buildQueueCard(Queue queue) {
    // Find user's position in this queue
    final userClient = queue.clients.firstWhere(
      (client) => client.userId == widget.user.id,
      orElse: () => QueueClient(
        id: 0,
        queueId: queue.id,
        userId: widget.user.id,
        name: '',
        phone: '',
        position: 0,
        status: '',
        joinedAt: DateTime.now(),
      ),
    );
    
    final position = userClient.position > 0 ? userClient.position : null;
    final peopleAhead = position != null 
        ? queue.clients.where((c) => c.position < position && c.status == 'waiting').length
        : 0;
    
    final estimatedWait = peopleAhead * queue.estimatedWaitTime;

    return AppContainers.card(
      context: context,
      onTap: () {
        // Show queue details
      },
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Queue icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.access_time,
                  color: AppColors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),

              // Queue info
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
                      '${queue.currentSize} ${context.loc('people_waiting')}',
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

              // Status badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: queue.isActive 
                      ? AppColors.success.withOpacity(0.1)
                      : AppColors.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  queue.isActive 
                      ? context.loc('active') 
                      : context.loc('inactive'),
                  style: AppTextStyles.getAdaptiveStyle(
                    context,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    lightColor: queue.isActive ? AppColors.success : AppColors.error,
                    darkColor: queue.isActive ? AppColors.success : AppColors.error,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Queue stats
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatItem(
                icon: Icons.people_outline,
                text: '${queue.currentSize}/${queue.maxSize}',
              ),
              _buildStatItem(
                icon: Icons.trending_up,
                text: position != null 
                    ? '${context.loc('position')} #$position'
                    : context.loc('not_joined'),
              ),
              _buildStatItem(
                icon: Icons.timer_outlined,
                text: '$estimatedWait ${context.loc('minutes')}',
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Actions - only show if user is in this queue
          if (position != null)
            Row(
              children: [
                Expanded(
                  child: AppButtons.secondaryButton(
                    text: context.loc('view_details'),
                    onPressed: () {
                      // TODO: Navigate to queue details
                    },
                    context: context,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppButtons.primaryButton(
                    text: context.loc('leave'),
                    onPressed: () => _leaveQueue(queue.id),
                    backgroundColor: AppColors.error,
                    context: context,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildStatItem({required IconData icon, required String text}) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.primary),
        const SizedBox(width: 4),
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
    );
  }
  
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      endDrawer: _buildDrawer(context),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push<bool?>(
            context,
            MaterialPageRoute(
              builder: (context) => JoinQueuePage(user: widget.user),
            ),
          );

          // If joined (true), refresh joined queues to show the newly-joined queue
          if (result == true) {
            try {
              await context.read<CustomerCubit>().loadJoinedQueues();
            } catch (_) {}
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(context.loc('joined_queue')),
                backgroundColor: AppColors.success,
              ),
            );
          }
        },
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        icon: const Icon(Icons.add),
        label: Text(context.loc('join_queue')),
      ),
      body: SafeArea(
        child: BlocListener<CustomerCubit, CustomerState>(
          listener: (context, state) {
            if (state is CustomerError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error),
                  backgroundColor: AppColors.error,
                ),
              );
            } else if (state is QueueLeft) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(context.loc('left_queue')),
                  backgroundColor: AppColors.success,
                ),
              );
            } else if (state is QueueJoined) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(context.loc('joined_queue')),
                  backgroundColor: AppColors.success,
                ),
              );
            }
          },
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // App Bar
              SliverAppBar(
                title: _isSearching
                    ? AppTextFields.searchField(
                        context: context,
                        hintText: context.loc('search_queues'),
                        controller: _searchController,
                        onChanged: _searchQueues,
                      )
                    : Text(context.loc('my_queues')),
                backgroundColor: AppColors.backgroundLight,
                elevation: 0,
                actions: [
                  IconButton(
                    icon: Icon(_isSearching ? Icons.close : Icons.search),
                    onPressed: _toggleSearch,
                  ),
                  Builder(
                    builder: (context) => IconButton(
                      icon: const Icon(Icons.menu),
                      onPressed: () => Scaffold.of(context).openEndDrawer(),
                    ),
                  ),
                ],
              ),

              // Content
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Welcome message
                      Text(
                        '${context.loc('welcome')}, ${widget.user.name}!',
                        style: AppTextStyles.getAdaptiveStyle(
                          context,
                          fontSize: 16,
                          lightColor: AppColors.textSecondaryLight,
                          darkColor: AppColors.textSecondaryDark,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Stats - Will be populated dynamically
                      BlocBuilder<CustomerCubit, CustomerState>(
                        builder: (context, state) {
                          if (state is CustomerLoaded) {
                            final joinedQueues = state.joinedQueues;
                            final activeQueues = joinedQueues.where((q) => q.isActive).length;
                            
                            return Row(
                              children: [
                                Expanded(
                                  child: AppContainers.statCard(
                                    title: context.loc('joined_queues'),
                                    value: '${joinedQueues.length}',
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
                            );
                          }
                          return Row(
                            children: [
                              Expanded(
                                child: AppContainers.statCard(
                                  title: context.loc('joined_queues'),
                                  value: '0',
                                  context: context,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: AppContainers.statCard(
                                  title: context.loc('active_now'),
                                  value: '0',
                                  context: context,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),

              // Queues List
              BlocBuilder<CustomerCubit, CustomerState>(
                builder: (context, state) {
                  if (state is CustomerLoading) {
                    return SliverToBoxAdapter(
                      child: AppStates.loadingState(context: context),
                    );
                  } else if (state is CustomerError) {
                    return SliverToBoxAdapter(
                      child: AppStates.errorState(
                        message: state.error,
                        onRetry: () => context
                            .read<CustomerCubit>()
                            .loadJoinedQueues(),
                        context: context,
                      ),
                    );
                  } else if (state is CustomerLoaded) {
                    final queues = state.joinedQueues;

                    if (queues.isEmpty) {
                      return SliverToBoxAdapter(
                        child: AppStates.emptyState(
                          message: context.loc('no_queues'),
                          context: context,
                        ),
                      );
                    }

                    return SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 8,
                          ),
                          child: _buildQueueCard(queues[index]),
                        ),
                        childCount: queues.length,
                      ),
                    );
                  } else if (state is QueuesSearched) {
                    final queues = state.queues;

                    if (queues.isEmpty) {
                      return SliverToBoxAdapter(
                        child: AppStates.emptyState(
                          message: context.loc('no_results'),
                          context: context,
                        ),
                      );
                    }

                    return SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 8,
                          ),
                          child: _buildQueueCard(queues[index]),
                        ),
                        childCount: queues.length,
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
            // Header
            DrawerHeader(
              decoration: BoxDecoration(color: AppColors.primary),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Icon(Icons.access_time_filled,
                      color: AppColors.white, size: 48),
                  const SizedBox(height: 8),
                  Text(
                    context.loc('app_title'),
                    style: AppTextStyles.getAdaptiveStyle(
                      context,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      lightColor: AppColors.white,
                      darkColor: AppColors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.user.name,
                    style: AppTextStyles.getAdaptiveStyle(
                      context,
                      fontSize: 14,
                      lightColor: AppColors.white.withOpacity(0.8),
                      darkColor: AppColors.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),

            // Menu Items
            _buildDrawerItem(
              context: context,
              icon: Icons.person,
              title: context.loc('profile'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(user: widget.user), // Pass actual user
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
                    builder: (context) => const SettingsPage(),
                  ),
                );
              },
            ),
            _buildDrawerItem(
              context: context,
              icon: Icons.help,
              title: context.loc('help'),
              onTap: () {
                // TODO: Navigate to help page
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
                  MaterialPageRoute(
                    builder: (context) => const AboutUsPage(),
                  ),
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
                  MaterialPageRoute(
                    builder: (context) => const LoginPage(),
                  ),
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
      leading: Icon(
        icon,
        color: iconColor ?? AppColors.primary,
      ),
      title: Text(
        title,
        style: AppTextStyles.getAdaptiveStyle(
          context,
          fontSize: 16,
          lightColor: textColor ?? AppColors.textPrimaryLight,
          darkColor: textColor ?? AppColors.textPrimaryDark,
        ),
      ),
      onTap: onTap,
    );
  }
}