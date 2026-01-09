part of 'queue_cubit.dart';

abstract class QueueState {
  const QueueState();
}

class QueueInitial extends QueueState {}

class QueueLoading extends QueueState {}

class QueueLoaded extends QueueState {
  final List<Queue> queues;

  const QueueLoaded({required this.queues});
}

class QueueError extends QueueState {
  final String error;

  const QueueError({required this.error});
}

class QueueCreated extends QueueState {}

class QueueUpdated extends QueueState {}

class QueueDeleted extends QueueState {}

class ClientAdded extends QueueState {}

class ClientRemoved extends QueueState {}

class ClientServed extends QueueState {}

class ClientNotified extends QueueState {}

class ClientNotificationSuccess extends QueueState {
  final int clientId;
  final String message;

  const ClientNotificationSuccess({required this.clientId, required this.message});
}

class ClientNotificationFailed extends QueueState {
  final String error;
  final int clientId;

  const ClientNotificationFailed({required this.error, required this.clientId});
}
