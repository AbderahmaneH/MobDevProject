import 'package:supabase_flutter/supabase_flutter.dart' hide User;
import '../tables.dart';
import '../models/user_model.dart';
import '../../services/supabase_service.dart';

class UserRepository {
  final SupabaseClient _client;

  UserRepository({SupabaseClient? client}) : _client = client ?? SupabaseService.client;

  Future<int> insertUser(User user) async {
    final result = await _client.from(DatabaseTables.users).insert(user.toMap()).select().maybeSingle();
    if (result == null) return 0;
    return (result['id'] as int?) ?? 0;
  }

  Future<User?> getUserById(int? id) async {
    if (id == null) return null;
    final result = await _client.from(DatabaseTables.users).select().eq('id', id).maybeSingle();
    if (result == null) return null;
    return User.fromMap(Map<String, dynamic>.from(result));
  }

  Future<User?> getUserByPhone(String phone) async {
    final result = await _client.from(DatabaseTables.users).select().eq('phone', phone).maybeSingle();
    if (result == null) return null;
    return User.fromMap(Map<String, dynamic>.from(result));
  }

  Future<User?> getUserByEmail(String email) async {
    final result = await _client.from(DatabaseTables.users).select().eq('email', email).maybeSingle();
    if (result == null) return null;
    return User.fromMap(Map<String, dynamic>.from(result));
  }

  Future<bool> isPhoneRegistered(String phone) async {
    final result = await _client.from(DatabaseTables.users).select('id').eq('phone', phone).maybeSingle();
    return result != null;
  }

  Future<List<User>> getAllUsers() async {
    final results = await _client.from(DatabaseTables.users).select().order('created_at', ascending: false) as List<dynamic>;
    return results.map((r) => User.fromMap(Map<String, dynamic>.from(r))).toList();
  }

  Future<int> updateUser(User user) async {
    if (user.id == null) return 0;
    final id = user.id!;
    await _client.from(DatabaseTables.users).update(user.toMap()).eq('id', id);
    return id;
  }

  Future<int> deleteUser(int id) async {
    await _client.from(DatabaseTables.users).delete().eq('id', id);
    return id;
  }
}
