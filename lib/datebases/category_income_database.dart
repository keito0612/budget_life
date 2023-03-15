import 'package:budget/datebases/datebase_helper.dart';
import 'package:budget/model/category.dart';
import 'package:sqflite/sqflite.dart';

class CategoryIncomeDatabase {
  final String _tableName = 'category_income';

  Future<List<Category>> getCategorys() async {
    final db = await DateBaseHelper.db.database;
    final res = await db.query(_tableName);
    if (res.isEmpty) return [];
    return res.map((res) => Category.fromJson(res)).toList();
  }

  Future<Category> insert(Category category) async {
    try {
      final db = await DateBaseHelper.db.database;
      final id = await db.insert(
        _tableName,
        category.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return category.copyWith(id: id);
    } on Exception catch (e) {
      throw Exception(e);
    }
  }

  Future update(Category category) async {
    try {
      final db = await DateBaseHelper.db.database;
      return await db.update(
        _tableName,
        category.toJson(),
        where: 'id = ?',
        whereArgs: [category.id],
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
