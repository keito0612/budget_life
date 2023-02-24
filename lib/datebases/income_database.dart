import 'package:budget/datebases/datebase_helper.dart';
import 'package:budget/model/income.dart';
import 'package:sqflite/sqflite.dart';

class IncomeDatabase {
  final String _tableName = 'income';

  Future<List<Income>> getIncomes() async {
    final db = await DateBaseHelper.db.database;
    final res = await db.query(_tableName);
    if (res.isEmpty) return [];
    return res.map((res) => Income.fromJson(res)).toList();
  }

  Future<Income> insert(Income income) async {
    if (income.amount == "") {
      throw ("金額を設定してください");
    }
    try {
      final db = await DateBaseHelper.db.database;
      final id = await db.insert(
        _tableName,
        income.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return income.copyWith(id: id);
    } on Exception catch (e) {
      throw Exception(e);
    }
  }

  Future update(Income income) async {
    if (income.amount == "") {
      throw ("金額を設定してください");
    }
    try {
      final db = await DateBaseHelper.db.database;
      return await db.update(
        _tableName,
        income.toJson(),
        where: 'id = ?',
        whereArgs: [income.id],
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
