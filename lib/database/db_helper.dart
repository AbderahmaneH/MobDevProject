import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'tables.dart';
import 'dummy_data.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'qnow2.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onConfigure: _onConfigure,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Create all tables
    for (final query in DatabaseTables.createTableQueries) {
      await db.execute(query);
    }

    // Create all indexes
    for (final query in DatabaseIndexes.createIndexQueries) {
      await db.execute(query);
    }

    // Insert dummy data for testing
    await insertDummyData(db);
  }

  Future<void> _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future<void> clearDatabase() async {
    final db = await database;
    await db.delete(DatabaseTables.queueClients);
    await db.delete(DatabaseTables.queues);
    await db.delete(DatabaseTables.users);
  }

  Future<void> resetDatabase() async {
    final db = await database;
    await db.close();
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'qnow.db');
    await deleteDatabase(path);
    _database = null;
    await database; // Reinitialize database
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}