part of 'customer_cubit.dart';

abstract class CustomerState {
  const CustomerState();
}

class CustomerInitial extends CustomerState {}

class CustomerLoading extends CustomerState {}

class CustomerLoaded extends CustomerState {
  final List<Queue> joinedQueues;

  const CustomerLoaded({required this.joinedQueues});
}

class CustomerError extends CustomerState {
  final String error;

  const CustomerError({required this.error});
}

class QueuesSearched extends CustomerState {
  final List<Queue> queues;

  const QueuesSearched({required this.queues});
}

class AvailableQueuesLoaded extends CustomerState {
  final List<Queue> queues;

  const AvailableQueuesLoaded({required this.queues});
}

class QueueJoined extends CustomerState {
  final int queueId;

  const QueueJoined({required this.queueId});
}

class QueueLeft extends CustomerState {
  final int queueId;

  const QueueLeft({required this.queueId});
}