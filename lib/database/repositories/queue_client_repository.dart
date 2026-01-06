import 'package:supabase_flutter/supabase_flutter.dart';
import '../tables.dart';
import '../models/queue_client_model.dart';
import '../models/queue_model.dart';
import '../../services/supabase_service.dart';

class QueueClientRepository {
  final SupabaseClient _client;

  QueueClientRepository({SupabaseClient? client}) : _client = client ?? SupabaseService.client;

  Future<int> insertQueueClient(QueueClient client) async {
    final result = await _client.from(DatabaseTables.queueClients).insert(client.toMap()).select().maybeSingle();
    if (result == null) return 0;
    return (result['id'] as int?) ?? 0;
  }

  Future<List<QueueClient>> getQueueClients(int queueId) async {
    final results = await _client
        .from(DatabaseTables.queueClients)
        .select()
        .eq('queue_id', queueId)
        .order('position', ascending: true) as List<dynamic>;
    return results.map((r) => QueueClient.fromMap(Map<String, dynamic>.from(r))).toList();
  }

  Future<List<Queue>> getQueuesByUser(int? userId, {bool includeServed = false}) async {
    if (userId == null) return [];
    final allClients = await _client.from(DatabaseTables.queueClients).select().eq('user_id', userId) as List<dynamic>;
    final filtered = includeServed ? allClients : allClients.where((c) => c['status'] != 'served');
    final queueIds = filtered.map((c) => c['queue_id'] as int).toSet().toList();

    if (queueIds.isEmpty) return [];

    // Fetch each queue by id to ensure we only return queues the user actually joined.
    final List<Queue> queues = [];
    for (final id in queueIds) {
      final q = await _client.from(DatabaseTables.queues).select().eq('id', id).maybeSingle();
      if (q == null) continue;
      final queue = Queue.fromMap(Map<String, dynamic>.from(q));
      queue.clients = await getQueueClients(queue.id);
      queues.add(queue);
    }

    return queues;
  }

  Future<int> getActiveQueuesCountForUser(int? userId) async {
    if (userId == null) return 0;
    final results = await _client
        .from(DatabaseTables.queueClients)
        .select('queue_id')
        .eq('user_id', userId) as List<dynamic>;
    final active = results.where((r) => r['status'] != 'served').map((r) => r['queue_id'] as int).toSet().length;
    return active;
  }

  Future<QueueClient?> getQueueClient(int queueId, int? userId) async {
    if (userId == null) return null;
    final result = await _client
        .from(DatabaseTables.queueClients)
        .select()
        .eq('queue_id', queueId)
        .eq('user_id', userId)
        .maybeSingle();
    if (result == null) return null;
    return QueueClient.fromMap(Map<String, dynamic>.from(result));
  }

  Future<int> updateQueueClient(QueueClient client) async {
    if (client.id == null) return 0;
    final id = client.id!;
    await _client.from(DatabaseTables.queueClients).update(client.toMap()).eq('id', id);
    return id;
  }

  Future<int> deleteQueueClient(int? id) async {
    if (id == null) return 0;
    await _client.from(DatabaseTables.queueClients).delete().eq('id', id);
    return id;
  }

  Future<int> getNextPosition(int queueId) async {
    final results = await _client
        .from(DatabaseTables.queueClients)
        .select('position')
        .eq('queue_id', queueId)
        .order('position', ascending: false)
        .limit(1) as List<dynamic>;
    if (results.isEmpty) return 1;
    final maxPos = results.first['position'] as int? ?? 0;
    return maxPos + 1;
  }

  Future<void> updateClientStatus(int? clientId, String status) async {
    if (clientId == null) return;

    final now = DateTime.now().millisecondsSinceEpoch;
    final updates = <String, dynamic>{'status': status};
    if (status == 'served') updates['served_at'] = now;
    if (status == 'notified') updates['notified_at'] = now;

    // If serving a client, move them to the end by assigning the next position,
    // then reorder positions so numbering stays contiguous.
    if (status == 'served') {
      // get the queue id for this client
      final clientRec = await _client
          .from(DatabaseTables.queueClients)
          .select()
          .eq('id', clientId)
          .maybeSingle();
      final queueId = clientRec != null ? clientRec['queue_id'] as int? : null;

      if (queueId != null) {
        final nextPos = await getNextPosition(queueId);
        updates['position'] = nextPos;
        await _client
            .from(DatabaseTables.queueClients)
            .update(updates)
            .eq('id', clientId);

        // Normalize positions so served client ends up at the end.
        await reorderPositions(queueId);
        return;
      }
    }

    await _client.from(DatabaseTables.queueClients).update(updates).eq('id', clientId);
  }

  /// Move a served client to the end of the queue by reassigning positions.
  Future<void> moveServedClientToEnd(int queueId, int clientId) async {
    final clients = await getQueueClients(queueId);
    final index = clients.indexWhere((c) => c.id == clientId);
    if (index == -1) return;

    final moved = clients.removeAt(index);
    clients.add(moved);

    for (int i = 0; i < clients.length; i++) {
      final cid = clients[i].id;
      if (cid == null) continue;
      await _client
          .from(DatabaseTables.queueClients)
          .update({'position': i + 1}).eq('id', cid);
    }
  }

  Future<void> reorderPositions(int queueId) async {
    final clients = await getQueueClients(queueId);
    for (int i = 0; i < clients.length; i++) {
      final cid = clients[i].id;
      if (cid == null) continue;
      await _client.from(DatabaseTables.queueClients).update({'position': i + 1}).eq('id', cid);
    }
  }
}
