import 'package:budget/datebases/datebase_helper.dart';
import 'package:budget/model/fixed_expense/fixed_expense.dart';
import 'package:sqflite/sqflite.dart';

class FixedExpenseDatabase {
  final String _tableName = 'fixed_expense';

  Future<List<FixedExpense>> getFixedExpenses() async {
    final db = await DateBaseHelper.db.database;
    final res = await db.query(_tableName);
    if (res.isEmpty) return [];
    return res.map((res) => FixedExpense.fromJson(res)).toList();
  }

  Future<FixedExpense> insert(FixedExpense fixedExpense) async {
    if (fixedExpense.amount == "") {
      throw ("金額を設定してください");
    }
    try {
      final db = await DateBaseHelper.db.database;
      final id = await db.insert(
        _tableName,
        fixedExpense.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return fixedExpense.copyWith(id: id);
    } on Exception catch (e) {
      throw Exception(e);
    }
  }

  Future update(FixedExpense fixedExpense) async {
    if (fixedExpense.amount.isEmpty) {
      throw ('金額が設定されていません');
    }
    try {
      final db = await DateBaseHelper.db.database;
      return await db.update(
        _tableName,
        fixedExpense.toJson(),
        where: 'id = ?',
        whereArgs: [fixedExpense.id],
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } on Exception catch (e) {
      throw Exception(e);
    }
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
