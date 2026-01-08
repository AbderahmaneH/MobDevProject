import 'package:bloc/bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/queue.dart';

part 'queue_state.dart';

class QueueCubit extends Cubit<QueueState> {
  final SupabaseClient supabase;

  QueueCubit(this.supabase) : super(QueueInitial());

  Future<void> loadQueues() async {
    try {
      emit(QueueLoading());
      final response = await supabase.from('queues').select();
      final queues = (response as List).map((q) => Queue.fromJson(q)).toList();
      emit(QueueLoaded(queues));
    } catch (e) {
      emit(QueueError(e.toString()));
    }
  }

  Future<void> createQueue(String name, String description) async {
    try {
      emit(QueueLoading());
      final user = supabase.auth.currentUser;
      if (user == null) throw Exception('No user logged in');

      await supabase.from('queues').insert({
        'name': name,
        'description': description,
        'creator_id': user.id,
      });

      await loadQueues();
    } catch (e) {
      emit(QueueError(e.toString()));
    }
  }

  Future<void> joinQueue(int queueId) async {
    try {
      emit(QueueLoading());
      final user = supabase.auth.currentUser;
      if (user == null) throw Exception('No user logged in');

      await supabase.from('queue_members').insert({
        'queue_id': queueId,
        'user_id': user.id,
      });

      await loadQueues();
    } catch (e) {
      emit(QueueError(e.toString()));
    }
  }

  Future<void> notifyClient(String userId, int queueId) async {
    print('=== notifyClient called ===');
    print('Client userId: $userId (type: ${userId.runtimeType})');
    print('Queue ID: $queueId (type: ${queueId.runtimeType})');
    
    try {
      // Validate inputs
      if (userId.isEmpty) {
        throw Exception('userId cannot be empty');
      }
      
      // Get current timestamp
      final timestamp = DateTime.now().toIso8601String();
      print('Timestamp: $timestamp');
      
      // Prepare notification data
      final notificationData = {
        'user_id': userId,
        'queue_id': queueId,
        'message': 'It\'s your turn in the queue!',
        'created_at': timestamp,
        'read': false,
      };
      
      print('Notification data to insert: $notificationData');
      
      // Insert notification into database
      final response = await supabase
          .from('notifications')
          .insert(notificationData)
          .select();
      
      print('Insert successful! Response: $response');
      print('Notification sent to user: $userId for queue: $queueId');
      
    } catch (e, stackTrace) {
      print('!!! ERROR in notifyClient !!!');
      print('Error type: ${e.runtimeType}');
      print('Error message: $e');
      print('Stack trace: $stackTrace');
      
      // Log specific error details
      if (e is PostgrestException) {
        print('PostgrestException details:');
        print('  Code: ${e.code}');
        print('  Message: ${e.message}');
        print('  Details: ${e.details}');
        print('  Hint: ${e.hint}');
      }
      
      // Re-throw to allow upper layers to handle
      rethrow;
    } finally {
      print('=== notifyClient completed ===\n');
    }
  }

  Future<void> removeFromQueue(int queueId, String userId) async {
    try {
      emit(QueueLoading());
      
      await supabase
          .from('queue_members')
          .delete()
          .eq('queue_id', queueId)
          .eq('user_id', userId);

      await loadQueues();
    } catch (e) {
      emit(QueueError(e.toString()));
    }
  }
}
