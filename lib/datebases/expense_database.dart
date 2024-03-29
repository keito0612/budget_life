import 'package:budget/datebases/datebase_helper.dart';
import 'package:budget/model/expense/expense.dart';
import 'package:sqflite/sqflite.dart';

class ExpenseDatabase {
  final String _tableName = 'expense';

  Future<List<Expense>> getExpenses() async {
    final db = await DateBaseHelper.db.database;
    final res = await db.query(_tableName);
    if (res.isEmpty) return [];
    return res.map((res) => Expense.fromJson(res)).toList();
  }

  Future<Expense> insert(Expense expense) async {
    if (expense.amount == "") {
      throw ("金額を設定してください");
    }
    try {
      final db = await DateBaseHelper.db.database;
      final id = await db.insert(
        _tableName,
        expense.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return expense.copyWith(id: id);
    } on Exception catch (e) {
      throw Exception(e);
    }
  }

  Future update(Expense expense) async {
    if (expense.amount.isEmpty) {
      throw ('金額が設定されていません');
    }
    try {
      final db = await DateBaseHelper.db.database;
      return await db.update(
        _tableName,
        expense.toJson(),
        where: 'id = ?',
        whereArgs: [expense.id],
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } on Exception catch (e) {
      throw Exception(e);
    }
  }

  Future rawDalete() async {
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
