class QueueClient {
  final int? id;
  final int queueId;
  final int? userId;
  final String name;
  final String phone;
  final int position;
  final String status;
  final DateTime joinedAt;
  final DateTime? servedAt;
  final DateTime? notifiedAt;

  QueueClient({
    this.id,
    required this.queueId,
    required this.userId,
    required this.name,
    required this.phone,
    required this.position,
    required this.status,
    required this.joinedAt,
    this.servedAt,
    this.notifiedAt,
  });

  bool get served => status == 'served';
  bool get notified => status == 'notified';
  bool get waiting => status == 'waiting';
  bool get cancelled => status == 'cancelled';

  Map<String, dynamic> toMap() {
    return {
      'queue_id': queueId,
      'user_id': userId,
      'name': name,
      'phone': phone,
      'position': position,
      'status': status,
      'joined_at': joinedAt.millisecondsSinceEpoch,
      'served_at': servedAt?.millisecondsSinceEpoch,
      'notified_at': notifiedAt?.millisecondsSinceEpoch,
      if(id != null) 'id': id,
    };
  }

  factory QueueClient.fromMap(Map<String, dynamic> map) {
    return QueueClient(
      id: map['id'],
      queueId: map['queue_id'],
      userId: map['user_id'],
      name: map['name'],
      phone: map['phone'],
      position: map['position'],
      status: map['status'],
      joinedAt: DateTime.fromMillisecondsSinceEpoch(map['joined_at']),
      servedAt: map['served_at'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(map['served_at'])
          : null,
      notifiedAt: map['notified_at'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['notified_at'])
          : null,
    );
  }
}
