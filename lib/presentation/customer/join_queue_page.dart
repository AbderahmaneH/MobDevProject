import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/app_colors.dart';
import '../../logic/customer_cubit.dart';
import '../../database/db_helper.dart';
import '../../database/tables.dart';
import '../../core/common_widgets.dart';
import '../../core/localization.dart';

class JoinQueuePage extends StatelessWidget {
  final User user;

  const JoinQueuePage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    // If an ancestor CustomerCubit exists, use it so state updates are shared.
    // Otherwise create a local CustomerCubit so the page still works standalone.
    var hasAncestor = true;
    try {
      context.read<CustomerCubit>();
    } catch (_) {
      hasAncestor = false;
    }

    if (hasAncestor) {
      return JoinQueueView(user: user);
    }

    return BlocProvider(
      create: (context) => CustomerCubit(
        dbHelper: DatabaseHelper(),
        userId: user.id,
      )..getAvailableQueues(),
      child: JoinQueueView(user: user),
    );
  }
}

class JoinQueueView extends StatefulWidget {
  final User user;

  const JoinQueueView({super.key, required this.user});

  @override
  State<JoinQueueView> createState() => _JoinQueueViewState();
}

class _JoinQueueViewState extends State<JoinQueueView> {
  final _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      if (_isSearching && _searchController.text.isNotEmpty) {
        context.read<CustomerCubit>().searchQueues(_searchController.text);
      }
    });
    // Load available queues using the ancestor CustomerCubit (if present).
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        context.read<CustomerCubit>().getAvailableQueues();
      } catch (_) {
        // If no ancestor CustomerCubit is provided, ignore.
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _refreshQueues() {
    if (_isSearching && _searchController.text.isNotEmpty) {
      context.read<CustomerCubit>().searchQueues(_searchController.text);
    } else {
      context.read<CustomerCubit>().getAvailableQueues();
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(context.loc('refreshed')),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
        context.read<CustomerCubit>().getAvailableQueues();
      }
    });
  }

  void _joinQueue(int queueId) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(context.loc('join_queue')),
        content: Text(context.loc('join_queue_confirm')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(context.loc('cancel')),
          ),
          ElevatedButton(
            onPressed: () async {
              // Use the outer widget context to access the provided CustomerCubit
              try {
                await context.read<CustomerCubit>().joinQueue(queueId);
                // Close dialog then pop page returning a true result to indicate join
                Navigator.pop(dialogContext);
                if (Navigator.canPop(context)) {
                  Navigator.pop(context, true);
                } else {
                  Navigator.pop(context);
                }
              } catch (_) {
                Navigator.pop(dialogContext);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(context.loc('error')),
                    backgroundColor: AppColors.error,
                  ),
                );
              }
            },
            child: Text(context.loc('join')),
          ),
        ],
      ),
    );
  }

  Widget _buildQueueCard(Queue queue) {
    final isFull = queue.currentSize >= queue.maxSize;
    final estimatedWait = queue.currentSize * queue.estimatedWaitTime;

    return AppContainers.card(
      context: context,
      onTap: isFull ? null : () => _joinQueue(queue.id),
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
                  color: isFull ? AppColors.error : AppColors.primary,
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
                  color: isFull
                      ? AppColors.error.withOpacity(0.1)
                      : AppColors.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  isFull ? context.loc('full') : context.loc('available'),
                  style: AppTextStyles.getAdaptiveStyle(
                    context,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    lightColor: isFull ? AppColors.error : AppColors.success,
                    darkColor: isFull ? AppColors.error : AppColors.success,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Queue details
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailItem(
                icon: Icons.business,
                text: 'Business Name', // TODO: Get business name
              ),
              const SizedBox(height: 8),
              _buildDetailItem(
                icon: Icons.location_on,
                text: 'Business Location', // TODO: Get business address
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
                title: context.loc('capacity'),
                value: '${queue.currentSize}/${queue.maxSize}',
              ),
              _buildStatItem(
                icon: Icons.timer_outlined,
                title: context.loc('wait_time'),
                value: '$estimatedWait ${context.loc('minutes')}',
              ),
              _buildStatItem(
                icon: Icons.speed,
                title: context.loc('avg_time'),
                value: '${queue.estimatedWaitTime} min',
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Join button
          if (!isFull)
            AppButtons.primaryButton(
              text: context.loc('join_queue'),
              onPressed: () => _joinQueue(queue.id),
              context: context,
            )
          else
            AppButtons.secondaryButton(
              text: context.loc('queue_full'),
              onPressed: () {},
              context: context,
            ),
        ],
      ),
    );
  }

  Widget _buildDetailItem({required IconData icon, required String text}) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: AppColors.textSecondaryLight,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.getAdaptiveStyle(
              context,
              fontSize: 14,
              lightColor: AppColors.textSecondaryLight,
              darkColor: AppColors.textSecondaryDark,
            ),
          ),
        ),
      ],
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
                fontSize: 14,
                fontWeight: FontWeight.w600,
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
                      )
                    : Text(context.loc('join_queue')),
                backgroundColor: AppColors.backgroundLight,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
                actions: [
                  IconButton(
                    icon: Icon(_isSearching ? Icons.close : Icons.search),
                    onPressed: _toggleSearch,
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: _refreshQueues,
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
                      // Header
                      Text(
                        context.loc('available_queues'),
                        style: AppTextStyles.getAdaptiveStyle(
                          context,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        context.loc('join_queue_description'),
                        style: AppTextStyles.getAdaptiveStyle(
                          context,
                          fontSize: 14,
                          lightColor: AppColors.textSecondaryLight,
                          darkColor: AppColors.textSecondaryDark,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Tips
                      AppContainers.card(
                        context: context,
                        backgroundColor: AppColors.infoLight,
                        child: Row(
                          children: [
                            Icon(
                              Icons.lightbulb_outline,
                              color: AppColors.info,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                context.loc('queue_tips'),
                                style: AppTextStyles.getAdaptiveStyle(
                                  context,
                                  fontSize: 12,
                                  lightColor: AppColors.info,
                                  darkColor: AppColors.info,
                                ),
                              ),
                            ),
                          ],
                        ),
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
                            .getAvailableQueues(),
                        context: context,
                      ),
                    );
                  } else if (state is AvailableQueuesLoaded ||
                      state is QueuesSearched) {
                    final queues = state is AvailableQueuesLoaded
                        ? state.queues
                        : (state as QueuesSearched).queues;

                    if (queues.isEmpty) {
                      return SliverToBoxAdapter(
                        child: AppStates.emptyState(
                          message: _isSearching
                              ? context.loc('no_results')
                              : context.loc('no_available_queues'),
                          subtitle: _isSearching
                              ? context.loc('try_different_search')
                              : context.loc('check_back_later'),
                          icon: Icons.search_off,
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

              // Bottom padding
              const SliverToBoxAdapter(
                child: SizedBox(height: 100),
              ),
            ],
          ),
        ),
      ),
    );
  }
}