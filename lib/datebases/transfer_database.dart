import 'package:budget/datebases/datebase_helper.dart';
import 'package:budget/model/transfer/transfer.dart';
import 'package:sqflite/sqflite.dart';

class TransferDatabase {
  final String _tableName = 'transfer';

  Future<List<Transfer>> getTransfers() async {
    final db = await DateBaseHelper.db.database;
    final res = await db.query(_tableName, orderBy: 'date DESC');
    if (res.isEmpty) return [];
    return res.map((res) => Transfer.fromJson(res)).toList();
  }

  Future<List<Transfer>> getTransfersToSavingsWallets(List<int> savingsWalletIds) async {
    if (savingsWalletIds.isEmpty) return [];
    final db = await DateBaseHelper.db.database;
    final placeholders = savingsWalletIds.map((_) => '?').join(',');
    final res = await db.query(
      _tableName,
      where: 'toWalletId IN ($placeholders)',
      whereArgs: savingsWalletIds,
      orderBy: 'date DESC',
    );
    if (res.isEmpty) return [];
    return res.map((res) => Transfer.fromJson(res)).toList();
  }

  Future<Transfer> insert(Transfer transfer) async {
    if (transfer.amount.isEmpty) {
      throw ("金額を設定してください");
    }
    try {
      final db = await DateBaseHelper.db.database;
      final id = await db.insert(
        _tableName,
        transfer.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return transfer.copyWith(id: id);
    } on Exception catch (e) {
      throw Exception(e);
    }
  }

  Future update(Transfer transfer) async {
    if (transfer.amount.isEmpty) {
      throw ('金額が設定されていません');
    }
    try {
      final db = await DateBaseHelper.db.database;
      return await db.update(
        _tableName,
        transfer.toJson(),
        where: 'id = ?',
        whereArgs: [transfer.id],
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } on Exception catch (e) {
      throw Exception(e);
    }
  }

  Future rawDelete() async {
    await DateBaseHelper.rawDelete(tableName: _tableName);
  }

  Future delete(int id) async {
    final db = await DateBaseHelper.db.database;
    return await db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
