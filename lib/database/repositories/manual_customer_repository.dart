import '../../services/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../tables.dart';
import '../models/manual_customer_model.dart';

class ManualCustomerRepository {
  final SupabaseClient _client;

  ManualCustomerRepository({SupabaseClient? client}) : _client = client ?? SupabaseService.client;

  Future<int> insertManualCustomer(ManualCustomer c) async {
    final result = await _client.from(DatabaseTables.manualCustomers).insert(c.toMap()).select().maybeSingle();
    if (result == null) return 0;
    return (result['id'] as int?) ?? 0;
  }

  Future<List<ManualCustomer>> getByQueue(int queueId) async {
    final results = await _client.from(DatabaseTables.manualCustomers).select().eq('queue_id', queueId).order('id', ascending: true) as List<dynamic>;
    return results.map((r) => ManualCustomer.fromMap(Map<String, dynamic>.from(r))).toList();
  }

  Future<int> deleteByQueue(int queueId) async {
    await _client.from(DatabaseTables.manualCustomers).delete().eq('queue_id', queueId);
    return queueId;
  }

  Future<int> deleteManualCustomer(int? id) async {
    if (id == null) return 0;
    await _client.from(DatabaseTables.manualCustomers).delete().eq('id', id);
    return id;
  }

  Future<int> updateManualCustomerStatus(int? id, String status) async {
    if (id == null) return 0;
    final updates = <String, dynamic>{'status': status};
    if (status == 'served') updates['served_at'] = DateTime.now().millisecondsSinceEpoch;
    await _client.from(DatabaseTables.manualCustomers).update(updates).eq('id', id);
    return id;
  }
}