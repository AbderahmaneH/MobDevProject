import '../../services/supabase_service.dart';

class NotificationRepository {
  Future<void> createNotification({
    required int userId,
    required String title,
    required String message,
    required String type,
    Map<String, dynamic>? data,
  }) async {
    final payload = {
      'user_id': userId,
      'title': title,
      'message': message,
      'type': type,
      'data': data ?? {},
      'is_read': false,
      // Do NOT send created_at unless your table doesn't auto-set it.
      // Let Supabase handle created_at default (recommended).
    };

    await SupabaseService.client.from('notification').insert(payload);
  }
}