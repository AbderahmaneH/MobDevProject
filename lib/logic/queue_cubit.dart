import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/queue.dart';
import '../models/queue_client.dart';
import '../repositories/queue_repository.dart';
import '../repositories/queue_client_repository.dart';
import '../repositories/manual_customer_repository.dart';
import '../services/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'queue_state.dart';

class QueueCubit extends Cubit<QueueState> {
  final QueueRepository _queueRepository;
  final QueueClientRepository _queueClientRepository;
  final ManualCustomerRepository? _manualCustomerRepository;
  StreamSubscription? _queueSubscription;
  StreamSubscription? _clientSubscription;

  QueueCubit(
    this._queueRepository,
    this._queueClientRepository, {
    ManualCustomerRepository? manualCustomerRepository,
  })  : _manualCustomerRepository = manualCustomerRepository,
        super(QueueInitial());

  Future<void> loadQueues() async {
    print('=== loadQueues START ===');
    try {
      emit(QueueLoading());
      print('Fetching queues from repository...');
      final queues = await _queueRepository.getQueues();
      print('Queues fetched: ${queues.length} queues');
      
      for (var queue in queues) {
        print('Queue: ${queue.name}, Clients: ${queue.clients.length}');
        for (var client in queue.clients) {
          print('  - Client: ${client.name}, Status: ${client.status}, Position: ${client.position}');
        }
      }
      
      emit(QueueLoaded(queues: queues));
      print('=== loadQueues SUCCESS ===');
    } catch (e, stackTrace) {
      print('=== loadQueues ERROR ===');
      print('Error: $e');
      print('StackTrace: $stackTrace');
      emit(QueueError(error: e.toString()));
    }
  }

  void subscribeToQueues() {
    print('=== subscribeToQueues START ===');
    _queueSubscription?.cancel();
    _clientSubscription?.cancel();

    _queueSubscription = _queueRepository.watchQueues().listen(
      (queues) {
        print('Queue update received: ${queues.length} queues');
        for (var queue in queues) {
          print('Queue: ${queue.name}, Clients: ${queue.clients.length}');
        }
        emit(QueueLoaded(queues: queues));
      },
      onError: (error) {
        print('Queue subscription error: $error');
        emit(QueueError(error: error.toString()));
      },
    );

    _clientSubscription = _queueClientRepository.watchClients().listen(
      (_) {
        print('Client update received, reloading queues...');
        loadQueues();
      },
      onError: (error) {
        print('Client subscription error: $error');
      },
    );
    
    print('=== subscribeToQueues COMPLETE ===');
  }

  Future<void> createQueue(Queue queue) async {
    print('=== createQueue START ===');
    print('Queue: ${queue.name}');
    try {
      emit(QueueLoading());
      await _queueRepository.createQueue(queue);
      await loadQueues();
      print('=== createQueue SUCCESS ===');
    } catch (e, stackTrace) {
      print('=== createQueue ERROR ===');
      print('Error: $e');
      print('StackTrace: $stackTrace');
      emit(QueueError(error: e.toString()));
    }
  }

  Future<void> updateQueue(Queue queue) async {
    print('=== updateQueue START ===');
    print('Queue: ${queue.name}');
    try {
      emit(QueueLoading());
      await _queueRepository.updateQueue(queue);
      await loadQueues();
      print('=== updateQueue SUCCESS ===');
    } catch (e, stackTrace) {
      print('=== updateQueue ERROR ===');
      print('Error: $e');
      print('StackTrace: $stackTrace');
      emit(QueueError(error: e.toString()));
    }
  }

  Future<void> deleteQueue(int id) async {
    print('=== deleteQueue START ===');
    print('Queue ID: $id');
    try {
      emit(QueueLoading());
      await _queueRepository.deleteQueue(id);
      await loadQueues();
      print('=== deleteQueue SUCCESS ===');
    } catch (e, stackTrace) {
      print('=== deleteQueue ERROR ===');
      print('Error: $e');
      print('StackTrace: $stackTrace');
      emit(QueueError(error: e.toString()));
    }
  }

  Future<void> joinQueue(int queueId, QueueClient client) async {
    print('=== joinQueue START ===');
    print('Queue ID: $queueId, Client: ${client.name}');
    try {
      emit(QueueLoading());
      
      final currentState = state;
      if (currentState is QueueLoaded) {
        final queue = currentState.queues.firstWhere((q) => q.id == queueId);
        final nextPosition = queue.clients.isEmpty 
            ? 1 
            : queue.clients.map((c) => c.position).reduce((a, b) => a > b ? a : b) + 1;
        
        print('Next position: $nextPosition');
        
        final newClient = QueueClient(
          id: client.id,
          queueId: queueId,
          userId: client.userId,
          name: client.name,
          position: nextPosition,
          status: 'waiting',
        );

        print('Creating client: ${newClient.name} at position ${newClient.position}');
        await _queueClientRepository.createClient(newClient);
      }
      
      await loadQueues();
      print('=== joinQueue SUCCESS ===');
    } catch (e, stackTrace) {
      print('=== joinQueue ERROR ===');
      print('Error: $e');
      print('StackTrace: $stackTrace');
      emit(QueueError(error: e.toString()));
    }
  }

  Future<void> leaveQueue(int clientId) async {
    print('=== leaveQueue START ===');
    print('Client ID: $clientId');
    try {
      emit(QueueLoading());
      
      if (clientId < 0) {
        // Manual customer
        print('Removing manual customer with realId: ${-clientId}');
        final realId = -clientId;
        await _manualCustomerRepository?.deleteManualCustomer(realId);
      } else {
        // Regular client
        print('Removing regular client');
        final client = await _queueClientRepository.getClient(clientId);
        await _queueClientRepository.deleteClient(clientId);
        
        if (client != null) {
          print('Reordering queue ${client.queueId}');
          await _reorderQueue(client.queueId);
        }
      }
      
      await loadQueues();
      print('=== leaveQueue SUCCESS ===');
    } catch (e, stackTrace) {
      print('=== leaveQueue ERROR ===');
      print('Error: $e');
      print('StackTrace: $stackTrace');
      emit(QueueError(error: e.toString()));
    }
  }

  Future<void> _reorderQueue(int queueId) async {
    print('=== _reorderQueue START ===');
    print('Queue ID: $queueId');
    try {
      final clients = await _queueClientRepository.getClientsByQueue(queueId);
      clients.sort((a, b) => a.position.compareTo(b.position));
      
      print('Reordering ${clients.length} clients');
      for (int i = 0; i < clients.length; i++) {
        final newPosition = i + 1;
        if (clients[i].position != newPosition) {
          print('Updating client ${clients[i].name} position: ${clients[i].position} -> $newPosition');
          await _queueClientRepository.updateClient(
            clients[i].copyWith(position: newPosition),
          );
        }
      }
      print('=== _reorderQueue SUCCESS ===');
    } catch (e, stackTrace) {
      print('=== _reorderQueue ERROR ===');
      print('Error: $e');
      print('StackTrace: $stackTrace');
    }
  }

  Future<void> moveToServing(int? clientId) async {
    print('=== moveToServing START ===');
    print('clientId: $clientId');
    
    try {
      emit(ClientServing());
      
      if (clientId != null && clientId < 0) {
        // Manual customer
        print('Handling manual customer with realId: ${-clientId}');
        final realId = -clientId;
        await _manualCustomerRepository?.updateManualCustomerStatus(realId, 'serving');
      } else if (clientId != null) {
        // Regular client
        print('Handling regular client with id: $clientId');
        await _queueClientRepository.updateClientStatus(clientId, 'serving');
      }
      
      await loadQueues();
      print('=== moveToServing SUCCESS ===');
    } catch (e, stackTrace) {
      print('=== moveToServing ERROR ===');
      print('Error: $e');
      print('StackTrace: $stackTrace');
      emit(QueueError(error: 'Failed to move client to serving: $e'));
    }
  }

  Future<void> notifyClient(int? clientId) async {
    print('=== notifyClient START ===');
    print('clientId: $clientId');
    
    try {
      emit(ClientNotified());
      
      if (clientId != null && clientId < 0) {
        // Handle manual customer
        print('Handling manual customer with realId: ${-clientId}');
        final realId = -clientId;
        await _manualCustomerRepository?.updateManualCustomerStatus(realId, 'notified');
      } else if (clientId != null) {
        // Handle regular queue client
        print('Handling regular client with id: $clientId');
        
        // Find the client and queue details from current state
        QueueClient? client;
        Queue? queue;
        
        if (state is QueueLoaded) {
          final queues = (state as QueueLoaded).queues;
          for (final q in queues) {
            final found = q.clients.where((c) => c.id == clientId).firstOrNull;
            if (found != null) {
              client = found;
              queue = q;
              print('Found client: ${client.name}, queue: ${queue.name}');
              break;
            }
          }
        }
        
        if (client != null && queue != null && client.userId != null) {
          // Create notification record in Supabase
          final now = DateTime.now().millisecondsSinceEpoch;
          final notificationData = {
            'user_id': client.userId,
            'queue_id': queue.id,
            'title': 'Your Turn is Coming!',
            'message': 'Your turn is coming up in ${queue.name}. Please get ready!',
            'created_at': now,
            'is_read': false,
          };
          
          print('Inserting notification: $notificationData');
          
          try {
            final result = await SupabaseService.client
                .from('notifications')
                .insert(notificationData)
                .select();
            print('Notification inserted successfully: $result');
          } catch (e) {
            print('ERROR inserting notification: $e');
            if (e is PostgrestException) {
              print('PostgrestException - Code: ${e.code}, Message: ${e.message}, Details: ${e.details}, Hint: ${e.hint}');
            }
            // Don't stop execution, continue with status update
          }
        } else {
          print('WARNING: Could not find client or queue details');
          print('client: $client, queue: $queue, userId: ${client?.userId}');
        }
        
        // Update client status to 'notified'
        print('Updating client status to notified');
        await _queueClientRepository.updateClientStatus(clientId, 'notified');
      }
      
      await loadQueues();
      print('=== notifyClient SUCCESS ===');
    } catch (e, stackTrace) {
      print('=== notifyClient ERROR ===');
      print('Error: $e');
      print('StackTrace: $stackTrace');
      emit(QueueError(error: 'Failed to notify client: $e'));
    }
  }

  Future<void> completeService(int? clientId) async {
    print('=== completeService START ===');
    print('clientId: $clientId');
    
    try {
      emit(ServiceCompleted());
      
      if (clientId != null && clientId < 0) {
        // Manual customer
        print('Handling manual customer with realId: ${-clientId}');
        final realId = -clientId;
        await _manualCustomerRepository?.deleteManualCustomer(realId);
      } else if (clientId != null) {
        // Regular client
        print('Handling regular client with id: $clientId');
        final client = await _queueClientRepository.getClient(clientId);
        await _queueClientRepository.deleteClient(clientId);
        
        if (client != null) {
          print('Reordering queue ${client.queueId}');
          await _reorderQueue(client.queueId);
        }
      }
      
      await loadQueues();
      print('=== completeService SUCCESS ===');
    } catch (e, stackTrace) {
      print('=== completeService ERROR ===');
      print('Error: $e');
      print('StackTrace: $stackTrace');
      emit(QueueError(error: 'Failed to complete service: $e'));
    }
  }

  @override
  Future<void> close() {
    print('=== QueueCubit close ===');
    _queueSubscription?.cancel();
    _clientSubscription?.cancel();
    return super.close();
  }
}
