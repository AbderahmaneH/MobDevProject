import 'package:supabase_flutter/supabase_flutter.dart';
import '../tables.dart';
import '../../services/supabase_service.dart';

class NotificationRepository {
  final SupabaseClient _client;

  NotificationRepository({SupabaseClient? client}) 
      : _client = client ?? SupabaseService.client;

  Future<int> insertNotification({
    required int userId,
    required String title,
    required String message,
    String type = 'queue',
  }) async {
    final result = await _client
        .from(DatabaseTables.notifications)
        .insert({
          'user_id': userId,
          'title': title,
          'message': message,
          'type': type,
          'is_read': false,
          'created_at': DateTime.now().millisecondsSinceEpoch,
        })
        .select()
        .maybeSingle();
    
    if (result == null) return 0;
    return (result['id'] as int?) ?? 0;
  }

  Future<List<Map<String, dynamic>>> getNotificationsByUser(int userId) async {
    final results = await _client
        .from(DatabaseTables.notifications)
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);
    
    return List<Map<String, dynamic>>.from(results);
  }

  Future<void> markAsRead(int notificationId) async {
    await _client
        .from(DatabaseTables.notifications)
        .update({'is_read': true})
        .eq('id', notificationId);
  }
}
