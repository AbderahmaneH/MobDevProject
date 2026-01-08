import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_service.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;
  int? _currentUserId;
  RealtimeChannel? _notificationChannel;

  Future<void> initialize() async {
    if (_initialized) return;

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notificationsPlugin.initialize(initSettings);
    await requestPermissions();
    
    _initialized = true;
  }

  Future<bool> requestPermissions() async {
    if (await Permission.notification.isDenied) {
      final status = await Permission.notification.request();
      return status.isGranted;
    }
    return true;
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'queue_notifications',
      'Queue Notifications',
      channelDescription: 'Notifications for queue status updates',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notificationsPlugin.show(id, title, body, details);
  }

  void startListening(int userId) {
    _currentUserId = userId;
    
    // Cancel existing subscription if any
    _notificationChannel?.unsubscribe();

    // Subscribe to notifications for this user
    _notificationChannel = SupabaseService.client
        .channel('notifications:user_id=eq.$userId')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'notifications',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'user_id',
            value: userId,
          ),
          callback: (payload) {
            final notification = payload.newRecord;
            if (notification != null) {
              showNotification(
                id: notification['id'] as int,
                title: notification['title'] as String,
                body: notification['message'] as String,
              );
            }
          },
        )
        .subscribe();
  }

  void stopListening() {
    _notificationChannel?.unsubscribe();
    _notificationChannel = null;
    _currentUserId = null;
  }

  Future<void> createNotification({
    required int userId,
    required String title,
    required String message,
    required int queueId,
  }) async {
    try {
      await SupabaseService.client.from('notifications').insert({
        'user_id': userId,
        'title': title,
        'message': message,
        'queue_id': queueId,
        'created_at': DateTime.now().millisecondsSinceEpoch,
        'is_read': false,
      });
    } catch (e) {
      print('Error creating notification: $e');
    }
  }
}
