import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DateBaseHelper {
  DateBaseHelper._();
  static final DateBaseHelper db = DateBaseHelper._();

  static const _databaseName = "budget.db";
  static const _databaseVersion = 1;

  static const tableExpenses = 'expense';
  static const tableIncomes = 'incomes';
  static const tableCategories = 'categories';
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

  static Database? _database;

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
            "CREATE TABLE $tableExpenses ($columnId INTEGER PRIMARY KEY AUTOINCREMENT,$columnAmount TEXT , $columnDate TEXT,$columnMemo TEXT, $columnCategory  TEXT)");
        await db.execute(
            "CREATE TABLE event (id INTEGER PRIMARY KEY AUTOINCREMENT , notificationId INTEGER , titleText TEXT , timeText TEXT, memoText TEXT, isOn INTEGER, notificationTime TEXT)");
      },
      version: _databaseVersion,
    );
    return _database;
  }
}
