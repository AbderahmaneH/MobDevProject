import 'package:flutter/material.dart';
import '../models/queue_model.dart';
import '../colors/app_colors.dart';
import '../login_signup/welcome_page.dart';

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
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.backgroundLight,
          surfaceTintColor: Colors.transparent,
          title: Text(
            'Add New Person',
            style: TextStyle(
              fontFamily: AppFonts.display,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimaryLight,
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
                    hintStyle: TextStyle(
                      fontFamily: AppFonts.body,
                      color: AppColors.textSecondaryDark,
                    ),
                    filled: true,
                    fillColor: AppColors.white,
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
                      borderSide: BorderSide(
                        color: AppColors.buttonSecondaryLight,
                        width: 1.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: AppColors.primary,
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
                    hintStyle: TextStyle(
                      fontFamily: AppFonts.body,
                      color: AppColors.textSecondaryDark,
                    ),
                    filled: true,
                    fillColor: AppColors.white,
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
                      borderSide: BorderSide(
                        color: AppColors.buttonSecondaryLight,
                        width: 1.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: AppColors.primary,
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
              child: Text(
                'Cancel',
                style: TextStyle(
                  fontFamily: AppFonts.body,
                  color: AppColors.textSecondaryLight,
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
                      backgroundColor: AppColors.buttonSecondaryDark,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
              child: Text(
                'Add',
                style: TextStyle(
                  fontFamily: AppFonts.body,
                  color: AppColors.white,
                ),
              ),
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
    final waitingCount =
        widget.queue.clients.where((c) => !c.served).length;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      endDrawer: Drawer(
        child: Container(
          color: AppColors.backgroundLight,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: AppColors.primary,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(
                      Icons.access_time_filled,
                      color: Colors.white,
                      size: 48,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'QNow',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: AppFonts.display,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      widget.queue.name,
                      style: TextStyle(
                        color: Colors.white70,
                        fontFamily: AppFonts.body,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.account_circle,
                  color: AppColors.textPrimaryLight,
                ),
                title: Text(
                  'Profile',
                  style: TextStyle(
                    fontFamily: AppFonts.body,
                    color: AppColors.textPrimaryLight,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.white),
                          SizedBox(width: 8),
                          Text('Profile page - Coming soon'),
                        ],
                      ),
                      backgroundColor: Colors.blue,
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.help_outline,
                  color: AppColors.textPrimaryLight,
                ),
                title: Text(
                  'Help',
                  style: TextStyle(
                    fontFamily: AppFonts.body,
                    color: AppColors.textPrimaryLight,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.white),
                          SizedBox(width: 8),
                          Text('Help page - Coming soon'),
                        ],
                      ),
                      backgroundColor: Colors.blue,
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.info_outline,
                  color: AppColors.textPrimaryLight,
                ),
                title: Text(
                  'About',
                  style: TextStyle(
                    fontFamily: AppFonts.body,
                    color: AppColors.textPrimaryLight,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.white),
                          SizedBox(width: 8),
                          Text('About page - Coming soon'),
                        ],
                      ),
                      backgroundColor: Colors.blue,
                    ),
                  );
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(
                  Icons.logout,
                  color: AppColors.buttonSecondaryDark,
                ),
                title: Text(
                  'Sign Out',
                  style: TextStyle(
                    fontFamily: AppFonts.body,
                    color: AppColors.buttonSecondaryDark,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WelcomePage(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              backgroundColor: AppColors.backgroundLight,
              surfaceTintColor: Colors.transparent,
              elevation: 0,
              floating: true,
              snap: true,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: AppColors.textPrimaryLight),
                onPressed: () => Navigator.pop(context),
              ),
              centerTitle: true,
              title: Text(
                widget.queue.name,
                style: TextStyle(
                  fontFamily: AppFonts.display,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimaryLight,
                ),
              ),
              actions: [
                Builder(
                  builder: (context) => IconButton(
                    icon: Icon(
                      Icons.menu,
                      color: AppColors.textPrimaryLight,
                    ),
                    onPressed: () {
                      Scaffold.of(context).openEndDrawer();
                    },
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
                            style: TextStyle(
                              fontFamily: AppFonts.display,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimaryLight,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "$waitingCount ${waitingCount == 1 ? 'person' : 'people'} in queue",
                            style: TextStyle(
                              fontFamily: AppFonts.body,
                              color: AppColors.textSecondaryLight,
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
                        color: AppColors.white,
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
                          _buildStatItem('Total', '${widget.queue.clients.length}'),
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
            if (widget.queue.clients.isEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Center(
                    child: Text(
                      "No one in queue\nTap the button below to add people",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: AppFonts.body,
                        color: AppColors.textSecondaryLight,
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
                      person: widget.queue.clients[index],
                      onServe: () => _serveClient(index),
                      onNotify: () => _notifyClient(index),
                    ),
                  ),
                  childCount: widget.queue.clients.length,
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddClientDialog,
        backgroundColor: AppColors.primary,
        icon: Icon(Icons.add, color: AppColors.buttonSecondaryLight),
        label: Text(
          'Add Person',
          style: TextStyle(
            fontFamily: AppFonts.body,
            color: AppColors.buttonSecondaryLight,
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
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimaryLight,
            fontFamily: AppFonts.body,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textSecondaryLight,
            fontFamily: AppFonts.body,
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
        color: AppColors.white,
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
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      Icons.person,
                      color: AppColors.white,
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
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimaryLight,
                            fontFamily: AppFonts.body,
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
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.textSecondaryLight,
                                fontFamily: AppFonts.body,
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
                      onPressed: person.served ? null : onServe,
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
      ),
    );
  }
}