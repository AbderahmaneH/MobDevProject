part of 'queue_cubit.dart'; // 1llows the two files to share private variables

abstract class QueueState { // Parent class
  const QueueState(); // Constructor
}

class QueueInitial extends QueueState {} // Starting state

class QueueLoading extends QueueState {} // Asynchronous operation is in progress

class QueueLoaded extends QueueState { // Success state
  final List<Queue> queues; // Carries data
  const QueueLoaded({required this.queues});
}

class QueueError extends QueueState { // Failure state
  final String error; // Carries error message
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
