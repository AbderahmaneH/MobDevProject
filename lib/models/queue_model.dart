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
  List<QueueClient> clients;
  final String ownerPhone; // Add this

  Queue({
    required this.name,
    required this.clients,
    required this.ownerPhone, // Add this
  });

  int get peopleWaiting => clients.length;
}