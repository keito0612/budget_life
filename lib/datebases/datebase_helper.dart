import 'dart:io';
import 'package:budget/model/category/category.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DateBaseHelper {
  DateBaseHelper._();
  static final DateBaseHelper db = DateBaseHelper._();
  static const _databaseName = "budget.db";
  static const _databaseVersion = 5;
  static const columnSavingsAmount = 'savingsAmount';
  static const columnWalletCashAmount = 'walletCashAmount';
  static const columnIsSavings = 'isSavings';
  static const tableExpense = 'expense';
  static const tableIncome = 'income';
  static const tableRecurringIncome = 'recurring_income';
  static const tableFixedExpense = 'fixed_expense';
  static const tableCategoryExpense = 'category_expense';
  static const tableCategoryIncome = 'category_income';
  static const tableAccounts = 'accounts';
  static const tableUsers = 'users';
  static const tableWallet = 'wallet';
  static const tableTransfer = 'transfer';
  static const columnId = 'id';
  static const columnAmount = 'amount';
  static const columnAutoMaticInputDate = "autoMaticInputDate";
  static const columnAutoMaticInputDay = "autoMaticInputDay";
  static const columnAutoMaticInputDateIndex = "autoMaticInuputDateIndex";
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
  static const columnCategoryIndex = 'categoryIndex';
  static const columnWalletId = 'walletId';
  static const columnIsDefault = 'isDefault';
  static const columnSortOrder = 'sortOrder';
  static const columnFromWalletId = 'fromWalletId';
  static const columnToWalletId = 'toWalletId';
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

  static Future rawDelete({String? tableName}) async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    final datebase = await openDatabase(path);
    await datebase.rawDelete('DELETE FROM $tableName');
  }

  Future<Database> initDB() async {
    //データベースを作成
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    final Future<Database> database = openDatabase(
      path,
      onCreate: (db, version) async {
        await db.execute(
            // テーブルの作成
            "CREATE TABLE $tableExpense ($columnId INTEGER PRIMARY KEY AUTOINCREMENT,$columnAmount TEXT , $columnDate TEXT,$columnMemo TEXT, $columnCategory  TEXT, $columnIcon INTEGER , $columnColor INTEGER , $columnCategoryIndex  INTEGER, $columnWalletId INTEGER DEFAULT 1  )");
        await db.execute(
            "CREATE TABLE $tableIncome ($columnId INTEGER PRIMARY KEY AUTOINCREMENT,$columnAmount TEXT , $columnDate TEXT,$columnMemo TEXT, $columnCategory  TEXT, $columnIcon INTEGER, $columnColor INTEGER , $columnCategoryIndex INTEGER, $columnWalletId INTEGER DEFAULT 1, $columnSavingsAmount TEXT DEFAULT '', $columnWalletCashAmount TEXT DEFAULT ''  )");
        await db.execute(
            "CREATE TABLE $tableCategoryExpense ($columnId INTEGER PRIMARY KEY AUTOINCREMENT,$columnCategory TEXT , $columnIcon INTEGER,$columnColor INTEGER )");
        await db.execute(
            "CREATE TABLE $tableCategoryIncome ($columnId INTEGER PRIMARY KEY AUTOINCREMENT,$columnCategory TEXT , $columnIcon INTEGER,$columnColor INTEGER )");
        await db.execute(
            "CREATE TABLE $tableFixedExpense ($columnId INTEGER PRIMARY KEY AUTOINCREMENT,$columnAmount TEXT , $columnAutoMaticInputDate TEXT,$columnAutoMaticInputDay INTEGER , $columnAutoMaticInputDateIndex INTEGER ,  $columnMemo TEXT, $columnCategory  TEXT, $columnIcon INTEGER , $columnColor INTEGER , $columnCategoryIndex  INTEGER, $columnWalletId INTEGER DEFAULT 1  )");
        await db.execute(
            "CREATE TABLE $tableRecurringIncome  ($columnId INTEGER PRIMARY KEY AUTOINCREMENT,$columnAmount TEXT , $columnAutoMaticInputDate TEXT,$columnAutoMaticInputDay INTEGER , $columnAutoMaticInputDateIndex INTEGER , $columnMemo TEXT, $columnCategory  TEXT, $columnIcon INTEGER , $columnColor INTEGER , $columnCategoryIndex  INTEGER, $columnWalletId INTEGER DEFAULT 1  )");
        await db.execute(
            "CREATE TABLE $tableWallet ($columnId INTEGER PRIMARY KEY AUTOINCREMENT, $columnName TEXT, $columnIcon INTEGER, $columnColor INTEGER, $columnBalance INTEGER DEFAULT 0, $columnIsDefault INTEGER DEFAULT 0, $columnSortOrder INTEGER DEFAULT 0, $columnIsSavings INTEGER DEFAULT 0)");
        await db.execute(
            "CREATE TABLE $tableTransfer ($columnId INTEGER PRIMARY KEY AUTOINCREMENT, $columnFromWalletId INTEGER, $columnToWalletId INTEGER, $columnAmount TEXT, $columnDate TEXT, $columnMemo TEXT)");
        for (var category in initializeCategoryExpenses) {
          await db.insert(tableCategoryExpense, category.toJson());
        }
        for (var category in initializeCategoryIncomes) {
          await db.insert(tableCategoryIncome, category.toJson());
        }
        // 初期ウォレットを作成
        await _insertInitialWallets(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          // ウォレットテーブルを作成
          await db.execute(
              "CREATE TABLE $tableWallet ($columnId INTEGER PRIMARY KEY AUTOINCREMENT, $columnName TEXT, $columnIcon INTEGER, $columnColor INTEGER, $columnBalance INTEGER DEFAULT 0, $columnIsDefault INTEGER DEFAULT 0, $columnSortOrder INTEGER DEFAULT 0)");
          // 既存テーブルにwalletIdカラムを追加
          await db.execute("ALTER TABLE $tableExpense ADD COLUMN $columnWalletId INTEGER DEFAULT 1");
          await db.execute("ALTER TABLE $tableIncome ADD COLUMN $columnWalletId INTEGER DEFAULT 1");
          await db.execute("ALTER TABLE $tableFixedExpense ADD COLUMN $columnWalletId INTEGER DEFAULT 1");
          await db.execute("ALTER TABLE $tableRecurringIncome ADD COLUMN $columnWalletId INTEGER DEFAULT 1");
          // 初期ウォレットを作成
          await _insertInitialWallets(db);
        }
        if (oldVersion < 3) {
          // 振替テーブルを作成
          await db.execute(
              "CREATE TABLE $tableTransfer ($columnId INTEGER PRIMARY KEY AUTOINCREMENT, $columnFromWalletId INTEGER, $columnToWalletId INTEGER, $columnAmount TEXT, $columnDate TEXT, $columnMemo TEXT)");
        }
        if (oldVersion < 4) {
          // ウォレットテーブルにisSavingsカラムを追加
          await db.execute("ALTER TABLE $tableWallet ADD COLUMN $columnIsSavings INTEGER DEFAULT 0");
        }
        if (oldVersion < 5) {
          // 収入テーブルに貯金額と財布入金額カラムを追加
          await db.execute("ALTER TABLE $tableIncome ADD COLUMN $columnSavingsAmount TEXT DEFAULT ''");
          await db.execute("ALTER TABLE $tableIncome ADD COLUMN $columnWalletCashAmount TEXT DEFAULT ''");
        }
      },
      version: _databaseVersion,
    );
    return database;
  }

  Future<void> _insertInitialWallets(Database db) async {
    await db.insert(tableWallet, {
      columnName: '財布',
      columnIcon: Icons.account_balance_wallet.codePoint,
      columnColor: Colors.green.toARGB32(),
      columnBalance: 0,
      columnIsDefault: 1,
      columnSortOrder: 0,
    });
    await db.insert(tableWallet, {
      columnName: '銀行',
      columnIcon: Icons.account_balance.codePoint,
      columnColor: Colors.blue.toARGB32(),
      columnBalance: 0,
      columnIsDefault: 0,
      columnSortOrder: 1,
    });
  }
}
