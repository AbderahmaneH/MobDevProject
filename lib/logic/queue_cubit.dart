import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../database/models/queue_model.dart';
import '../database/models/queue_client_model.dart';
import '../database/repositories/queue_repository.dart';
import '../database/repositories/queue_client_repository.dart';
import '../database/repositories/manual_customer_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'queue_state.dart';

class QueueCubit extends Cubit<QueueState> {
  final QueueRepository _queueRepository;
  final QueueClientRepository _queueClientRepository;
  final ManualCustomerRepository _manualCustomerRepository;

  QueueCubit({
    required QueueRepository queueRepository,
    required QueueClientRepository queueClientRepository,
    required ManualCustomerRepository manualCustomerRepository,
  })  : _queueRepository = queueRepository,
        _queueClientRepository = queueClientRepository,
        _manualCustomerRepository = manualCustomerRepository,
        super(QueueInitial());

  Future<void> loadQueue(String queueId) async {
    try {
      emit(QueueLoading());
      final queue = await _queueRepository.getQueue(queueId);
      final clients = await _queueClientRepository.getClientsByQueue(queueId);
      emit(QueueLoaded(queue: queue, clients: clients));
    } catch (e) {
      emit(QueueError(message: e.toString()));
    }
  }

  Future<void> addClient({
    required String queueId,
    required String name,
    required String phone,
  }) async {
    try {
      await _queueClientRepository.addClient(
        queueId: queueId,
        name: name,
        phone: phone,
      );
      await loadQueue(queueId);
    } catch (e) {
      emit(QueueError(message: e.toString()));
    }
  }

  Future<void> notifyClient(String clientId, String queueId) async {
    try {
      await _queueClientRepository.updateClientStatus(clientId, 'notified');
      
      // Create a Supabase notification
      final supabase = Supabase.instance.client;
      final client = await _queueClientRepository.getClient(clientId);
      
      if (client != null) {
        await supabase.from('notifications').insert({
          'queue_id': queueId,
          'client_id': clientId,
          'phone_number': client.phone,
          'message': 'It\'s your turn! Please proceed to the counter.',
          'status': 'pending',
          'created_at': DateTime.now().toIso8601String(),
        });
      }
      
      await loadQueue(queueId);
    } catch (e) {
      emit(QueueError(message: e.toString()));
    }
  }

  Future<void> completeClient(String clientId, String queueId) async {
    try {
      await _queueClientRepository.updateClientStatus(clientId, 'completed');
      await loadQueue(queueId);
    } catch (e) {
      emit(QueueError(message: e.toString()));
    }
  }

  Future<void> removeClient(String clientId, String queueId) async {
    try {
      await _queueClientRepository.deleteClient(clientId);
      await loadQueue(queueId);
    } catch (e) {
      emit(QueueError(message: e.toString()));
    }
  }
}
