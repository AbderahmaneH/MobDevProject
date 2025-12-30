import 'package:supabase_flutter/supabase_flutter.dart';
import '../tables.dart';
import '../models/queue_client_model.dart';
import '../models/queue_model.dart';
import '../../services/supabase_service.dart';

class QueueRepository {
  final SupabaseClient _client;

  QueueRepository({SupabaseClient? client}) : _client = client ?? SupabaseService.client;

  Future<int> insertQueue(Queue queue) async {
    final result = await _client.from(DatabaseTables.queues).insert(queue.toMap()).select().maybeSingle();
    if (result == null) return 0;
    return (result['id'] as int?) ?? 0;
  }

  Future<Queue?> getQueueById(int id) async {
    final result = await _client.from(DatabaseTables.queues).select().eq('id', id).maybeSingle();
    if (result == null) return null;
    final queue = Queue.fromMap(Map<String, dynamic>.from(result));
    queue.clients = await _getQueueClients(queue.id);
    return queue;
  }

  Future<List<Queue>> getQueuesByBusinessOwner(int? businessOwnerId) async {
    if (businessOwnerId == null) return [];
    final results = await _client
      .from(DatabaseTables.queues)
      .select()
      .eq('business_owner_id', businessOwnerId)
      .order('created_at', ascending: false) as List<dynamic>;

    final queues = results.map((r) => Queue.fromMap(Map<String, dynamic>.from(r))).toList();

    for (final queue in queues) {
      queue.clients = await _getQueueClients(queue.id);
    }

    return queues;
  }

  Future<List<Queue>> getAllQueues({bool activeOnly = true}) async {
    final query = _client.from(DatabaseTables.queues).select();
    if (activeOnly) {
      query.eq('is_active', 1);
    }
    final results = await query.order('created_at', ascending: false) as List<dynamic>;

    final queues = results.map((r) => Queue.fromMap(Map<String, dynamic>.from(r))).toList();
    for (final queue in queues) {
      queue.clients = await _getQueueClients(queue.id);
    }
    return queues;
  }

  Future<List<Queue>> searchQueues(String queryStr) async {
    final results = await _client
        .from(DatabaseTables.queues)
        .select()
        .ilike('name', '%$queryStr%')
        .eq('is_active', 1) as List<dynamic>;

    final queues = results.map((r) => Queue.fromMap(Map<String, dynamic>.from(r))).toList();
    for (final queue in queues) {
      queue.clients = await _getQueueClients(queue.id);
    }
    return queues;
  }

  Future<List<Queue>> searchQueuesByOwnerPhone(String phone) async {
    // find users whose phone matches (partial match)
    final userResults = await _client
        .from(DatabaseTables.users)
        .select()
        .ilike('phone', '%$phone%') as List<dynamic>;

    if (userResults.isEmpty) return [];

    final ownerIds = userResults.map((u) => u['id'] as int).toList();

    final queueQuery = _client.from(DatabaseTables.queues).select();
    if (ownerIds.length == 1) {
      queueQuery.eq('business_owner_id', ownerIds.first);
    } else {
      final cond = ownerIds.map((id) => 'business_owner_id.eq.$id').join(',');
      queueQuery.or(cond);
    }
    queueQuery.eq('is_active', 1).order('created_at', ascending: false);
    final results = await queueQuery as List<dynamic>;

    final queues = results.map((r) => Queue.fromMap(Map<String, dynamic>.from(r))).toList();
    for (final queue in queues) {
      queue.clients = await _getQueueClients(queue.id);
    }
    return queues;
  }

  Future<int> updateQueue(Queue queue) async {
    await _client.from(DatabaseTables.queues).update(queue.toMap()).eq('id', queue.id);
    return queue.id;
  }

  Future<int> deleteQueue(int id) async {
    await _client.from(DatabaseTables.queueClients).delete().eq('queue_id', id);
    await _client.from(DatabaseTables.queues).delete().eq('id', id);
    return id;
  }

  Future<List<QueueClient>> _getQueueClients(int queueId) async {
    final results = await _client
        .from(DatabaseTables.queueClients)
        .select()
        .eq('queue_id', queueId)
        .order('position', ascending: true) as List<dynamic>;
    return results.map((r) => QueueClient.fromMap(Map<String, dynamic>.from(r))).toList();
  }
}
