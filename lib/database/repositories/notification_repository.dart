import 'package:flutter/foundation.dart';
import '../../services/supabase_service.dart';

class NotificationRepository {
  Future<bool> createNotification({
    required int userId,
    required String title,
    required String message,
    required String type,
    Map<String, dynamic>? data,
  }) async {
    try {
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
      return true;
    } catch (e) {
      debugPrint('NotificationRepository.createNotification error: $e');
      return false;
    }
  }

  Future<bool> userHasFCMToken(int userId) async {
    try {
      final result = await SupabaseService.client
          .from('users')
          .select('fcm_token')
          .eq('id', userId)
          .maybeSingle();
      
      if (result == null) return false;
      final fcmToken = result['fcm_token'];
      return fcmToken is String && fcmToken.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
}