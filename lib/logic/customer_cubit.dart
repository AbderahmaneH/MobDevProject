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

  CustomerCubit(
      {required QueueRepository queueRepository,
      required UserRepository userRepository,
      required QueueClientRepository queueClientRepository,
      required int? userId})
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
      final joinedIds = await _queueClientRepository.getQueueIdsForUser(_userId, includeServed: true);
      final filtered = queues.where((q) => !joinedIds.contains(q.id)).toList();

      emit(QueuesSearched(queues: filtered));
    } catch (e) {
      emit(CustomerError(error: 'Search failed: $e'));
    }
  }

  Future<void> getAvailableQueues() async {
    emit(CustomerLoading());

    try {
      final allQueues = await _queueRepository.getAllQueues(activeOnly: true);
      final joinedIds = await _queueClientRepository.getQueueIdsForUser(_userId, includeServed: true);

      final availableQueues = allQueues
          .where((queue) => queue.currentSize < queue.maxSize && !joinedIds.contains(queue.id))
          .toList();

      emit(AvailableQueuesLoaded(queues: availableQueues));
    } catch (e) {
      emit(CustomerError(error: 'Failed to load available queues: $e'));
    }
  }

  Future<bool> joinQueue(int queueId) async {
    try {
      final currentlyJoinedCount =
          await _queueClientRepository.getActiveQueuesCountForUser(_userId);
      if (currentlyJoinedCount >= 3) {
        emit(
          CustomerError(
            error: QNowLocalizations.getTranslation('max_queues_reached'),
          ),
        );
        return false;
      }
      final user = await _userRepository.getUserById(_userId);
      if (user == null) {
        emit(const CustomerError(error: 'User not found'));
        return false;
      }

      final existingClient =
          await _queueClientRepository.getQueueClient(queueId, _userId);
      if (existingClient != null) {
        if (existingClient.status == 'served' || existingClient.served) {
          emit(CustomerNotification(
              message: QNowLocalizations.getTranslation(
                  'already_served_and_joined')));
        } else {
          emit(CustomerNotification(
              message: QNowLocalizations.getTranslation('already_in_queue')));
        }

        await getAvailableQueues();
        return false;
      }

      final queue = await _queueRepository.getQueueById(queueId);
      if (queue == null) {
        emit(const CustomerError(error: 'Queue not found'));
        return false;
      }

      if (queue.currentSize >= queue.maxSize) {
        emit(const CustomerError(error: 'Queue is full'));
        return false;
      }

      final nextPosition =
          await _queueClientRepository.getNextPosition(queueId);

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

      emit(QueueJoined(queueId: newQueueId));
      await loadJoinedQueues();
      return true;
    } catch (e) {
      emit(CustomerError(error: 'Failed to join queue: $e'));
      return false;
    }
  }

  Future<void> leaveQueue(int queueId) async {
    try {
      final client =
          await _queueClientRepository.getQueueClient(queueId, _userId);
      if (client == null) {
        emit(const CustomerError(error: 'Not in this queue'));
        return;
      }

      await _queueClientRepository.deleteQueueClient(client.id);
      await _queueClientRepository.reorderPositions(queueId);
      emit(QueueLeft(queueId: queueId));
      await loadJoinedQueues();
    } catch (e) {
      emit(CustomerError(error: 'Failed to leave queue: $e'));
    }
  }

  Future<int?> getPositionInQueue(int queueId) async {
    try {
      final client =
          await _queueClientRepository.getQueueClient(queueId, _userId);
      return client?.position;
    } catch (e) {
      return null;
    }
  }

  Future<int> getPeopleAheadInQueue(int queueId) async {
    try {
      final client =
          await _queueClientRepository.getQueueClient(queueId, _userId);
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
      // estimated wait removed from model/DB; return 0 for compatibility
      return 0;
    } catch (e) {
      return 0;
    }
  }

  void refreshQueues() {
    loadJoinedQueues();
  }
}
