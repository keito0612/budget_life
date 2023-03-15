import 'dart:io';
import 'package:budget/model/category.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DateBaseHelper {
  DateBaseHelper._();
  static final DateBaseHelper db = DateBaseHelper._();

  static const _databaseName = "budget.db";
  static const _databaseVersion = 1;

  static const tableExpense = 'expense';
  static const tableIncome = 'income';
  static const tableCategoryExpense = 'category_expense';
  static const tableCategoryIncome = 'category_income';
  static const tableAccounts = 'accounts';
  static const tableUsers = 'users';

  static const columnId = 'id';
  static const columnAmount = 'amount';
  static const columnDate = 'date';
  static const columnMemo = 'memo';
  static const columnDestination = 'destination';
  static const columnSource = 'source';
  static const columnCategory = 'category';
  static const columnAccountId = 'account_id';
  static const columnUserId = 'user_id';
  static const columnName = 'name';
  static const columnType = 'type';
  static const columnBalance = 'balance';
  static const columnUsername = 'username';
  static const columnEmail = 'email';
  static const columnPassword = 'password';
  static const columnIcon = 'icon';
  static const columnColor = 'color';
  static Database? _database;
  final List<Category> initializeCategoryExpenses = [
    Category(
        category: "食費",
        icon: Icons.restaurant.codePoint,
        color: Colors.orange.value),
    Category(
        category: "趣味",
        icon: Icons.sports_esports.codePoint,
        color: Colors.blue.value),
    Category(
        category: "交際費",
        icon: Icons.favorite.codePoint,
        color: Colors.orange.value),
    Category(
        category: "生活用品",
        icon: Icons.content_cut_outlined.codePoint,
        color: Colors.brown.value),
    Category(
        category: "交通費", icon: Icons.tram.codePoint, color: Colors.red.value),
    Category(
        category: "電気代",
        icon: Icons.tungsten.codePoint,
        color: Colors.yellow.value),
    Category(
        category: "水道代",
        icon: Icons.water_drop.codePoint,
        color: Colors.blueAccent.value),
    Category(
        category: "ガス代",
        icon: Icons.local_fire_department.codePoint,
        color: Colors.red.value)
  ];
  final List<Category> initializeCategoryIncomes = [
    Category(
        category: "給料",
        icon: Icons.monetization_on.codePoint,
        color: Colors.yellow.value),
    Category(
        category: "お小遣い",
        icon: Icons.savings.codePoint,
        color: Colors.pink.value)
  ];

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    } else {
      _database = await initDB();
      return _database!;
    }
  }

  Future<Database> initDB() async {
    //データベースを作成
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    final Future<Database> _database = openDatabase(
      path,
      onCreate: (db, version) async {
        await db.execute(
            // テーブルの作成
            "CREATE TABLE $tableExpense ($columnId INTEGER PRIMARY KEY AUTOINCREMENT,$columnAmount TEXT , $columnDate TEXT,$columnMemo TEXT, $columnCategory  TEXT)");
        await db.execute(
            "CREATE TABLE $tableIncome ($columnId INTEGER PRIMARY KEY AUTOINCREMENT,$columnAmount TEXT , $columnDate TEXT,$columnMemo TEXT, $columnCategory  TEXT)");
        await db.execute(
            "CREATE TABLE $tableCategoryExpense ($columnId INTEGER PRIMARY KEY AUTOINCREMENT,$columnCategory TEXT , $columnIcon INTEGER,$columnColor INTEGER )");
        await db.execute(
            "CREATE TABLE $tableCategoryIncome ($columnId INTEGER PRIMARY KEY AUTOINCREMENT,$columnCategory TEXT , $columnIcon INTEGER,$columnColor INTEGER )");
        for (var category in initializeCategoryExpenses) {
          await db.insert(tableCategoryExpense, category.toJson());
        }
        for (var category in initializeCategoryIncomes) {
          await db.insert(tableCategoryIncome, category.toJson());
        }
      },
      version: _databaseVersion,
    );
    return _database;
  }
}
