import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/models/queue_client.dart';
import '../../domain/models/queue_entry.dart';
import '../cubits/queue_cubit.dart';
import '../cubits/queue_state.dart';
import '../../core/theme/colors.dart';
import '../../core/utils/extensions.dart';

class QueuePage extends StatelessWidget {
  const QueuePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.loc('queue_management')),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<QueueCubit>().loadQueue(),
          ),
        ],
      ),
      body: BlocBuilder<QueueCubit, QueueState>(
        builder: (context, state) {
          if (state is QueueLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is QueueError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: AppColors.error),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    style: TextStyle(color: AppColors.error),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<QueueCubit>().loadQueue(),
                    child: Text(context.loc('retry')),
                  ),
                ],
              ),
            );
          }

          if (state is QueueLoaded) {
            final entries = state.entries;

            if (entries.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.people_outline, size: 64, color: AppColors.textSecondary),
                    const SizedBox(height: 16),
                    Text(
                      context.loc('no_clients_in_queue'),
                      style: TextStyle(
                        fontSize: 18,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<QueueCubit>().loadQueue();
              },
              child: ListView.builder(
                itemCount: entries.length,
                padding: const EdgeInsets.all(16),
                itemBuilder: (context, index) {
                  final entry = entries[index];
                  return _QueueEntryCard(
                    entry: entry,
                    position: index + 1,
                    onNotify: () => _notifyClient(context, entry.client),
                    onRemove: () => _removeClient(context, entry),
                  );
                },
              ),
            );
          }

          return const SizedBox();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddClientDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddClientDialog(BuildContext context) {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.loc('add_client')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: context.loc('name'),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: phoneController,
              decoration: InputDecoration(
                labelText: context.loc('phone'),
                border: const OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.loc('cancel')),
          ),
          ElevatedButton(
            onPressed: () {
              final name = nameController.text.trim();
              final phone = phoneController.text.trim();

              if (name.isNotEmpty && phone.isNotEmpty) {
                context.read<QueueCubit>().addClient(name, phone);
                Navigator.pop(context);
              }
            },
            child: Text(context.loc('add')),
          ),
        ],
      ),
    );
  }

  void _notifyClient(BuildContext context, QueueClient client) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(context.loc('notify_customer')),
        content: Text('${context.loc('notify_confirm')} ${client.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(context.loc('cancel')),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<QueueCubit>().notifyClient(client.id);
              Navigator.pop(dialogContext);
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

  void _removeClient(BuildContext context, QueueEntry entry) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.loc('remove_client')),
        content: Text('${context.loc('remove_confirm')} ${entry.client.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.loc('cancel')),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<QueueCubit>().removeClient(entry.id);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: Text(context.loc('remove')),
          ),
        ],
      ),
    );
  }
}

class _QueueEntryCard extends StatelessWidget {
  final QueueEntry entry;
  final int position;
  final VoidCallback onNotify;
  final VoidCallback onRemove;

  const _QueueEntryCard({
    required this.entry,
    required this.position,
    required this.onNotify,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.primary,
          child: Text(
            position.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          entry.client.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(entry.client.phone),
            const SizedBox(height: 4),
            Text(
              '${context.loc('joined')}: ${_formatTime(entry.joinedAt)}',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.notifications, color: AppColors.info),
              onPressed: onNotify,
            ),
            IconButton(
              icon: Icon(Icons.delete, color: AppColors.error),
              onPressed: onRemove,
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}
