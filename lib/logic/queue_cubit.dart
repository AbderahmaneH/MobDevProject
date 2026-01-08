import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/notification_service.dart';

part 'queue_state.dart';

class QueueCubit extends Cubit<QueueState> {
  final SupabaseClient supabase;
  final NotificationService notificationService;

  QueueCubit({required this.supabase, required this.notificationService})
      : super(QueueInitial());

  Future<void> loadQueues() async {
    try {
      emit(QueueLoading());
      final response = await supabase
          .from('queues')
          .select()
          .order('created_at', ascending: false);
      
      emit(QueueLoaded(queues: response as List<dynamic>));
    } catch (e) {
      emit(QueueError(message: e.toString()));
    }
  }

  Future<void> createQueue(String name, String description, int estimatedTime) async {
    try {
      emit(QueueLoading());
      await supabase.from('queues').insert({
        'name': name,
        'description': description,
        'estimated_time_per_client': estimatedTime,
        'status': 'active',
      });
      await loadQueues();
    } catch (e) {
      emit(QueueError(message: e.toString()));
    }
  }

  Future<void> joinQueue(String queueId) async {
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');

      await supabase.from('queue_clients').insert({
        'queue_id': queueId,
        'user_id': userId,
        'status': 'waiting',
      });
      
      await loadQueues();
    } catch (e) {
      emit(QueueError(message: e.toString()));
    }
  }

  Future<void> notifyClient(String clientId, String queueId) async {
    try {
      // 1. Get the client's user_id from the queue_client record
      final clientRecord = await supabase
          .from('queue_clients')
          .select('user_id')
          .eq('id', clientId)
          .single();
      
      final userId = clientRecord['user_id'] as String;

      // 2. Get the queue name
      final queueRecord = await supabase
          .from('queues')
          .select('name')
          .eq('id', queueId)
          .single();
      
      final queueName = queueRecord['name'] as String;

      // 3. Create a notification record in the notifications table
      final title = "Your Turn is Coming!";
      final message = "Your turn is coming up in $queueName. Please get ready!";
      
      await supabase.from('notifications').insert({
        'user_id': userId,
        'queue_id': queueId,
        'title': title,
        'message': message,
        'created_at': DateTime.now().toIso8601String(),
      });

      // 4. Update the client status to 'notified' and set notified_at timestamp
      await supabase
          .from('queue_clients')
          .update({
            'status': 'notified',
            'notified_at': DateTime.now().toIso8601String(),
          })
          .eq('id', clientId);

      // 5. Send local notification
      await notificationService.showNotification(
        title: title,
        body: message,
      );

      await loadQueues();
    } catch (e) {
      emit(QueueError(message: e.toString()));
    }
  }

  Future<void> completeClient(String clientId) async {
    try {
      await supabase
          .from('queue_clients')
          .update({'status': 'completed'})
          .eq('id', clientId);
      
      await loadQueues();
    } catch (e) {
      emit(QueueError(message: e.toString()));
    }
  }

  Future<void> removeClient(String clientId) async {
    try {
      await supabase
          .from('queue_clients')
          .delete()
          .eq('id', clientId);
      
      await loadQueues();
    } catch (e) {
      emit(QueueError(message: e.toString()));
    }
  }

  Future<void> updateQueueStatus(String queueId, String status) async {
    try {
      await supabase
          .from('queues')
          .update({'status': status})
          .eq('id', queueId);
      
      await loadQueues();
    } catch (e) {
      emit(QueueError(message: e.toString()));
    }
  }
}
