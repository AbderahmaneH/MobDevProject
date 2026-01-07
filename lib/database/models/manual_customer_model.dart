class ManualCustomer {
  final int? id;
  final int queueId;
  final String name;
  final String status;
  final DateTime? servedAt;

  ManualCustomer({this.id, required this.queueId, required this.name, this.status = 'waiting', this.servedAt});

  Map<String, dynamic> toMap() {
    final map = {
      if (id != null) 'id': id,
      'queue_id': queueId,
      'name': name,
      'status': status,
      'served_at': servedAt?.millisecondsSinceEpoch,
    };
    return map;
  }

  factory ManualCustomer.fromMap(Map<String, dynamic> map) {
    return ManualCustomer(
      id: map['id'],
      queueId: map['queue_id'],
      name: map['name'],
      status: map['status'] ?? 'waiting',
      servedAt: map['served_at'] != null ? DateTime.fromMillisecondsSinceEpoch(map['served_at']) : null,
    );
  }
}
