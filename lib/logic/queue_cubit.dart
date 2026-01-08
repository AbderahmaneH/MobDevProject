import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../data/models/queue.dart';
import '../data/models/queue_client.dart';
import '../data/models/manual_customer.dart';
import '../data/repositories/queue_repository.dart';
import '../data/repositories/queue_client_repository.dart';
import '../data/repositories/manual_customer_repository.dart';
import '../services/notification_service.dart';

part 'queue_state.dart';

class QueueCubit extends Cubit<QueueState> {
  final QueueRepository queueRepository;
  final QueueClientRepository queueClientRepository;
  final ManualCustomerRepository manualCustomerRepository;
  final NotificationService notificationService;

  QueueCubit({
    required this.queueRepository,
    required this.queueClientRepository,
    required this.manualCustomerRepository,
    required this.notificationService,
  }) : super(QueueInitial());

  Future<void> loadQueue(String queueId) async {
    try {
      emit(QueueLoading());
      final queue = await queueRepository.getQueue(queueId);
      final clients = await queueClientRepository.getQueueClients(queueId);
      emit(QueueLoaded(queue: queue, clients: clients));
    } catch (e) {
      emit(QueueError(message: e.toString()));
    }
  }

  Future<void> serveClient(String queueId, String clientId) async {
    try {
      await queueClientRepository.updateClientStatus(clientId, 'served');
      await loadQueue(queueId);
    } catch (e) {
      emit(QueueError(message: e.toString()));
    }
  }

  Future<void> notifyClient(String queueId, String clientId) async {
    try {
      // Get client details
      final client = await queueClientRepository.getClient(clientId);
      
      // Get queue details
      final queue = await queueRepository.getQueue(queueId);
      
      // Create notification record in Supabase
      final notificationData = {
        'user_id': client.userId,
        'queue_id': queueId,
        'title': 'Your Turn in Queue',
        'message': 'It\'s your turn in ${queue.name}. Please proceed to the counter.',
        'created_at': DateTime.now().millisecondsSinceEpoch,
      };
      
      await queueRepository.createNotification(notificationData);
      
      // Update client status to 'notified'
      await queueClientRepository.updateClientStatus(clientId, 'notified');
      
      // Send local notification
      await notificationService.showNotification(
        title: notificationData['title'] as String,
        body: notificationData['message'] as String,
      );
      
      await loadQueue(queueId);
    } catch (e) {
      emit(QueueError(message: e.toString()));
    }
  }

  Future<void> addManualCustomer(String queueId, String name, String phone) async {
    try {
      final customer = ManualCustomer(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        queueId: queueId,
        name: name,
        phone: phone,
        position: 0,
        status: 'waiting',
        joinedAt: DateTime.now(),
      );
      await manualCustomerRepository.addCustomer(customer);
      await loadQueue(queueId);
    } catch (e) {
      emit(QueueError(message: e.toString()));
    }
  }

  Future<void> removeClientFromQueue(String queueId, String clientId) async {
    try {
      await queueClientRepository.removeClient(clientId);
      await loadQueue(queueId);
    } catch (e) {
      emit(QueueError(message: e.toString()));
    }
  }

  Future<void> updateQueueStatus(String queueId, bool isActive) async {
    try {
      await queueRepository.updateQueueStatus(queueId, isActive);
      await loadQueue(queueId);
    } catch (e) {
      emit(QueueError(message: e.toString()));
    }
  }

  Future<void> refreshQueue(String queueId) async {
    await loadQueue(queueId);
  }
}
