import 'package:flutter_bloc/flutter_bloc.dart';
import '../database/repositories/queue_repository.dart';
import '../database/repositories/queue_client_repository.dart';
import '../database/models/queue_client_model.dart';
import '../database/models/queue_model.dart';

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
      final queues = await _queueRepository.getQueuesByBusinessOwner(_businessOwnerId);
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

      await _queueRepository.insertQueue(queue);
      await loadQueues(); // Refresh the list
      emit(QueueCreated());
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

      await _queueRepository.updateQueue(updatedQueue);
      await loadQueues();
      emit(QueueUpdated());
    } catch (e) {
      emit(QueueError(error: 'Failed to update queue: $e'));
    }
  }

  Future<void> deleteQueue(int queueId) async {
    try {
      await _queueRepository.deleteQueue(queueId);
      await loadQueues();
      emit(QueueDeleted());
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

      final nextPosition = await _queueClientRepository.getNextPosition(queueId);

      final client = QueueClient(
        id: 0,
        queueId: queueId,
        userId: userId ?? 0, // 0 for walk-in customers
        name: name,
        phone: phone,
        position: nextPosition,
        status: 'waiting',
        joinedAt: DateTime.now(),
      );

      await _queueClientRepository.insertQueueClient(client);
      await loadQueues(); // Refresh to show updated queue
      emit(ClientAdded());
    } catch (e) {
      emit(QueueError(error: 'Failed to add client: $e'));
    }
  }

  Future<void> removeClientFromQueue(int? clientId) async {
    try {
      await _queueClientRepository.deleteQueueClient(clientId);
      await loadQueues();
      emit(ClientRemoved());
    } catch (e) {
      emit(QueueError(error: 'Failed to remove client: $e'));
    }
  }

  Future<void> serveClient(int? clientId) async {
    try {
      await _queueClientRepository.updateClientStatus(clientId, 'served');
      await loadQueues();
      emit(ClientServed());
    } catch (e) {
      emit(QueueError(error: 'Failed to serve client: $e'));
    }
  }

  Future<void> notifyClient(int? clientId) async {
    try {
      await _queueClientRepository.updateClientStatus(clientId, 'notified');
      await loadQueues();
      emit(ClientNotified());
    } catch (e) {
      emit(QueueError(error: 'Failed to notify client: $e'));
    }
  }

  void refreshQueues() {
    loadQueues();
  }
  
}
