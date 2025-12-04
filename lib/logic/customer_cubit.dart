import 'package:flutter_bloc/flutter_bloc.dart';
import '../database/tables.dart';
import '../core/localization.dart';
import '../database/db_helper.dart';

part 'customer_state.dart';

class CustomerCubit extends Cubit<CustomerState> {
  final DatabaseHelper _dbHelper;
  final int _userId;

  CustomerCubit({required DatabaseHelper dbHelper, required int userId})
    : _dbHelper = dbHelper,
      _userId = userId,
      super(CustomerInitial()) {
    loadJoinedQueues();
  }

  Future<void> loadJoinedQueues() async {
    emit(CustomerLoading());

    try {
      final queues = await _dbHelper.getQueuesByUser(_userId);
      emit(CustomerLoaded(joinedQueues: queues));
    } catch (e) {
      emit(CustomerError(error: 'Failed to load joined queues: $e'));
    }
  }

  Future<void> searchQueues(String query) async {
    emit(CustomerLoading());

    try {
      final queues = await _dbHelper.searchQueues(query);
      emit(QueuesSearched(queues: queues));
    } catch (e) {
      emit(CustomerError(error: 'Search failed: $e'));
    }
  }

  Future<void> getAvailableQueues() async {
    emit(CustomerLoading());

    try {
      final allQueues = await _dbHelper.getAllQueues(activeOnly: true);
      final availableQueues = allQueues
          .where((queue) => queue.currentSize < queue.maxSize)
          .toList();
      emit(AvailableQueuesLoaded(queues: availableQueues));
    } catch (e) {
      emit(CustomerError(error: 'Failed to load available queues: $e'));
    }
  }
  
  Future<void> joinQueue(int queueId) async {
    try {
      // Enforce maximum of 3 joined queues per customer
      final currentlyJoinedCount = await _dbHelper.getActiveQueuesCountForUser(_userId);
      if (currentlyJoinedCount >= 3) {
        emit(
          CustomerError(
            error: QNowLocalizations.getTranslation('max_queues_reached'),
          ),
        );
        return;
      }
      // First get user details
      final user = await _dbHelper.getUserById(_userId);
      if (user == null) {
        emit(CustomerError(error: 'User not found'));
        return;
      }

      // Check if already in queue
      final existingClient = await _dbHelper.getQueueClient(queueId, _userId);
      if (existingClient != null) {
        emit(CustomerError(error: 'Already in this queue'));
        return;
      }

      // Check queue capacity
      final queue = await _dbHelper.getQueueById(queueId);
      if (queue == null) {
        emit(CustomerError(error: 'Queue not found'));
        return;
      }

      if (queue.currentSize >= queue.maxSize) {
        emit(CustomerError(error: 'Queue is full'));
        return;
      }

      // Get next position
      final nextPosition = await _dbHelper.getNextPosition(queueId);

      // Add to queue
      final client = QueueClient(
        id: null,
        queueId: queueId,
        userId: _userId,
        name: user.name,
        phone: user.phone,
        position: nextPosition,
        status: 'waiting',
        joinedAt: DateTime.now(),
      );
      final newQueueId = await _dbHelper.insertQueueClient(client);

      // createdclient not used; no need to keep a duplicate object

      // Notify listeners a queue was joined (transient), then refresh joined queues
      emit(QueueJoined(queueId: newQueueId));
      await loadJoinedQueues(); // Refresh joined queues (final state will be CustomerLoaded)
    } catch (e) {
      emit(CustomerError(error: 'Failed to join queue: $e'));
    }
  }

  Future<void> leaveQueue(int queueId) async {
    try {
      final client = await _dbHelper.getQueueClient(queueId, _userId);
      if (client == null) {
        emit(CustomerError(error: 'Not in this queue'));
        return;
      }

      await _dbHelper.deleteQueueClient(client.id);
      await _dbHelper.reorderPositions(queueId); // Reorder remaining clients
      // Notify listeners a queue was left (transient), then refresh joined queues
      emit(QueueLeft(queueId: queueId));
      await loadJoinedQueues();
    } catch (e) {
      emit(CustomerError(error: 'Failed to leave queue: $e'));
    }
  }

  Future<int?> getPositionInQueue(int queueId) async {
    try {
      final client = await _dbHelper.getQueueClient(queueId, _userId);
      return client?.position;
    } catch (e) {
      return null;
    }
  }

  Future<int> getPeopleAheadInQueue(int queueId) async {
    try {
      final client = await _dbHelper.getQueueClient(queueId, _userId);
      if (client == null) return 0;

      final allClients = await _dbHelper.getQueueClients(queueId);
      return allClients
          .where((c) => c.position < client.position && c.status == 'waiting')
          .length;
    } catch (e) {
      return 0;
    }
  }

  Future<double> getEstimatedWaitTime(int queueId) async {
    try {
      final queue = await _dbHelper.getQueueById(queueId);
      if (queue == null) return 0;

      final peopleAhead = await getPeopleAheadInQueue(queueId);
      return peopleAhead * queue.estimatedWaitTime.toDouble();
    } catch (e) {
      return 0;
    }
  }

  void refreshQueues() {
    loadJoinedQueues();
  }
}
