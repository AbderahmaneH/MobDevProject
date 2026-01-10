import 'dart:math';
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
    await _cleanupExpiredQueues();
    final result = await _client.from(DatabaseTables.queues).select().eq('id', id).maybeSingle();
    if (result == null) return null;
    final queue = Queue.fromMap(Map<String, dynamic>.from(result));
    queue.clients = await _getMergedQueueClients(queue.id);
    return queue;
  }

  Future<List<Queue>> getQueuesByBusinessOwner(int? businessOwnerId) async {
    await _cleanupExpiredQueues();
    if (businessOwnerId == null) return [];
    final results = await _client
      .from(DatabaseTables.queues)
      .select()
      .eq('business_owner_id', businessOwnerId)
      .order('created_at', ascending: false) as List<dynamic>;

    final queues = results.map((r) => Queue.fromMap(Map<String, dynamic>.from(r))).toList();

    for (final queue in queues) {
      queue.clients = await _getMergedQueueClients(queue.id);
    }

    return queues;
  }

  Future<List<Queue>> getAllQueues({bool activeOnly = true}) async {
    await _cleanupExpiredQueues();
    final query = _client.from(DatabaseTables.queues).select();
    if (activeOnly) {
      query.eq('is_active', 1);
    }
    final results = await query.order('created_at', ascending: false) as List<dynamic>;

    final queues = results.map((r) => Queue.fromMap(Map<String, dynamic>.from(r))).toList();
    for (final queue in queues) {
      queue.clients = await _getMergedQueueClients(queue.id);
    }
    return queues;
  }

  Future<List<Queue>> searchQueues(String queryStr) async {
    await _cleanupExpiredQueues();
    final results = await _client
        .from(DatabaseTables.queues)
        .select()
        .ilike('name', '%$queryStr%')
        .eq('is_active', 1) as List<dynamic>;

    final queues = results.map((r) => Queue.fromMap(Map<String, dynamic>.from(r))).toList();
    for (final queue in queues) {
      queue.clients = await _getMergedQueueClients(queue.id);
    }
    return queues;
  }

  Future<List<Map<String, dynamic>>> searchQueuesByLocation({
    required double userLatitude,
    required double userLongitude,
    double maxDistanceKm = 50,
    String? searchQuery,
  }) async {
    await _cleanupExpiredQueues();
    
    // Get all active queues with business owner info
    var query = _client
        .from(DatabaseTables.queues)
        .select('*, ${DatabaseTables.users}!inner(id, business_name, name, business_address, latitude, longitude, city, area)')
        .eq('is_active', 1);
    
    if (searchQuery != null && searchQuery.isNotEmpty) {
      query = query.ilike('name', '%$searchQuery%');
    }
    
    final results = await query as List<dynamic>;
    
    // Calculate distances and filter
    final queuesWithDistance = <Map<String, dynamic>>[];
    
    for (final result in results) {
      final queueData = Map<String, dynamic>.from(result);
      final ownerData = queueData[DatabaseTables.users];
      
      if (ownerData != null && ownerData['latitude'] != null && ownerData['longitude'] != null) {
        final double ownerLat = ownerData['latitude'];
        final double ownerLng = ownerData['longitude'];
        
        // Calculate distance using Haversine formula
        final distance = _calculateDistance(
          userLatitude,
          userLongitude,
          ownerLat,
          ownerLng,
        );
        
        if (distance <= maxDistanceKm) {
          final queue = Queue.fromMap(Map<String, dynamic>.from(queueData));
          queue.clients = await _getMergedQueueClients(queue.id);
          
          queuesWithDistance.add({
            'queue': queue,
            'distance': distance,
            'businessName': ownerData['business_name'] ?? ownerData['name'],
            'address': ownerData['business_address'],
            'city': ownerData['city'],
            'area': ownerData['area'],
            'latitude': ownerLat,
            'longitude': ownerLng,
          });
        }
      }
    }
    
    // Sort by distance
    queuesWithDistance.sort((a, b) => (a['distance'] as double).compareTo(b['distance'] as double));
    
    return queuesWithDistance;
  }
  
  // Calculate distance between two coordinates using Haversine formula
  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadiusKm = 6371.0;
    
    final dLat = _degreesToRadians(lat2 - lat1);
    final dLon = _degreesToRadians(lon2 - lon1);
    
    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(lat1)) *
        cos(_degreesToRadians(lat2)) *
        sin(dLon / 2) *
        sin(dLon / 2);
    
    final c = 2 * asin(sqrt(a));
    
    return earthRadiusKm * c;
  }
  
  double _degreesToRadians(double degrees) {
    return degrees * pi / 180.0;
  }

  Future<List<Queue>> searchQueuesByOwnerPhone(String phone) async {
    await _cleanupExpiredQueues();
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
    await _client.from(DatabaseTables.manualCustomers).delete().eq('queue_id', id);
    await _client.from(DatabaseTables.queues).delete().eq('id', id);
    return id;
  }

  Future<void> _cleanupExpiredQueues() async {
    final now = DateTime.now().millisecondsSinceEpoch;
    const int dayMs = 24 * 3600 * 1000;
    final cutoff = now - dayMs;

    try {
      final expired = await _client
          .from(DatabaseTables.queues)
          .select('id')
          .lt('created_at', cutoff) as List<dynamic>;

      for (final q in expired) {
        final id = q['id'] as int?;
        if (id != null) {
          await deleteQueue(id);
        }
      }
    } catch (_) {
    }
  }

  Future<List<QueueClient>> _getQueueClients(int queueId) async {
    final results = await _client
        .from(DatabaseTables.queueClients)
        .select()
        .eq('queue_id', queueId)
        .order('position', ascending: true) as List<dynamic>;
    return results.map((r) => QueueClient.fromMap(Map<String, dynamic>.from(r))).toList();
  }

  // Fetch queue clients (regular clients) and manual customers and merge them.
  Future<List<QueueClient>> _getMergedQueueClients(int queueId) async {
    // load queue_clients
    final results = await _client
        .from(DatabaseTables.queueClients)
        .select()
        .eq('queue_id', queueId)
        .order('position', ascending: true) as List<dynamic>;
    final clients = results.map((r) => QueueClient.fromMap(Map<String, dynamic>.from(r))).toList();

    // load manual customers
    final manualResults = await _client.from(DatabaseTables.manualCustomers).select().eq('queue_id', queueId).order('id', ascending: true) as List<dynamic>;
    if (manualResults.isNotEmpty) {
      // Assign positions 0 for manual customers 
      for (final m in manualResults) {
        final mid = m['id'] as int?;
        final name = m['name'] as String? ?? '';
        final status = m['status'] as String? ?? 'waiting';
        final servedAtMs = m['served_at'] as int?;
        final servedAt = servedAtMs != null ? DateTime.fromMillisecondsSinceEpoch(servedAtMs) : null;
        // Create a synthetic QueueClient for display. Use negative id to identify manual records.
        final synthetic = QueueClient(
          id: mid != null ? -mid : null,
          queueId: queueId,
          userId: null,
          name: name,
          phone: '',
          position: 0,
          status: status,
          joinedAt: DateTime.now(),
          servedAt: servedAt,
        );
        clients.add(synthetic);
      }
    }

    return clients;
  }
}
