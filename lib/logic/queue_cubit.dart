import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../models/client.dart';
import '../models/queue.dart';
import '../services/supabase_service.dart';

part 'queue_state.dart';

class QueueCubit extends Cubit<QueueState> {
  QueueCubit() : super(QueueInitial());

  void createQueue({
    required String name,
    required String description,
    required int averageServiceTime,
  }) {
    try {
      final queue = Queue(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        description: description,
        averageServiceTime: averageServiceTime,
        clients: [],
        isActive: true,
      );
      emit(QueueCreated(queue));
    } catch (e) {
      emit(QueueError(e.toString()));
    }
  }

  void addClient({
    required Queue queue,
    required String name,
    required String phone,
    bool isManualCustomer = false,
  }) {
    try {
      final client = Client(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        phone: phone,
        joinedAt: DateTime.now(),
        isManualCustomer: isManualCustomer,
      );
      
      final updatedClients = [...queue.clients, client];
      final updatedQueue = queue.copyWith(clients: updatedClients);
      
      emit(ClientAdded(updatedQueue, client));
    } catch (e) {
      emit(QueueError(e.toString()));
    }
  }

  void removeClient({
    required Queue queue,
    required String clientId,
  }) {
    try {
      final updatedClients = queue.clients
          .where((client) => client.id != clientId)
          .toList();
      final updatedQueue = queue.copyWith(clients: updatedClients);
      
      emit(ClientRemoved(updatedQueue, clientId));
    } catch (e) {
      emit(QueueError(e.toString()));
    }
  }

  void updateClientPosition({
    required Queue queue,
    required String clientId,
    required int newPosition,
  }) {
    try {
      final clients = List<Client>.from(queue.clients);
      final clientIndex = clients.indexWhere((c) => c.id == clientId);
      
      if (clientIndex == -1) {
        throw Exception('Client not found');
      }
      
      final client = clients.removeAt(clientIndex);
      clients.insert(newPosition, client);
      
      final updatedQueue = queue.copyWith(clients: clients);
      emit(ClientPositionUpdated(updatedQueue));
    } catch (e) {
      emit(QueueError(e.toString()));
    }
  }

  void serveNextClient(Queue queue) {
    try {
      if (queue.clients.isEmpty) {
        throw Exception('No clients in queue');
      }
      
      final nextClient = queue.clients.first;
      final updatedClients = queue.clients.skip(1).toList();
      final updatedQueue = queue.copyWith(clients: updatedClients);
      
      emit(ClientServed(updatedQueue, nextClient));
    } catch (e) {
      emit(QueueError(e.toString()));
    }
  }

  void pauseQueue(Queue queue) {
    try {
      final updatedQueue = queue.copyWith(isActive: false);
      emit(QueuePaused(updatedQueue));
    } catch (e) {
      emit(QueueError(e.toString()));
    }
  }

  void resumeQueue(Queue queue) {
    try {
      final updatedQueue = queue.copyWith(isActive: true);
      emit(QueueResumed(updatedQueue));
    } catch (e) {
      emit(QueueError(e.toString()));
    }
  }

  void deleteQueue(Queue queue) {
    try {
      emit(QueueDeleted(queue.id));
    } catch (e) {
      emit(QueueError(e.toString()));
    }
  }

  void loadQueue(Queue queue) {
    try {
      emit(QueueLoaded(queue));
    } catch (e) {
      emit(QueueError(e.toString()));
    }
  }

  int getEstimatedWaitTime(Queue queue, String clientId) {
    final clientIndex = queue.clients.indexWhere((c) => c.id == clientId);
    if (clientIndex == -1) return 0;
    
    return clientIndex * queue.averageServiceTime;
  }

  int getQueuePosition(Queue queue, String clientId) {
    final index = queue.clients.indexWhere((c) => c.id == clientId);
    return index == -1 ? -1 : index + 1;
  }

  void updateQueue(Queue queue) {
    try {
      emit(QueueUpdated(queue));
    } catch (e) {
      emit(QueueError(e.toString()));
    }
  }

  void notifyClient({
    required Queue queue,
    required String clientId,
    required String message,
  }) async {
    try {
      final client = queue.clients.firstWhere((c) => c.id == clientId);
      final position = getQueuePosition(queue, clientId);
      final waitTime = getEstimatedWaitTime(queue, clientId);
      
      emit(ClientNotified(
        queue: queue,
        client: client,
        message: message,
        position: position,
        estimatedWaitTime: waitTime,
      ));

      // Add notification to Supabase if client is not a manual customer
      if (!client.isManualCustomer) {
        final supabaseService = SupabaseService();
        
        await supabaseService.createNotification(
          userId: client.phone, // Using phone as user_id
          queueId: queue.id,
          title: 'Queue Update',
          message: message,
          createdAt: DateTime.now().toIso8601String(),
          isRead: false,
        );
      }
    } catch (e) {
      emit(QueueError(e.toString()));
    }
  }

  void clearError() {
    emit(QueueInitial());
  }
}
