import 'package:flutter_bloc/flutter_bloc.dart';
import '../database/repositories/queue_repository.dart';
import '../database/repositories/queue_client_repository.dart';
import '../database/repositories/manual_customer_repository.dart';
import '../database/models/manual_customer_model.dart';
import '../database/models/queue_client_model.dart';
import '../database/models/queue_model.dart';
part 'queue_state.dart';

class QueueCubit extends Cubit<QueueState> {
  final QueueRepository _queueRepository;
  final QueueClientRepository _queueClientRepository;
  final ManualCustomerRepository? _manualCustomerRepository;
  final int? _businessOwnerId;

  QueueCubit({
    required QueueRepository queueRepository,
    required QueueClientRepository queueClientRepository,
    ManualCustomerRepository? manualCustomerRepository,
    required int? businessOwnerId,
  })  : _queueRepository = queueRepository,
        _queueClientRepository = queueClientRepository,
        _manualCustomerRepository = manualCustomerRepository,
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
  }) async {
    try {
      final queue = Queue(
        id: 0,
        businessOwnerId: _businessOwnerId,
        name: name,
        description: description,
        maxSize: maxSize,
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
        // estimatedWaitTime removed
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

  Future<void> addManualCustomer({required int queueId, required String name}) async {
    if (_manualCustomerRepository == null) {
      emit(QueueError(error: 'Manual customer repository not available'));
      return;
    }
    try {
      final manual = ManualCustomer(id: null, queueId: queueId, name: name, status: 'waiting');
      await _manualCustomerRepository!.insertManualCustomer(manual);
      emit(ClientAdded());
      await loadQueues();
    } catch (e) {
      emit(QueueError(error: 'Failed to add manual customer: $e'));
    }
  }

  Future<void> removeClientFromQueue(int? clientId) async {
    try {
      emit(ClientRemoved());
      if (clientId != null && clientId < 0) {
        final realId = -clientId;
        await _manualCustomerRepository?.deleteManualCustomer(realId);
      } else {
        await _queueClientRepository.deleteQueueClient(clientId);
        if (clientId != null) {
          // if it was a regular client, reorder positions
          int? queueId;
          if (state is QueueLoaded) {
            final queues = (state as QueueLoaded).queues;
            for (final q in queues) {
              final found = q.clients.firstWhere((c) => c.id == clientId, orElse: () => QueueClient(queueId: 0, userId: null, name: '', phone: '', position: 0, status: '', joinedAt: DateTime.now()));
              if (found.id == clientId) {
                queueId = q.id;
                break;
              }
            }
          }
          if (queueId != null) {
            await _queueClientRepository.reorderPositions(queueId);
          }
        }
      }
      await loadQueues();
    } catch (e) {
      emit(QueueError(error: 'Failed to remove client: $e'));
    }
  }

  Future<void> serveClient(int? clientId) async {
    try {
      if (clientId == null) {
        emit(const QueueError(error: 'Invalid client ID'));
        return;
      }

      emit(ClientServed());

      // Find the queueId for this client from current loaded state if possible
      int? queueId;
      if (state is QueueLoaded) {
        final queues = (state as QueueLoaded).queues;
        for (final q in queues) {
          final found = q.clients.firstWhere((c) => c.id == clientId, orElse: () => QueueClient(queueId: 0, userId: null, name: '', phone: '', position: 0, status: '', joinedAt: DateTime.now()));
          if (found.id != null) {
            queueId = q.id;
            break;
          }
        }
      }

      if (clientId < 0) {
        final realId = -clientId;
        await _manualCustomerRepository?.updateManualCustomerStatus(realId, 'served');
      } else {
        await _queueClientRepository.updateClientStatus(clientId, 'served');
        // Reorder positions for the queue to close any gaps (exclude served clients)
        if (queueId != null) {
          await _queueClientRepository.reorderPositions(queueId);
        }
      }

      await loadQueues();
    } catch (e) {
      emit(QueueError(error: 'Failed to serve client: $e'));
    }
  }

  Future<void> notifyClient(int? clientId) async {
    try {
      emit(ClientNotified());
      if (clientId != null && clientId < 0) {
        final realId = -clientId;
        await _manualCustomerRepository?.updateManualCustomerStatus(realId, 'notified');
      } else {
        await _queueClientRepository.updateClientStatus(clientId, 'notified');
      }
      await loadQueues();
    } catch (e) {
      emit(QueueError(error: 'Failed to notify client: $e'));
    }
  }

  void refreshQueues() {
    loadQueues();
  }
}
