import 'package:sqflite/sqflite.dart';
import '../tables.dart';
import '../models/queue_client_model.dart';
import '../models/queue_model.dart';
import '../db_helper.dart';

class QueueClientRepository {
  final DatabaseHelper databaseHelper;

  QueueClientRepository({required this.databaseHelper});

  Future<int> insertQueueClient(QueueClient client) async {
    final db = await databaseHelper.database;
    return await db.insert(
      DatabaseTables.queueClients,
      client.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<QueueClient>> getQueueClients(int queueId) async {
    final db = await databaseHelper.database;
    final maps = await db.query(
      DatabaseTables.queueClients,
      where: 'queue_id = ?',
      whereArgs: [queueId],
      orderBy: 'position ASC',
    );
    return maps.map((map) => QueueClient.fromMap(map)).toList();
  }

  Future<List<Queue>> getQueuesByUser(int? userId) async {
    final db = await databaseHelper.database;

    // Get all queue IDs where user is a client
    final clientMaps = await db.query(
      DatabaseTables.queueClients,
      columns: ['queue_id'],
      where: 'user_id = ? AND status != ?',
      whereArgs: [userId, 'served'],
      distinct: true,
    );

    final queueIds = clientMaps.map((map) => map['queue_id'] as int).toList();

    if (queueIds.isEmpty) return [];

    // Get all queues where user is a client
    final queueMaps = await db.query(
      DatabaseTables.queues,
      where: 'id IN (${queueIds.map((_) => '?').join(',')})',
      whereArgs: queueIds,
    );

    final queues = queueMaps.map((map) => Queue.fromMap(map)).toList();

    // Load clients for each queue
    for (final queue in queues) {
      queue.clients = await getQueueClients(queue.id);
    }

    return queues;
  }

  Future<int> getActiveQueuesCountForUser(int? userId) async {
    final db = await databaseHelper.database;
    final maps = await db.rawQuery(
      '''
      SELECT COUNT(DISTINCT queue_id) as cnt
      FROM ${DatabaseTables.queueClients}
      WHERE user_id = ? AND status != ?
      ''',
      [userId, 'served'],
    );

    final cnt = maps.first['cnt'];
    if (cnt is int) return cnt;
    return int.tryParse(cnt.toString()) ?? 0;
  }

  Future<QueueClient?> getQueueClient(int queueId, int? userId) async {
    final db = await databaseHelper.database;
    final maps = await db.query(
      DatabaseTables.queueClients,
      where: 'queue_id = ? AND user_id = ?',
      whereArgs: [queueId, userId],
    );
    if (maps.isNotEmpty) {
      return QueueClient.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateQueueClient(QueueClient client) async {
    final db = await databaseHelper.database;
    return await db.update(
      DatabaseTables.queueClients,
      client.toMap(),
      where: 'id = ?',
      whereArgs: [client.id],
    );
  }

  Future<int> deleteQueueClient(int? id) async {
    final db = await databaseHelper.database;
    return await db.delete(
      DatabaseTables.queueClients,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> getNextPosition(int queueId) async {
    final db = await databaseHelper.database;
    final maps = await db.rawQuery(
      '''
      SELECT MAX(position) as max_position 
      FROM ${DatabaseTables.queueClients} 
      WHERE queue_id = ?
    ''',
      [queueId],
    );

    final maxPosition = maps.first['max_position'];
    return (maxPosition as int? ?? 0) + 1;
  }

  Future<void> updateClientStatus(int? clientId, String status) async {
    final db = await databaseHelper.database;
    final now = DateTime.now().millisecondsSinceEpoch;

    Map<String, dynamic> updates = {'status': status};

    if (status == 'served') {
      updates['served_at'] = now;
    } else if (status == 'notified') {
      updates['notified_at'] = now;
    }

    await db.update(
      DatabaseTables.queueClients,
      updates,
      where: 'id = ?',
      whereArgs: [clientId],
    );
  }

  Future<void> reorderPositions(int queueId) async {
    final db = await databaseHelper.database;
    final clients = await getQueueClients(queueId);

    for (int i = 0; i < clients.length; i++) {
      await db.update(
        DatabaseTables.queueClients,
        {'position': i + 1},
        where: 'id = ?',
        whereArgs: [clients[i].id],
      );
    }
  }
}
