import 'package:budget/datebases/datebase_helper.dart';
import 'package:budget/model/recurring_income/recurring_income.dart';
import 'package:sqflite/sqflite.dart';

class RecurringIncomeDatabase {
  final String _tableName = 'recurring_income';

  Future<List<RecurringIncome>> getRecurringIncomes() async {
    final db = await DateBaseHelper.db.database;
    final res = await db.query(_tableName);
    if (res.isEmpty) return [];
    return res.map((res) => RecurringIncome.fromJson(res)).toList();
  }

  Future<RecurringIncome> insert(RecurringIncome recurringIncome) async {
    if (recurringIncome.amount == "") {
      throw ("金額を設定してください");
    }
    try {
      final db = await DateBaseHelper.db.database;
      final id = await db.insert(
        _tableName,
        recurringIncome.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return recurringIncome.copyWith(id: id);
    } on Exception catch (e) {
      throw Exception(e);
    }
  }

  Future update(RecurringIncome recurringIncome) async {
    if (recurringIncome.amount.isEmpty) {
      throw ('金額が設定されていません');
    }
    try {
      final db = await DateBaseHelper.db.database;
      return await db.update(
        _tableName,
        recurringIncome.toJson(),
        where: 'id = ?',
        whereArgs: [recurringIncome.id],
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
