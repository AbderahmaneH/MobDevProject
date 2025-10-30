import 'package:flutter/material.dart';
import '../models/queue_model.dart';
import '../queues_database.dart';
import 'waiting_list_page.dart';

class QueuesPage extends StatefulWidget {
  final String userPhone;
  final String businessName; // Add business name parameter

  const QueuesPage({
    super.key,
    required this.userPhone,
    required this.businessName,
  });

  @override
  State<QueuesPage> createState() => _QueuesPageState();
}

class _QueuesPageState extends State<QueuesPage> {
  final TextEditingController _queueNameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<Queue> get userQueues {
    // Find user's queues in database or create empty list
    final userQueueData = queuesDatabase.firstWhere(
      (uq) => uq.userPhone == widget.userPhone,
      orElse: () => UserQueues(userPhone: widget.userPhone, queues: []),
    );
    return userQueueData.queues;
  }

  void _saveQueuesToDatabase() {
    // Update or add user's queues to database
    final index = queuesDatabase.indexWhere(
      (uq) => uq.userPhone == widget.userPhone,
    );
    if (index != -1) {
      queuesDatabase[index] = UserQueues(
        userPhone: widget.userPhone,
        queues: userQueues,
      );
    } else {
      queuesDatabase.add(
        UserQueues(userPhone: widget.userPhone, queues: userQueues),
      );
    }
  }

  void _addQueue() {
    showDialog(
      context: context,
      builder: (context) {
        String newQueueName = ''; // Store the queue name locally
        return AlertDialog(
          backgroundColor: const Color(0xFFF5F5F3),
          surfaceTintColor: Colors.transparent,
          title: const Text(
            'Add New Queue',
            style: TextStyle(
              fontFamily: 'Lora',
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          content: Form(
            key: _formKey,
            child: TextFormField(
              controller: _queueNameController,
              onChanged: (value) => newQueueName = value, // Store the value
              decoration: InputDecoration(
                hintText: 'Enter queue name',
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
                  return 'Queue name is required';
                }
                if (value.length < 2) {
                  return 'Queue name must be at least 2 characters';
                }
                return null;
              },
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
                  final queueName = _queueNameController.text
                      .trim(); // Store before clearing
                  setState(() {
                    userQueues.add(
                      Queue(
                        name: queueName,
                        clients: [],
                        ownerPhone: widget.userPhone, // Add this
                      ),
                    );
                    _saveQueuesToDatabase();
                  });
                  _queueNameController.clear();
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '$queueName queue created!',
                      ), // Use stored value
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF333333),
              ),
              child: const Text(
                'Add Queue',
                style: TextStyle(fontFamily: 'Poppins', color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  void _removeQueue(int index) {
    final queueName = userQueues[index].name;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFFF5F5F3),
        surfaceTintColor: Colors.transparent,
        title: const Text(
          'Remove Queue',
          style: TextStyle(
            fontFamily: 'Lora',
            fontWeight: FontWeight.bold,
            color: Color(0xFF333333),
          ),
        ),
        content: Text(
          'Are you sure you want to remove "$queueName"?',
          style: const TextStyle(
            fontFamily: 'Poppins',
            color: Color(0xFF6B7280),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(fontFamily: 'Poppins', color: Color(0xFF6B7280)),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                userQueues.removeAt(index);
                _saveQueuesToDatabase();
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Queue removed successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text(
              'Remove',
              style: TextStyle(fontFamily: 'Poppins', color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // Initialize user's queues in database if not exists
    final index = queuesDatabase.indexWhere(
      (uq) => uq.userPhone == widget.userPhone,
    );
    if (index == -1) {
      queuesDatabase.add(UserQueues(userPhone: widget.userPhone, queues: []));
    }
  }

  @override
  void dispose() {
    _queueNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              centerTitle: true,
              title: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(width: 12),
                  Text(
                    "Your Queues",
                    style: TextStyle(
                      fontFamily: 'Lora',
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
                    ),
                  ),
                ],
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
                    Center(
                      child: Column(
                        children: [
                          Text(
                            "Welcome, ${widget.businessName}",
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              color: Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _addQueue,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF333333),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          "Add New Queue",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Container(
                        width: 56,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              // This will refresh the page and reload queues from database
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF333333),
                            padding: const EdgeInsets.all(12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Icon(
                            Icons.refresh,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            userQueues.isEmpty
                ? SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Center(
                        child: Text(
                          "No queues yet\nTap 'Add New Queue' to create one",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            color: Color(0xFF6B7280),
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  )
                : SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 8,
                        ),
                        child: QueueCard(
                          queue: userQueues[index],
                          onRemove: () => _removeQueue(index),
                        ),
                      ),
                      childCount: userQueues.length,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

// Keep the same QueueCard widget from previous fix
class QueueCard extends StatelessWidget {
  final Queue queue;
  final VoidCallback onRemove;

  const QueueCard({super.key, required this.queue, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WaitingListPage(queue: queue),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(16),
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
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFF333333),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.access_time,
                  color: Color(0xFFE5E5E7),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      queue.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF333333),
                        fontFamily: 'Poppins',
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.people_outline,
                          size: 16,
                          color: Color(0xFF6B7280),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${queue.clients.length} ${queue.clients.length == 1 ? 'person' : 'people'} waiting',
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

              SizedBox(
                width: 80,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE5E5E7),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: onRemove,
                      icon: const Icon(
                        Icons.delete_outline,
                        color: Colors.red,
                        size: 18,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 24,
                        minHeight: 24,
                      ),
                      iconSize: 18,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
