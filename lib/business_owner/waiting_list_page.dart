import 'package:flutter/material.dart';
import '../models/queue_model.dart';
import '../colors/app_colors.dart';
import '../templates/widgets_temps.dart';
import '../welcome_page.dart';

class WaitingListPage extends StatefulWidget {
  final Queue queue;
  const WaitingListPage({super.key, required this.queue});

  @override
  State<WaitingListPage> createState() => _WaitingListPageState();
}

class _WaitingListPageState extends State<WaitingListPage> {
  void _showAddClientDialog() {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.backgroundLight,
          surfaceTintColor: Colors.transparent,
          title: Text(
            'Add New Person',
            style: AppTextStyles.titleLarge.copyWith(
              fontFamily: AppFonts.display,
              color: AppColors.textPrimaryLight,
            ),
          ),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppTextFields.textField(
                  hintText: 'Enter full name',
                  controller: nameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Name is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                AppTextFields.textField(
                  hintText: 'Enter phone number',
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
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
            AppButtons.textButton(
              text: 'Cancel',
              onPressed: () => Navigator.pop(context),
              textColor: AppColors.textSecondaryLight,
            ),
            AppButtons.primaryButton(
              text: 'Add',
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  final newClient = QueueClient(
                    name: nameController.text,
                    phone: phoneController.text,
                  );

                  setState(() {
                    widget.queue.clients.add(newClient);
                  });

                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.white),
                          SizedBox(width: 8),
                          Text('Person added to queue!'),
                        ],
                      ),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
              isFullWidth: false,
            ),
          ],
        );
      },
    );
  }

  void _serveClient(int index) {
    setState(() {
      widget.queue.clients[index].served = true;
    });

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          widget.queue.clients.removeAt(index);
        });
      }
    });
  }

  void _notifyClient(int index) {
    setState(() {
      widget.queue.clients[index].notified = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Notified ${widget.queue.clients[index].name}'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final waitingCount = widget.queue.clients.where((c) => !c.served).length;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            AppAppBar.sliverAppBar(
              title: widget.queue.name,
              onBackPressed: () => Navigator.pop(context),
              actions: [],
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
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.people_alt,
                              color: AppColors.white,
                              size: 48,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "Waiting List",
                            style: AppTextStyles.displayLarge,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "$waitingCount ${waitingCount == 1 ? 'person' : 'people'} in queue",
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textSecondaryLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Stats Card
                    AppContainers.card(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatItem(
                            'Total',
                            '${widget.queue.clients.length}',
                          ),
                          _buildStatItem('Waiting', '$waitingCount'),
                          _buildStatItem(
                            'Served',
                            '${widget.queue.clients.where((c) => c.served).length}',
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
            widget.queue.clients.isEmpty
                ? SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Center(
                        child: Text(
                          "No one in queue\nTap the button below to add people",
                          textAlign: TextAlign.center,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondaryLight,
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
                        child: _buildPersonCard(
                          widget.queue.clients[index],
                          index,
                        ),
                      ),
                      childCount: widget.queue.clients.length,
                    ),
                  ),
          ],
        ),
      ),
      floatingActionButton: AppButtons.floatingActionButton(
        icon: Icons.add,
        label: 'Add Person',
        onPressed: _showAddClientDialog,
      ),
    );
  }

  Widget _buildStatItem(String title, String value) {
    return Column(
      children: [
        Text(
          value,
          style: AppTextStyles.bodyLarge.copyWith(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondaryLight,
          ),
        ),
      ],
    );
  }

  Widget _buildPersonCard(QueueClient person, int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.only(bottom: 8),
      child: AppContainers.card(
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
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(Icons.person, color: AppColors.white, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        person.name,
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.phone,
                            size: 14,
                            color: AppColors.textSecondaryLight,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            person.phone,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textSecondaryLight,
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
                    onPressed: person.notified
                        ? null
                        : () => _notifyClient(index),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: person.notified
                            ? AppColors.buttonSecondaryLight
                            : AppColors.primary,
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
                            ? AppColors.textSecondaryLight
                            : AppColors.primary,
                        fontWeight: FontWeight.w500,
                        fontFamily: AppFonts.body,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: person.served ? null : () => _serveClient(index),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: person.served
                          ? AppColors.buttonSecondaryLight
                          : AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      person.served ? 'Served' : 'Serve',
                      style: TextStyle(
                        color: person.served
                            ? AppColors.textSecondaryLight
                            : AppColors.white,
                        fontWeight: FontWeight.w500,
                        fontFamily: AppFonts.body,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
