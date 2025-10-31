import 'package:QNow/login_signup/login_page.dart';
import 'package:flutter/material.dart';
import '../models/queue_model.dart';
import '../models/queues_database.dart';
import '../colors/app_colors.dart';
import '../templates/widgets_temps.dart';
import '../drawer/about_us_page.dart';
import '../drawer/help_page.dart';
import '../drawer/profile_page.dart';
import 'waiting_list_page.dart';

class QueuesPage extends StatefulWidget {
  final String userPhone;
  final String businessName;

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
    return userQueuesMap[widget.userPhone] ?? [];
  }

  void _addQueue() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.backgroundLight,
          surfaceTintColor: Colors.transparent,
          title: Text(
            'Add New Queue',
            style: AppTextStyles.titleLarge.copyWith(
              fontFamily: AppFonts.display,
              color: AppColors.textPrimaryLight,
            ),
          ),
          content: Form(
            key: _formKey,
            child: AppTextFields.textField(
              hintText: 'Enter queue name',
              controller: _queueNameController,
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
            AppButtons.textButton(
              text: 'Cancel',
              onPressed: () => Navigator.pop(context),
              textColor: AppColors.textSecondaryLight,
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final queueName = _queueNameController.text.trim();
                  setState(() {
                    if (userQueuesMap[widget.userPhone] == null) {
                      userQueuesMap[widget.userPhone] = [];
                    }
                    userQueuesMap[widget.userPhone]!.add(
                      Queue(
                        name: queueName,
                        clients: [],
                        ownerPhone: widget.userPhone,
                      ),
                    );
                  });
                  _queueNameController.clear();
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.white),
                          SizedBox(width: 8),
                          Text('$queueName queue created!'),
                        ],
                      ),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
              child: Text('Add Queue', style: AppTextStyles.buttonText),
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
        backgroundColor: AppColors.backgroundLight,
        surfaceTintColor: Colors.transparent,
        title: Text(
          'Remove Queue',
          style: AppTextStyles.titleLarge.copyWith(
            fontFamily: AppFonts.display,
            color: AppColors.textPrimaryLight,
          ),
        ),
        content: Text(
          'Are you sure you want to remove "$queueName"?',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondaryLight,
          ),
        ),
        actions: [
          AppButtons.textButton(
            text: 'Cancel',
            onPressed: () => Navigator.pop(context),
            textColor: AppColors.textSecondaryLight,
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                userQueuesMap[widget.userPhone]?.removeAt(index);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.white),
                      SizedBox(width: 8),
                      Text('Queue removed successfully!'),
                    ],
                  ),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Remove', style: AppTextStyles.buttonText),
          ),
        ],
      ),
    );
  }

  void _refreshQueues() {
    setState(() {
      // This will trigger a rebuild and reload the queues
    });
  }

  @override
  void dispose() {
    _queueNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      endDrawer: _buildDrawer(),
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            AppAppBar.sliverAppBar(
              title: "Your Queues",
              backarrow: false,
              actions: [
                Builder(
                  builder: (context) => IconButton(
                    icon: Icon(Icons.menu, color: AppColors.textPrimaryLight),
                    onPressed: () => Scaffold.of(context).openEndDrawer(),
                  ),
                ),
              ],
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

                    // Welcome Message Only
                    Center(
                      child: Text(
                        "Welcome, ${widget.businessName}",
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: AppColors.textSecondaryLight,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Buttons Row
                    Row(
                      children: [
                        Expanded(
                          child: AppButtons.primaryButton(
                            text: "Add New Queue",
                            onPressed: _addQueue,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          width: 56,
                          child: ElevatedButton(
                            onPressed: _refreshQueues,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              padding: const EdgeInsets.all(12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Icon(
                              Icons.refresh,
                              color: AppColors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // Queues List
            userQueues.isEmpty
                ? SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Center(
                        child: Text(
                          "No queues yet\nTap 'Add New Queue' to create one",
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
                        child: _buildQueueCard(userQueues[index], index),
                      ),
                      childCount: userQueues.length,
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildQueueCard(Queue queue, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WaitingListPage(queue: queue),
          ),
        );
      },
      child: AppContainers.card(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Queue Icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.access_time, color: AppColors.white, size: 24),
            ),
            const SizedBox(width: 12),

            // Queue Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    queue.name,
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.people_outline,
                        size: 16,
                        color: AppColors.textSecondaryLight,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${queue.clients.length} ${queue.clients.length == 1 ? 'person' : 'people'} waiting',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondaryLight,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Remove Button
            IconButton(
              onPressed: () => _removeQueue(index),
              icon: Icon(Icons.delete_outline, color: Colors.red, size: 20),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Container(
        color: AppColors.backgroundLight,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: AppColors.primary),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(Icons.access_time_filled, color: Colors.white, size: 48),
                  const SizedBox(height: 8),
                  Text(
                    'QNow',
                    style: AppTextStyles.displayMedium.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    widget.businessName,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            _buildDrawerItem(
              icon: Icons.account_circle,
              title: 'Profile',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfilePage()),
                );
              },
            ),
            _buildDrawerItem(
              icon: Icons.help_outline,
              title: 'Help',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HelpPage()),
                );
              },
            ),
            _buildDrawerItem(
              icon: Icons.info_outline,
              title: 'About',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AboutUsPage()),
                );
              },
            ),
            const Divider(),
            _buildDrawerItem(
              icon: Icons.logout,
              title: 'Sign Out',
              iconColor: Colors.red,
              textColor: Colors.red,
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? iconColor,
    Color? textColor,
  }) {
    return ListTile(
      leading: Icon(icon, color: iconColor ?? AppColors.textPrimaryLight),
      title: Text(
        title,
        style: AppTextStyles.bodyMedium.copyWith(
          color: textColor ?? AppColors.textPrimaryLight,
        ),
      ),
      onTap: onTap,
    );
  }
}
