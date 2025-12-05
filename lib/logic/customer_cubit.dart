import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/localization.dart';
import '../database/repositories/queue_repository.dart';
import '../database/repositories/queue_client_repository.dart';
import '../database/repositories/user_repository.dart';
import '../database/models/queue_client_model.dart';
import '../database/models/queue_model.dart';

part 'customer_state.dart';

class CustomerCubit extends Cubit<CustomerState> {
  final QueueRepository _queueRepository;
  final QueueClientRepository _queueClientRepository;
  final UserRepository _userRepository;
  final int? _userId;

  CustomerCubit({required QueueRepository queueRepository,required UserRepository userRepository, required QueueClientRepository queueClientRepository, required int? userId})
    : _queueRepository = queueRepository,
      _queueClientRepository = queueClientRepository,
      _userRepository = userRepository,
      _userId = userId,
      super(CustomerInitial()) {
    loadJoinedQueues();
  }

  Future<void> loadJoinedQueues() async {
    emit(CustomerLoading());

    try {
      final queues = await _queueClientRepository.getQueuesByUser(_userId);
      emit(CustomerLoaded(joinedQueues: queues));
    } catch (e) {
      emit(CustomerError(error: 'Failed to load joined queues: $e'));
    }
  }

  Future<void> searchQueues(String query) async {
    emit(CustomerLoading());

    try {
      final queues = await _queueRepository.searchQueues(query);
      emit(QueuesSearched(queues: queues));
    } catch (e) {
      emit(CustomerError(error: 'Search failed: $e'));
    }
  }

  Future<void> getAvailableQueues() async {
    emit(CustomerLoading());

    try {
      final allQueues = await _queueRepository.getAllQueues(activeOnly: true);
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
      final currentlyJoinedCount = await _queueClientRepository.getActiveQueuesCountForUser(_userId);
      if (currentlyJoinedCount >= 3) {
        emit(
          CustomerError(
            error: QNowLocalizations.getTranslation('max_queues_reached'),
          ),
        );
        return;
      }
      // First get user details
      final user = await _userRepository.getUserById(_userId);
      if (user == null) {
        emit(const CustomerError(error: 'User not found'));
        return;
      }

      // Check if already in queue
      final existingClient = await _queueClientRepository.getQueueClient(queueId, _userId);
      if (existingClient != null) {
        emit(const CustomerError(error: 'Already in this queue'));
        return;
      }

      // Check queue capacity
      final queue = await _queueRepository.getQueueById(queueId);
      if (queue == null) {
        emit(const CustomerError(error: 'Queue not found'));
        return;
      }

      if (queue.currentSize >= queue.maxSize) {
        emit(const CustomerError(error: 'Queue is full'));
        return;
      }

      // Get next position
      final nextPosition = await _queueClientRepository.getNextPosition(queueId);

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
      final newQueueId = await _queueClientRepository.insertQueueClient(client);

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
      final client = await _queueClientRepository.getQueueClient(queueId, _userId);
      if (client == null) {
        emit(const CustomerError(error: 'Not in this queue'));
        return;
      }

      await _queueClientRepository.deleteQueueClient(client.id);
      await _queueClientRepository.reorderPositions(queueId); // Reorder remaining clients
      // Notify listeners a queue was left (transient), then refresh joined queues
      emit(QueueLeft(queueId: queueId));
      await loadJoinedQueues();
    } catch (e) {
      emit(CustomerError(error: 'Failed to leave queue: $e'));
    }
  }

  Future<int?> getPositionInQueue(int queueId) async {
    try {
      final client = await _queueClientRepository.getQueueClient(queueId, _userId);
      return client?.position;
    } catch (e) {
      return null;
    }
  }

  Future<int> getPeopleAheadInQueue(int queueId) async {
    try {
      final client = await _queueClientRepository.getQueueClient(queueId, _userId);
      if (client == null) return 0;

      final allClients = await _queueClientRepository.getQueueClients(queueId);
      return allClients
          .where((c) => c.position < client.position && c.status == 'waiting')
          .length;
    } catch (e) {
      return 0;
    }
  }

  Future<double> getEstimatedWaitTime(int queueId) async {
    try {
      final queue = await _queueRepository.getQueueById(queueId);
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
