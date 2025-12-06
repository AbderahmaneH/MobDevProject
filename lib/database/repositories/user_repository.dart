import 'package:sqflite/sqflite.dart';
import '../tables.dart';
import '../models/user_model.dart';
import '../db_helper.dart';

class UserRepository {
  final DatabaseHelper databaseHelper;

  UserRepository({required this.databaseHelper});

  Future<int> insertUser(User user) async {
    final db = await databaseHelper.database;
    return await db.insert(
      DatabaseTables.users,
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<User?> getUserById(int? id) async {
    final db = await databaseHelper.database;
    final maps = await db.query(
      DatabaseTables.users,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  Future<User?> getUserByPhone(String phone) async {
    final db = await databaseHelper.database;
    final maps = await db.query(
      DatabaseTables.users,
      where: 'phone = ?',
      whereArgs: [phone],
    );
    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  Future<bool> isPhoneRegistered(String phone) async {
    final db = await databaseHelper.database;
    final maps = await db.query(
      DatabaseTables.users,
      where: 'phone = ?',
      whereArgs: [phone],
    );
    return maps.isNotEmpty;
  }

  Future<List<User>> getAllUsers() async {
    final db = await databaseHelper.database;
    final maps = await db.query(DatabaseTables.users);
    return maps.map((map) => User.fromMap(map)).toList();
  }

  Future<int> updateUser(User user) async {
    final db = await databaseHelper.database;
    return await db.update(
      DatabaseTables.users,
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  Future<int> deleteUser(int id) async {
    final db = await databaseHelper.database;
    return await db.delete(
      DatabaseTables.users,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
