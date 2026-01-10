import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import '../../core/app_colors.dart';
import '../../logic/customer_cubit.dart';
import '../../core/common_widgets.dart';
import '../../core/localization.dart';
import '../../database/models/user_model.dart';
import '../../database/models/queue_model.dart';
import '../../database/repositories/user_repository.dart';
import '../../database/repositories/queue_repository.dart';
import '../../database/repositories/queue_client_repository.dart';

class JoinQueuePage extends StatelessWidget {
  final User user;

  const JoinQueuePage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    // Always create a local CustomerCubit for the Join Queue screen so
    // it can load available queues without affecting the parent's state.
    return BlocProvider(
      create: (context) => CustomerCubit(
        queueRepository: RepositoryProvider.of<QueueRepository>(context),
        queueClientRepository:
            RepositoryProvider.of<QueueClientRepository>(context),
        userRepository: RepositoryProvider.of<UserRepository>(context),
        userId: user.id,
      ),
      child: JoinQueueView(user: user),
    );
  }
}

class JoinQueueView extends StatefulWidget {
  final User user;
  final bool fetchOnInit;

  const JoinQueueView({super.key, required this.user, this.fetchOnInit = true});

  @override
  State<JoinQueueView> createState() => _JoinQueueViewState();
}

class _JoinQueueViewState extends State<JoinQueueView> {
  final _searchController = TextEditingController();
  bool _isSearching = false;
  bool _searchByLocation = false;
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      if (_isSearching && _searchController.text.isNotEmpty) {
        context.read<CustomerCubit>().searchQueues(_searchController.text);
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.fetchOnInit) {
        try {
          context.read<CustomerCubit>().getAvailableQueues();
        } catch (_) {}
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
        _searchByLocation = false;
        context.read<CustomerCubit>().getAvailableQueues();
      }
    });
  }

  Future<void> _toggleLocationSearch() async {
    if (!_searchByLocation) {
      // Enable location search
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(context.loc('location_permission_denied')),
              backgroundColor: AppColors.error,
            ),
          );
        }
        return;
      }

      try {
        final position = await Geolocator.getCurrentPosition();
        setState(() {
          _currentPosition = position;
          _searchByLocation = true;
        });
        
        if (mounted) {
          context.read<CustomerCubit>().searchQueuesByLocation(
            latitude: position.latitude,
            longitude: position.longitude,
            maxDistanceKm: 50,
            searchQuery: _searchController.text.isEmpty ? null : _searchController.text,
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to get location: $e'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    } else {
      // Disable location search
      setState(() {
        _searchByLocation = false;
      });
      _refreshQueues();
    }
  }

  void _joinQueue(int queueId) {
    final cancelLabel = context.loc('cancel');
    final joinLabel = context.loc('join');

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(context.loc('join_queue')),
        content: Text(context.loc('join_queue_confirm')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(cancelLabel),
          ),
          ElevatedButton(
            onPressed: () async {
              final customerCubit = context.read<CustomerCubit>();
              final navigator = Navigator.of(context);
              final messenger = ScaffoldMessenger.of(context);
              final canPopNow = navigator.canPop();
              final errorMsg = context.loc('error');
              try {
                final joined = await customerCubit.joinQueue(queueId);
                if (!mounted) return;

                if (!joined) {
                  Navigator.pop(dialogContext);
                  return;
                }

                Navigator.pop(dialogContext);
                if (canPopNow) {
                  navigator.pop(true);
                } else {
                  navigator.pop();
                }
              } catch (_) {
                Navigator.pop(dialogContext);
                if (!mounted) return;
                messenger.showSnackBar(
                  SnackBar(
                    content: Text(errorMsg),
                    backgroundColor: AppColors.error,
                  ),
                );
              }
            },
            child: Text(joinLabel),
          ),
        ],
      ),
    );
  }

  Widget _buildQueueCard(Queue queue) {
    final isFull = queue.currentSize >= queue.maxSize;
    // estimated wait removed

    return AppContainers.card(
      context: context,
      onTap: isFull ? null : () => _joinQueue(queue.id),
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
                  color: isFull ? AppColors.error : AppColors.primary,
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
                      '${queue.currentSize} ${context.loc('people_waiting')}',
                      style: AppTextStyles.getAdaptiveStyle(
                        context,
                        fontSize: 14,
                        lightColor: AppColors.textSecondaryLight,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isFull
                      ? AppColors.error.withAlpha((0.1 * 255).round())
                      : AppColors.success.withAlpha((0.1 * 255).round()),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  isFull ? context.loc('full') : context.loc('available'),
                  style: AppTextStyles.getAdaptiveStyle(
                    context,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    lightColor: isFull ? AppColors.error : AppColors.success,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder<User?>(
                future: RepositoryProvider.of<UserRepository>(context)
                    .getUserById(queue.businessOwnerId),
                builder: (context, snapshot) {
                  final businessName =
                      snapshot.data?.businessName ?? snapshot.data?.name ?? '—';
                  return _buildDetailItem(
                    icon: Icons.business,
                    text: businessName,
                  );
                },
              ),
              const SizedBox(height: 8),
              FutureBuilder<User?>(
                future: RepositoryProvider.of<UserRepository>(context)
                    .getUserById(queue.businessOwnerId),
                builder: (context, snapshot) {
                  final address = snapshot.data?.businessAddress ?? '—';
                  return _buildDetailItem(
                    icon: Icons.location_on,
                    text: address,
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatItem(
                icon: Icons.people_outline,
                title: context.loc('capacity'),
                value: '${queue.currentSize}/${queue.maxSize}',
              ),
            ],
          ),
          const SizedBox(height: 16),
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

  Widget _buildQueueCardWithDistance(Queue queue, double distance, Map<String, dynamic> item) {
    final isFull = queue.currentSize >= queue.maxSize;
    final businessName = item['businessName'] ?? '—';
    final address = item['address'] ?? '—';
    final distanceText = distance < 1 
        ? '${(distance * 1000).round()} m' 
        : '${distance.toStringAsFixed(1)} km';

    return AppContainers.card(
      context: context,
      onTap: isFull ? null : () => _joinQueue(queue.id),
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
                  color: isFull ? AppColors.error : AppColors.primary,
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
                    Row(
                      children: [
                        const Icon(
                          Icons.near_me,
                          size: 14,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          distanceText,
                          style: AppTextStyles.getAdaptiveStyle(
                            context,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            lightColor: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '• ${queue.currentSize} waiting',
                          style: AppTextStyles.getAdaptiveStyle(
                            context,
                            fontSize: 13,
                            lightColor: AppColors.textSecondaryLight,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isFull
                      ? AppColors.error.withAlpha((0.1 * 255).round())
                      : AppColors.success.withAlpha((0.1 * 255).round()),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  isFull ? context.loc('full') : context.loc('available'),
                  style: AppTextStyles.getAdaptiveStyle(
                    context,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    lightColor: isFull ? AppColors.error : AppColors.success,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailItem(
                icon: Icons.business,
                text: businessName,
              ),
              const SizedBox(height: 8),
              _buildDetailItem(
                icon: Icons.location_on,
                text: address,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatItem(
                icon: Icons.people_outline,
                title: context.loc('capacity'),
                value: '${queue.currentSize}/${queue.maxSize}',
              ),
            ],
          ),
          const SizedBox(height: 16),
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
            } else if (state is CustomerNotification) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                ),
              );
            }
          },
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
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
                    icon: Icon(
                      _searchByLocation ? Icons.location_on : Icons.location_off,
                      color: _searchByLocation ? AppColors.primary : null,
                    ),
                    onPressed: _toggleLocationSearch,
                    tooltip: _searchByLocation ? 'Disable location search' : 'Search nearby',
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: _refreshQueues,
                  ),
                ],
              ),
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
                        ),
                      ),
                      const SizedBox(height: 20),

                      AppContainers.card(
                        context: context,
                        backgroundColor: AppColors.infoLight,
                        child: Row(
                          children: [
                            const Icon(
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
                        onRetry: () =>
                            context.read<CustomerCubit>().getAvailableQueues(),
                        context: context,
                      ),
                    );
                  } else if (state is AvailableQueuesLoaded ||
                      state is QueuesSearched ||
                      state is QueuesSearchedByLocation) {
                    
                    if (state is QueuesSearchedByLocation) {
                      // Handle location-based search results
                      final results = state.results;
                      
                      if (results.isEmpty) {
                        return SliverToBoxAdapter(
                          child: AppStates.emptyState(
                            message: 'No queues found nearby',
                            context: context,
                          ),
                        );
                      }
                      
                      return SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final item = results[index];
                              final queue = item['queue'] as Queue;
                              final distance = item['distance'] as double;
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: _buildQueueCardWithDistance(queue, distance, item),
                              );
                            },
                            childCount: results.length,
                          ),
                        ),
                      );
                    }
                    
                    // Handle regular search results
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
