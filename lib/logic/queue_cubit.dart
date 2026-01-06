import 'package:flutter_bloc/flutter_bloc.dart';
import '../database/repositories/queue_repository.dart';
import '../database/repositories/queue_client_repository.dart';
import '../database/models/queue_client_model.dart';
import '../database/models/queue_model.dart';
import '../services/notification_service.dart';
part 'queue_state.dart';

class QueueCubit extends Cubit<QueueState> {
  final QueueRepository _queueRepository;
  final QueueClientRepository _queueClientRepository;
  final int? _businessOwnerId;

  QueueCubit({
    required QueueRepository queueRepository,
    required QueueClientRepository queueClientRepository,
    required int? businessOwnerId,
  })  : _queueRepository = queueRepository,
        _queueClientRepository = queueClientRepository,
        _businessOwnerId = businessOwnerId,
        super(QueueInitial()) {
    loadQueues();
  }

  Future<void> loadQueues() async {
    emit(QueueLoading());

    try {
      final queues =
          await _queueRepository.getQueuesByBusinessOwner(_businessOwnerId);
      emit(QueueLoaded(queues: queues));
    } catch (e) {
      emit(QueueError(error: 'Failed to load queues: $e'));
    }
  }

  Future<void> createQueue({
    required String name,
    String? description,
    int maxSize = 50,
    int estimatedWaitTime = 5,
  }) async {
    try {
      final queue = Queue(
        id: 0,
        businessOwnerId: _businessOwnerId,
        name: name,
        description: description,
        maxSize: maxSize,
        estimatedWaitTime: estimatedWaitTime,
        isActive: true,
        createdAt: DateTime.now(),
      );

      emit(QueueCreated());
      await _queueRepository.insertQueue(queue);
      await loadQueues();
    } catch (e) {
      emit(QueueError(error: 'Failed to create queue: $e'));
    }
  }

  Future<void> updateQueue({
    required int queueId,
    required String name,
    String? description,
    int? maxSize,
    int? estimatedWaitTime,
    bool? isActive,
  }) async {
    try {
      final existingQueue = await _queueRepository.getQueueById(queueId);
      if (existingQueue == null) {
        emit(const QueueError(error: 'Queue not found'));
        return;
      }

      final updatedQueue = Queue(
        id: queueId,
        businessOwnerId: _businessOwnerId,
        name: name,
        description: description ?? existingQueue.description,
        maxSize: maxSize ?? existingQueue.maxSize,
        estimatedWaitTime: estimatedWaitTime ?? existingQueue.estimatedWaitTime,
        isActive: isActive ?? existingQueue.isActive,
        createdAt: existingQueue.createdAt,
        clients: existingQueue.clients,
      );

      emit(QueueUpdated());
      await _queueRepository.updateQueue(updatedQueue);
      await loadQueues();
    } catch (e) {
      emit(QueueError(error: 'Failed to update queue: $e'));
    }
  }

  Future<void> deleteQueue(int queueId) async {
    try {
      emit(QueueDeleted());
      await _queueRepository.deleteQueue(queueId);
      await loadQueues();
    } catch (e) {
      emit(QueueError(error: 'Failed to delete queue: $e'));
    }
  }

  Future<void> toggleQueueStatus(int queueId) async {
    try {
      final queue = await _queueRepository.getQueueById(queueId);
      if (queue == null) {
        emit(const QueueError(error: 'Queue not found'));
        return;
      }

      await updateQueue(
        queueId: queueId,
        name: queue.name,
        description: queue.description,
        maxSize: queue.maxSize,
        estimatedWaitTime: queue.estimatedWaitTime,
        isActive: !queue.isActive,
      );
    } catch (e) {
      emit(QueueError(error: 'Failed to toggle queue status: $e'));
    }
  }

  Future<void> addClientToQueue({
    required int queueId,
    required String name,
    required String phone,
    int? userId,
  }) async {
    try {
      final queue = await _queueRepository.getQueueById(queueId);
      if (queue == null) {
        emit(const QueueError(error: 'Queue not found'));
        return;
      }

      if (queue.currentSize >= queue.maxSize) {
        emit(const QueueError(error: 'Queue is full'));
        return;
      }

      final nextPosition =
          await _queueClientRepository.getNextPosition(queueId);

      final client = QueueClient(
        id: 0,
        queueId: queueId,
        userId: userId ?? 0,
        name: name,
        phone: phone,
        position: nextPosition,
        status: 'waiting',
        joinedAt: DateTime.now(),
      );

      emit(ClientAdded());
      await _queueClientRepository.insertQueueClient(client);
      await loadQueues();
    } catch (e) {
      emit(QueueError(error: 'Failed to add client: $e'));
    }
  }

  Future<void> removeClientFromQueue(int? clientId) async {
    try {
      emit(ClientRemoved());
      await _queueClientRepository.deleteQueueClient(clientId);
      await loadQueues();
    } catch (e) {
      emit(QueueError(error: 'Failed to remove client: $e'));
    }
  }

  Future<void> serveClient(int? clientId) async {
    try {
      emit(ClientServed());
      await _queueClientRepository.updateClientStatus(clientId, 'served');
      await loadQueues();
    } catch (e) {
      emit(QueueError(error: 'Failed to serve client: $e'));
    }
  }

  Future<void> notifyClient(int? clientId) async {
    try {
      if (clientId == null) {
        emit(const QueueError(error: 'Invalid client ID'));
        return;
      }

      // Get current state to find the client and queue details
      if (state is QueueLoaded) {
        final queues = (state as QueueLoaded).queues;
        QueueClient? client;
        Queue? queue;

        // Find the client in any of the queues
        for (final q in queues) {
          final foundClient = q.clients.firstWhere(
            (c) => c.id == clientId,
            orElse: () => QueueClient(
              queueId: 0,
              userId: null,
              name: '',
              phone: '',
              position: 0,
              status: '',
              joinedAt: DateTime.now(),
            ),
          );
          if (foundClient.id != null) {
            client = foundClient;
            queue = q;
            break;
          }
        }

        // Send notification if we found the client and they have a userId
        if (client != null && queue != null && client.userId != null) {
          await NotificationService().notifyClientAboutTurn(
            userId: client.userId!,
            clientName: client.name,
            phoneNumber: client.phone,
            queueName: queue.name,
            position: client.position,
          );
        }
      }

      emit(ClientNotified());
      await _queueClientRepository.updateClientStatus(clientId, 'notified');
      await loadQueues();
    } catch (e) {
      emit(QueueError(error: 'Failed to notify client: $e'));
    }
  }

  void refreshQueues() {
    loadQueues();
  }
}
