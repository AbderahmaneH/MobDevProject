import 'dart:async';
import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Notification Service using Supabase Realtime and Local Notifications
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  final SupabaseClient _supabase = Supabase.instance.client;

  StreamSubscription<List<Map<String, dynamic>>>? _notificationSubscription;
  int? _currentUserId;

  /// Initialize the notification service
  Future<void> initialize({int? userId}) async {
    _currentUserId = userId;

    // Request notification permissions
    await _requestPermissions();

    // Initialize local notifications
    await _initializeLocalNotifications();

    // Subscribe to realtime notifications if user is logged in
    if (userId != null) {
      await subscribeToUserNotifications(userId);
    }
  }

  /// Request notification permissions from the user
  Future<bool> _requestPermissions() async {
    final status = await Permission.notification.request();
    print('Notification permission status: $status');
    return status.isGranted;
  }

  /// Initialize local notifications
  Future<void> _initializeLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Handle notification tap
        print('Notification tapped: ${response.payload}');
        _handleNotificationTap(response.payload);
      },
    );

    // Create notification channel for Android
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'queue_notifications',
      'Queue Notifications',
      description: 'Notifications for queue updates',
      importance: Importance.high,
      playSound: true,
      enableVibration: true,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  /// Handle notification tap
  void _handleNotificationTap(String? payload) {
    if (payload != null) {
      try {
        final data = jsonDecode(payload);
        print('Handle tap for: $data');
        // You can add navigation logic here based on notification type
      } catch (e) {
        print('Error parsing notification payload: $e');
      }
    }
  }

  /// Subscribe to Supabase Realtime notifications for a user
  Future<void> subscribeToUserNotifications(int userId) async {
    try {
      print('📡 Subscribing to notifications for userId: $userId');
      // Cancel existing subscription
      await _notificationSubscription?.cancel();

      // Subscribe to notifications table for this user
      _notificationSubscription = _supabase
          .from('notifications')
          .stream(primaryKey: ['id'])
          .eq('user_id', userId)
          .listen((List<Map<String, dynamic>> data) {
            print('📬 Received realtime data: ${data.length} notifications');
            // Filter for unread notifications
            for (final notification in data) {
              print('Notification data: $notification');
              if (notification['is_read'] == false ||
                  notification['is_read'] == null) {
                print('🔔 Showing notification: ${notification['title']}');
                _showNotificationFromData(notification);
              }
            }
          });

      print('✅ Successfully subscribed to notifications for user $userId');
    } catch (e) {
      print('Error subscribing to notifications: $e');
    }
  }

  /// Show notification from Supabase data
  void _showNotificationFromData(Map<String, dynamic> data) {
    showLocalNotification(
      id: data['id'] ?? DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: data['title'] ?? 'Notification',
      body: data['message'] ?? '',
      payload: jsonEncode(data['data'] ?? {}),
    );
  }

  /// Show a local notification directly
  Future<void> showLocalNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'queue_notifications',
      'Queue Notifications',
      channelDescription: 'Notifications for queue updates',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
      styleInformation: BigTextStyleInformation(''),
      playSound: true,
      enableVibration: true,
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      id,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }

  /// Create a notification in Supabase database
  Future<bool> createNotification({
    required int userId,
    required String title,
    required String message,
    String type = 'queue_update',
    Map<String, dynamic>? data,
  }) async {
    try {
      print('Creating notification in Supabase: userId=$userId, title=$title');
      await _supabase.from('notifications').insert({
        'user_id': userId,
        'title': title,
        'message': message,
        'type': type,
        'data': data,
        'is_read': false,
        'created_at': DateTime.now().toIso8601String(),
      });

      print('✅ Notification created successfully for user $userId');
      return true;
    } catch (e) {
      print('❌ Error creating notification in Supabase: $e');
      return false;
    }
  }

  /// Notify client about their turn - primary notification method
  Future<bool> notifyClientAboutTurn({
    required int userId,
    required String clientName,
    required String phoneNumber,
    required String queueName,
    required int position,
  }) async {
    try {
      // Create notification in Supabase (will trigger realtime update)
      final success = await createNotification(
        userId: userId,
        title: '🎉 It\'s Your Turn!',
        message:
            'Hi $clientName! You\'re next in line at $queueName. Please proceed to the counter.',
        type: 'turn_notification',
        data: {
          'queue_name': queueName,
          'position': position,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );

      // Also show local notification immediately as fallback
      if (userId == _currentUserId) {
        await showLocalNotification(
          id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
          title: '🎉 It\'s Your Turn!',
          body: 'Hi $clientName! You\'re next in line at $queueName.',
          payload: jsonEncode({
            'type': 'turn_notification',
            'queue_name': queueName,
            'position': position,
          }),
        );
      }

      return success;
    } catch (e) {
      print('Error notifying client: $e');
      return false;
    }
  }

  /// Notify client about approaching turn (when 2-3 people ahead)
  Future<bool> notifyClientApproachingTurn({
    required int userId,
    required String clientName,
    required String queueName,
    required int position,
    required int peopleAhead,
  }) async {
    return await createNotification(
      userId: userId,
      title: '⏰ Your Turn is Coming Up',
      message:
          'Hi $clientName! $peopleAhead ${peopleAhead == 1 ? "person is" : "people are"} ahead of you at $queueName.',
      type: 'approaching_turn',
      data: {
        'queue_name': queueName,
        'position': position,
        'people_ahead': peopleAhead,
      },
    );
  }

  /// Notify client when they join a queue
  Future<bool> notifyClientJoinedQueue({
    required int userId,
    required String clientName,
    required String queueName,
    required int position,
    required int estimatedWaitTime,
  }) async {
    return await createNotification(
      userId: userId,
      title: '✅ You\'ve Joined the Queue',
      message:
          'Hi $clientName! You\'re position #$position at $queueName. Estimated wait: ${estimatedWaitTime * position} minutes.',
      type: 'queue_joined',
      data: {
        'queue_name': queueName,
        'position': position,
        'estimated_wait': estimatedWaitTime * position,
      },
    );
  }

  /// Mark notification as read
  Future<void> markAsRead(int notificationId) async {
    try {
      await _supabase.from('notifications').update({
        'is_read': true,
        'read_at': DateTime.now().toIso8601String()
      }).eq('id', notificationId);
    } catch (e) {
      print('Error marking notification as read: $e');
    }
  }

  /// Get unread notifications count
  Future<int> getUnreadCount(int userId) async {
    try {
      final response = await _supabase
          .from('notifications')
          .select('id')
          .eq('user_id', userId)
          .eq('is_read', false);

      return (response as List).length;
    } catch (e) {
      print('Error getting unread count: $e');
      return 0;
    }
  }

  /// Get all notifications for a user
  Future<List<Map<String, dynamic>>> getNotifications(int userId,
      {int limit = 50}) async {
    try {
      final response = await _supabase
          .from('notifications')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false)
          .limit(limit);

      return List<Map<String, dynamic>>.from(response as List);
    } catch (e) {
      print('Error getting notifications: $e');
      return [];
    }
  }

  /// Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await _localNotifications.cancelAll();
  }

  /// Cancel a specific notification
  Future<void> cancelNotification(int id) async {
    await _localNotifications.cancel(id);
  }

  /// Unsubscribe from notifications
  Future<void> unsubscribe() async {
    await _notificationSubscription?.cancel();
    _notificationSubscription = null;
    _currentUserId = null;
  }

  /// Dispose resources
  void dispose() {
    _notificationSubscription?.cancel();
  }
}
