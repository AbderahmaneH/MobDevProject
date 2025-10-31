// lib/queues_database.dart
import '../models/queue_model.dart';

class UserQueues {
  final String userPhone;
  final List<Queue> queues;

  UserQueues({required this.userPhone, required this.queues});
}

final List<UserQueues> queuesDatabase = [];