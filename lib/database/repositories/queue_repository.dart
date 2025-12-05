import 'package:sqflite/sqflite.dart';
import '../tables.dart';
import '../models/queue_client_model.dart';
import '../models/queue_model.dart';
import '../db_helper.dart';

class QueueRepository {
  final DatabaseHelper databaseHelper;

  QueueRepository({required this.databaseHelper});

  Future<int> insertQueue(Queue queue) async {
    final db = await databaseHelper.database;
    return await db.insert(
      DatabaseTables.queues,
      queue.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Queue?> getQueueById(int id) async {
    final db = await databaseHelper.database;
    final maps = await db.query(
      DatabaseTables.queues,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      final queue = Queue.fromMap(maps.first);
      queue.clients = await _getQueueClients(id);
      return queue;
    }
    return null;
  }

  Future<List<Queue>> getQueuesByBusinessOwner(int? businessOwnerId) async {
    final db = await databaseHelper.database;
    final maps = await db.query(
      DatabaseTables.queues,
      where: 'business_owner_id = ?',
      whereArgs: [businessOwnerId],
    );

    final queues = maps.map((map) => Queue.fromMap(map)).toList();

    // Load clients for each queue
    for (final queue in queues) {
      queue.clients = await _getQueueClients(queue.id);
    }

    return queues;
  }

  Future<List<Queue>> getAllQueues({bool activeOnly = true}) async {
    final db = await databaseHelper.database;
    final List<Map<String, dynamic>> maps;

    if (activeOnly) {
      maps = await db.query(DatabaseTables.queues, where: 'is_active = 1');
    } else {
      maps = await db.query(DatabaseTables.queues);
    }

    final queues = maps.map((map) => Queue.fromMap(map)).toList();

    // Load clients for each queue
    for (final queue in queues) {
      queue.clients = await _getQueueClients(queue.id);
    }

    return queues;
  }

  Future<List<Queue>> searchQueues(String query) async {
    final db = await databaseHelper.database;
    final maps = await db.query(
      DatabaseTables.queues,
      where: 'name LIKE ? AND is_active = 1',
      whereArgs: ['%$query%'],
    );

    final queues = maps.map((map) => Queue.fromMap(map)).toList();

    // Load clients for each queue
    for (final queue in queues) {
      queue.clients = await _getQueueClients(queue.id);
    }

    return queues;
  }

  Future<int> updateQueue(Queue queue) async {
    final db = await databaseHelper.database;
    return await db.update(
      DatabaseTables.queues,
      queue.toMap(),
      where: 'id = ?',
      whereArgs: [queue.id],
    );
  }

  Future<int> deleteQueue(int id) async {
    final db = await databaseHelper.database;
    return await db.delete(
      DatabaseTables.queues,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Helper to load clients for a queue
  Future<List<QueueClient>> _getQueueClients(int queueId) async {
    final db = await databaseHelper.database;
    final maps = await db.query(
      DatabaseTables.queueClients,
      where: 'queue_id = ?',
      whereArgs: [queueId],
      orderBy: 'position ASC',
    );
    return maps.map((map) => QueueClient.fromMap(map)).toList();
  }
}
