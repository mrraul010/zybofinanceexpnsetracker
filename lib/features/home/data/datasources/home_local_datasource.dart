import 'package:sqflite/sqflite.dart';
import 'dart:developer' as developer;
import 'package:zyboexpensetracker/features/home/data/models/local_transactionmodel.dart';
import 'package:zyboexpensetracker/features/home/databases/database_helpers.dart';

class HomeLocalDatasource {
  final DatabaseHelper dbHelper;

  HomeLocalDatasource(this.dbHelper);

  Future<Map<String, double>> getHomeoverviewTotals() async {
    final db = await dbHelper.database;

    final result = await db.rawQuery(
      ''' SELECT SUM (CASE WHEN type = 'credit' THEN amount ELSE 0 END) as  total_income ,
SUM(CASE  WHEN type = 'debit' THEN amount ELSE 0 END) as  total_expense  FROM transactions WHERE is_deleted = 0
''',
    );

    if (result.isNotEmpty) {
      return {
        'total_income': (result.first['total_income'] as num? ?? 0.0)
            .toDouble(),
        'total_expense': (result.first['total_expense'] as num? ?? 0.0)
            .toDouble(),
      };
    }
    return {'total_income': 0.0, 'total_expense': 0.0};
  }


  Future<List<Map<String, dynamic>>> getSoftDeletedItems(String tableName) async {
    final db = await dbHelper.database;
    developer.log('SQL: Querying soft-deleted items from table: $tableName', name: 'SQLite');
    return await db.query(tableName, where: 'is_deleted = 1');
  }

Future<List<Map<String, dynamic>>> getUnsyncedItems(String tableName) async {
    final db = await dbHelper.database;
    developer.log('SQL: Querying active, unsynced items from table: $tableName', name: 'SQLite');
    return await db.query(tableName, where: 'is_synced = 0 AND is_deleted = 0');
  }
Future<void> hardDeleteItems(String tableName, List<String> ids) async {
    if (ids.isEmpty) return;
    final db = await dbHelper.database;
    final placeholders = List.filled(ids.length, '?').join(', ');
    developer.log('SQL: Hard deleting records from $tableName where IDs in: $ids', name: 'SQLite');
    await db.delete(
      tableName,
      where: 'id IN ($placeholders)',
      whereArgs: ids,
    );
  }

Future<void> updateSyncStatus(String tableName, List<String> ids) async {
    if (ids.isEmpty) return;
    final db = await dbHelper.database;
    final placeholders = List.filled(ids.length, '?').join(', ');
    developer.log('SQL: Updating sync flag to 1 for $tableName where IDs in: $ids', name: 'SQLite');
    await db.update(
      tableName,
      {'is_synced': 1},
      where: 'id IN ($placeholders)',
      whereArgs: ids,
    );
  }


  Future<List<LocalTransactionmodel>> getToptenRecentTransactions() async {
    final db = await dbHelper.database;

    final List<Map<String, dynamic>> maps = await db.rawQuery('''  
SELECT 
        t.id, t.amount, t.note, t.type, t.timestamp,
        c.name AS category_name
      FROM transactions t
      INNER JOIN categories c ON t.category_id = c.id
      WHERE t.is_deleted = 0
      ORDER BY t.timestamp DESC
      LIMIT 10


 ''');

    return maps.map((row) => LocalTransactionmodel.fromMap(row)).toList();
  }

  Future<List<LocalTransactionmodel>> getAllTransactions() async {
    final db = await dbHelper.database;

    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT 
        t.id, t.amount, t.note, t.type, t.timestamp,
        c.name AS category_name
      FROM transactions t
      INNER JOIN categories c ON t.category_id = c.id
      WHERE t.is_deleted = 0
      ORDER BY t.timestamp DESC
    ''');

    return maps.map((row) => LocalTransactionmodel.fromMap(row)).toList();
  }

  Future<List<Map<String, dynamic>>> getActiveCategories() async {
    final db = await dbHelper.database;
    developer.log('SQL: Fetching Active Categories...', name: 'SQLite');
    final result = await db.query('categories', where: 'is_deleted = 0');

    developer.log(
      'SQL: Retrieved ${result.length} active categories.',
      name: 'SQLite',
    );
    return result;
  }

  Future<void> insertCategory(String id, String name) async {
    final db = await dbHelper.database;

    final rowToInsert = {
      'id': id,
      'name': name,
      'is_synced': 0,
      'is_deleted': 0,
    };
    developer.log('SQL: Inserting Category -> $rowToInsert', name: 'SQLite');
    await db.insert('categories', {
      'id': id,
      'name': name,
      'is_synced': 0,
      'is_deleted': 0,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> insertTransaction(
    LocalTransactionmodel transaction,
    String categoryid,
  ) async {
    final db = await dbHelper.database;

    await db.insert('transactions', {
      'id': transaction.id,
      'amount': transaction.amount,
      'note': transaction.note,
      'type': transaction.type,
      'category_id': categoryid,
      'is_synced': 0,
      'is_deleted': 0,
      'timestamp': transaction.timestamp.toIso8601String(),
    });
  }

  Future<void> softDeleteTransaction(String id) async {
    final db = await dbHelper.database;
    
    await db.update(
      'transactions',
      {'is_deleted': 1, 'is_synced': 0}, 
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> softDeleteCategory(String id) async {
    final db = await dbHelper.database;
    final valuesToUpdate = {'is_deleted': 1, 'is_synced': 0};
    developer.log(
      'SQL: Soft Deleting Category ID -> $id with values: $valuesToUpdate',
      name: 'SQLite',
    );
    await db.update(
      'categories',
      {'is_deleted': 1, 'is_synced': 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
