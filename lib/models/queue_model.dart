class QueueClient {
  final String name;
  final String phone;
  bool notified;
  bool served;

  QueueClient({
    required this.name,
    required this.phone,
    this.notified = false,
    this.served = false,
  });
}

class Queue {
  final String name;
  final List<QueueClient> clients;
  final String ownerPhone;

  Queue({required this.name, required this.clients, required this.ownerPhone});

  int get peopleWaiting => clients.where((c) => !c.served).length;
}
