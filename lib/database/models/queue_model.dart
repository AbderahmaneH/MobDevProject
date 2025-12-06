import 'queue_client_model.dart';

class Queue {
  final int id;
  final int? businessOwnerId;
  final String name;
  final String? description;
  final int maxSize;
  final int estimatedWaitTime;
  final bool isActive;
  final DateTime createdAt;
  List<QueueClient> clients;

  Queue({
    required this.id,
    required this.businessOwnerId,
    required this.name,
    this.description,
    this.maxSize = 50,
    this.estimatedWaitTime = 5,
    this.isActive = true,
    required this.createdAt,
    this.clients = const [],
  });

  int get currentSize => clients.length;
  int get waitingCount => clients.where((c) => c.status == 'waiting').length;
  int get servedCount => clients.where((c) => c.status == 'served').length;
  int get notifiedCount => clients.where((c) => c.status == 'notified').length;

  Map<String, dynamic> toMap() {
    final map = {
      'business_owner_id': businessOwnerId,
      'name': name,
      'description': description,
      'max_size': maxSize,
      'estimated_wait_time': estimatedWaitTime,
      'is_active': isActive ? 1 : 0,
      'created_at': createdAt.millisecondsSinceEpoch,
    };
    if (id != 0) {
      map['id'] = id;
    }
    return map;
  }

  factory Queue.fromMap(Map<String, dynamic> map) {
    return Queue(
      id: map['id'],
      businessOwnerId: map['business_owner_id'],
      name: map['name'],
      description: map['description'],
      maxSize: map['max_size'],
      estimatedWaitTime: map['estimated_wait_time'],
      isActive: map['is_active'] == 1,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at']),
      clients: [],
    );
  }
}
