import 'package:flutter/material.dart';
import '../models/queue_model.dart';
import '../queues_database.dart';

class WaitingListPage extends StatefulWidget {
  final Queue queue;
  const WaitingListPage({super.key, required this.queue});

  @override
  State<WaitingListPage> createState() => _WaitingListPageState();
}

class _WaitingListPageState extends State<WaitingListPage> {
  late List<QueueClient> clients;

  @override
  void initState() {
    super.initState();
    clients = List.from(widget.queue.clients);
  }

  void _showAddClientDialog() {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFFF5F5F3),
          surfaceTintColor: Colors.transparent,
          title: const Text(
            'Add New Person',
            style: TextStyle(
              fontFamily: 'Lora',
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: 'Enter full name',
                    hintStyle: const TextStyle(
                      fontFamily: 'Poppins',
                      color: Color(0xFF9CA3AF),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: Color(0xFFE5E5E7),
                        width: 1.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: Color(0xFF333333),
                        width: 1.5,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Name is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    hintText: 'Enter phone number',
                    hintStyle: const TextStyle(
                      fontFamily: 'Poppins',
                      color: Color(0xFF9CA3AF),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: Color(0xFFE5E5E7),
                        width: 1.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: Color(0xFF333333),
                        width: 1.5,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Phone number is required';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Color(0xFF6B7280),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final newClient = QueueClient(
                    name: nameController.text,
                    phone: phoneController.text,
                  );

                  setState(() {
                    clients.add(newClient);
                    // Update the original queue
                    widget.queue.clients.add(newClient);
                  });

                  // Update the queues database
                  _updateQueuesDatabase();

                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Person added to queue!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF333333),
              ),
              child: const Text(
                'Add',
                style: TextStyle(fontFamily: 'Poppins', color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  void _serveClient(int index) {
    // Store the client info before marking as served
    final clientName = clients[index].name;
    final clientPhone = clients[index].phone;

    setState(() {
      clients[index].served = true;
    });

    // Remove after 1 second with animation
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          // Remove by object reference instead of index
          clients.removeWhere(
            (client) =>
                client.name == clientName && client.phone == clientPhone,
          );
          // Also remove from original queue
          widget.queue.clients.removeWhere(
            (client) =>
                client.name == clientName && client.phone == clientPhone,
          );
        });

        // Update the queues database after removal
        _updateQueuesDatabase();
      }
    });
  }

  void _updateQueuesDatabase() {
    // Find the user's queues in the database and update them
    final userQueueIndex = queuesDatabase.indexWhere(
      (uq) => uq.userPhone == widget.queue.ownerPhone,
    );
    if (userQueueIndex != -1) {
      final userQueues = queuesDatabase[userQueueIndex].queues;
      final queueIndex = userQueues.indexWhere(
        (q) => q.name == widget.queue.name,
      );
      if (queueIndex != -1) {
        // Update the queue in the database
        userQueues[queueIndex].clients = List.from(clients);
        setState(() {}); // Trigger UI update
      }
    }
  }

  void _notifyClient(int index) {
    setState(() {
      clients[index].notified = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Notified ${clients[index].name}'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final waitingCount = clients.where((c) => !c.served).length;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F3),
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              backgroundColor: const Color(0xFFF5F5F3),
              surfaceTintColor: Colors.transparent,
              elevation: 0,
              floating: true,
              snap: true,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Color(0xFF333333)),
                onPressed: () => Navigator.pop(context),
              ),
              centerTitle: true,
              title: Text(
                widget.queue.name,
                style: const TextStyle(
                  fontFamily: 'Lora',
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 6),
                    // Header Section
                    Center(
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(25),
                            decoration: BoxDecoration(
                              color: const Color(0xFF333333),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.people_alt,
                              color: Colors.white,
                              size: 48,
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            "Waiting List",
                            style: TextStyle(
                              fontFamily: 'Lora',
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF333333),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "$waitingCount ${waitingCount == 1 ? 'person' : 'people'} in queue",
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              color: Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Stats Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatItem('Total', '${clients.length}'),
                          _buildStatItem('Waiting', '$waitingCount'),
                          _buildStatItem(
                            'Served',
                            '${clients.where((c) => c.served).length}',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // Clients List
            if (clients.isEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Center(
                    child: Text(
                      "No one in queue\nTap the button below to add people",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Color(0xFF6B7280),
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              )
            else
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 8,
                    ),
                    child: AnimatedPersonCard(
                      person: clients[index],
                      onServe: () => _serveClient(index),
                      onNotify: () => _notifyClient(index),
                    ),
                  ),
                  childCount: clients.length,
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddClientDialog,
        backgroundColor: const Color(0xFF333333),
        icon: const Icon(Icons.add, color: Color(0xFFE5E5E7)),
        label: const Text(
          'Add Person',
          style: TextStyle(
            fontFamily: 'Poppins',
            color: Color(0xFFE5E5E7),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String title, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF333333),
            fontFamily: 'Poppins',
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF6B7280),
            fontFamily: 'Poppins',
          ),
        ),
      ],
    );
  }
}

class AnimatedPersonCard extends StatelessWidget {
  final QueueClient person;
  final VoidCallback onServe;
  final VoidCallback onNotify;

  const AnimatedPersonCard({
    super.key,
    required this.person,
    required this.onServe,
    required this.onNotify,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.only(bottom: 8),
      child: Card(
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFF333333),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          person.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF333333),
                            fontFamily: 'Poppins',
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              Icons.phone,
                              size: 14,
                              color: Color(0xFF6B7280),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              person.phone,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF6B7280),
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: person.notified ? null : onNotify,
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: person.notified
                              ? const Color(0xFFE5E5E7)
                              : const Color(0xFF333333),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(
                        person.notified ? 'Notified' : 'Notify',
                        style: TextStyle(
                          color: person.notified
                              ? const Color(0xFF6B7280)
                              : const Color(0xFF333333),
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: person.served ? null : onServe,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: person.served
                            ? const Color(0xFFE5E5E7)
                            : const Color(0xFF333333),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(
                        person.served ? 'Served' : 'Serve',
                        style: TextStyle(
                          color: person.served
                              ? const Color(0xFF6B7280)
                              : Colors.white,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
