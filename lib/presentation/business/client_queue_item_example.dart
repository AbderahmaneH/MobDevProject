import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/queue_cubit.dart';
import '../../database/models/queue_client_model.dart';
import '../../core/app_colors.dart';

/// Example widget showing how to notify clients from the business queue view
/// This is a reference implementation - integrate into your existing queue UI
class ClientQueueItem extends StatelessWidget {
  final QueueClient client;
  final bool isFirst;

  const ClientQueueItem({
    Key? key,
    required this.client,
    this.isFirst = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: isFirst ? 4 : 2,
      color: isFirst ? AppColors.primary.withOpacity(0.1) : null,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getStatusColor(),
          child: Text(
            client.position.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          client.name,
          style: TextStyle(
            fontWeight: isFirst ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Phone: ${client.phone}'),
            Text(
              'Status: ${_getStatusText()}',
              style: TextStyle(
                color: _getStatusColor(),
                fontWeight: FontWeight.w500,
              ),
            ),
            if (client.notifiedAt != null)
              Text(
                'Notified: ${_formatTime(client.notifiedAt!)}',
                style: const TextStyle(fontSize: 12),
              ),
          ],
        ),
        trailing: _buildActions(context),
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Notify button
        if (client.status == 'waiting' && isFirst)
          IconButton(
            icon: const Icon(Icons.notifications_active),
            color: AppColors.primary,
            tooltip: 'Notify Client',
            onPressed: () => _notifyClient(context),
          ),

        // Serve button
        if (client.status == 'waiting' || client.status == 'notified')
          IconButton(
            icon: const Icon(Icons.check_circle),
            color: Colors.green,
            tooltip: 'Mark as Served',
            onPressed: () => _serveClient(context),
          ),

        // Remove button
        IconButton(
          icon: const Icon(Icons.remove_circle),
          color: Colors.red,
          tooltip: 'Remove from Queue',
          onPressed: () => _removeClient(context),
        ),
      ],
    );
  }

  void _notifyClient(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Notify Client'),
        content: Text(
          'Send notification to ${client.name}?\n\n'
          'They will receive a notification that it\'s their turn.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<QueueCubit>().notifyClient(client.id);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Notification sent to ${client.name}'),
                  backgroundColor: Colors.green,
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            child: const Text('Send Notification'),
          ),
        ],
      ),
    );
  }

  void _serveClient(BuildContext context) {
    context.read<QueueCubit>().serveClient(client.id);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${client.name} marked as served'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _removeClient(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Remove Client'),
        content: Text('Remove ${client.name} from the queue?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<QueueCubit>().removeClientFromQueue(client.id);
            },
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor() {
    switch (client.status) {
      case 'waiting':
        return Colors.orange;
      case 'notified':
        return AppColors.primary;
      case 'served':
        return Colors.green;
      case 'cancelled':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText() {
    switch (client.status) {
      case 'waiting':
        return 'Waiting';
      case 'notified':
        return 'Notified - Ready';
      case 'served':
        return 'Served';
      case 'cancelled':
        return 'Cancelled';
      default:
        return 'Unknown';
    }
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inMinutes < 1) {
      return 'Just now';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else {
      return '${diff.inDays}d ago';
    }
  }
}

/// Example of how to display the queue with notification capability
class BusinessQueueView extends StatelessWidget {
  final List<QueueClient> clients;

  const BusinessQueueView({
    Key? key,
    required this.clients,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (clients.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people_outline, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No clients in queue',
              style: TextStyle(color: Colors.grey, fontSize: 18),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // Quick action for the first client
        if (clients.isNotEmpty && clients.first.status == 'waiting')
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton.icon(
              onPressed: () {
                context.read<QueueCubit>().notifyClient(clients.first.id);
              },
              icon: const Icon(Icons.notifications_active),
              label: Text('Notify Next Client (${clients.first.name})'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ),

        // Client list
        Expanded(
          child: ListView.builder(
            itemCount: clients.length,
            itemBuilder: (context, index) {
              return ClientQueueItem(
                client: clients[index],
                isFirst: index == 0,
              );
            },
          ),
        ),
      ],
    );
  }
}
