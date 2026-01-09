import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'supabase_service.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _local =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'qnow_high_importance',
    'QNow Notifications',
    description: 'Notifications for queue updates',
    importance: Importance.high,
  );

  static Future<void> initialize() async {
    await Firebase.initializeApp();

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings();
    const initSettings = InitializationSettings(android: androidInit, iOS: iosInit);

    await _local.initialize(initSettings);

    final androidPlugin =
        _local.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.createNotificationChannel(_channel);

    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (Platform.isAndroid) {
      await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage msg) async {
      final title = msg.notification?.title ?? 'QNow';
      final body = msg.notification?.body ?? '';

      await _local.show(
        DateTime.now().millisecondsSinceEpoch ~/ 1000,
        title,
        body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _channel.id,
            _channel.name,
            channelDescription: _channel.description,
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: const DarwinNotificationDetails(),
        ),
      );
    });
  }

  static Future<void> registerTokenForUser(int userId) async {
    final token = await FirebaseMessaging.instance.getToken();
    if (token == null) return;

    await SupabaseService.client
        .from('users')
        .update({'fcm_token': token})
        .eq('id', userId);

    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
      await SupabaseService.client
          .from('users')
          .update({'fcm_token': newToken})
          .eq('id', userId);
    });
  }
}
