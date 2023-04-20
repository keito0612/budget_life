import 'dart:async';
import 'package:background_fetch/background_fetch.dart';
import 'package:budget/background/background_task_manager.dart';
import 'package:budget/datebases/category_expense_database.dart';
import 'package:budget/datebases/category_income_database.dart';
import 'package:budget/datebases/datebase_helper.dart';
import 'package:budget/firebase_options.dart';
import 'package:budget/model/fixed_expense/fixed_expense.dart';
import 'package:budget/model/recurring_income/recurring_income.dart';
import 'package:budget/notifications/notification_service.dart';
import 'package:budget/page/home/home_page.dart';
import 'package:budget/page/input/input_page.dart';
import 'package:budget/page/list/list_page.dart';
import 'package:budget/page/setting/setting_page.dart';
import 'package:budget/provider/shared_preferences_provider.dart';
import 'package:budget/repositorys/category_expense_repository.dart';
import 'package:budget/repositorys/category_income_repository.dart';
import 'package:budget/utils/util.dart';
import 'package:budget/viewModels/category_expense_model.dart';
import 'package:budget/viewModels/category_income_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'widgets/passcode/passcode_lock_Screen.dart';

final selectedPageProvider = StateProvider.autoDispose((ref) => 0);

class LockNotifier extends StateNotifier<bool> {
  LockNotifier() : super(false) {
    initialLock();
  }

  Future initialLock() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    state = prefs.getBool("passcode") ?? false;
  }

  void unlock() => state = false;
}

final lockProvider =
    StateNotifierProvider<LockNotifier, bool>((ref) => LockNotifier());

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future _automaticInputExpense() async {
  final db = await DateBaseHelper.db.database;
  String tableName = 'fixed_expense';
  final res = await db.query(tableName);
  if (res.isEmpty) return [];
  final fixedExpenses = res.map((res) => FixedExpense.fromJson(res)).toList();
  List<dynamic> mutableFixedExpneses = fixedExpenses.cast<dynamic>();
  final now = DateTime.now();
  if (fixedExpenses.isNotEmpty) {
    for (final fixedExpense in mutableFixedExpneses) {
      final day = fixedExpense.autoMaticInputDay;
      if (day == now.day) {
        final date = DateTime(now.year, now.month, day);
        Map<String, dynamic> expense = {
          'amount': fixedExpense.amount,
          'date': Util.toDate(date),
          'memo': fixedExpense.memo,
          'category': fixedExpense.category,
          'icon': fixedExpense.icon,
          'color': fixedExpense.color,
          'categoryIndex': fixedExpense.categoryIndex
        };
        await db.insert('expense', expense);
      }
    }
  }
}

Future _automaticInputIncome() async {
  final db = await DateBaseHelper.db.database;
  const String tableName = 'recurring_income';
  final res = await db.query(tableName);
  if (res.isEmpty) return [];
  final recurringIncomes =
      List.from(res.map((res) => RecurringIncome.fromJson(res)));
  List<dynamic> mutableRecurringIncomes = recurringIncomes.cast<dynamic>();
  final now = DateTime.now();
  if (recurringIncomes.isNotEmpty) {
    for (final recurringIncomes in mutableRecurringIncomes) {
      final day = recurringIncomes.autoMaticInputDay;
      if (day == now.day) {
        final date = DateTime(now.year, now.month, day);
        final income = {
          'amount': recurringIncomes.amount,
          'date': Util.toDate(date),
          'memo': recurringIncomes.memo,
          'category': recurringIncomes.category,
          'icon': recurringIncomes.icon,
          'color': recurringIncomes.color,
          'categoryIndex': recurringIncomes.categoryIndex
        };
        await db.insert('income', income);
      }
    }
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final categoryExoenseModel = CategoryExpenseModel(
      CategoryExpenseRepository(CategoryExpenseDatabase()));
  final categoryIncomeModel =
      CategoryIncomeModel(CategoryIncomeRepository(CategoryIncomeDatabase()));
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  BackgroundTaskManager.initBackgroundFech((String taskId) async {
    print('[BackgroundFetch] received task: $taskId');
    BackgroundFetch.finish(taskId);
  });
  BackgroundTaskManager.backgroundFechStart(
    fetch: (int status) async {
      print('[BackgroundFetch] start success: $status');
      Timer.periodic(
        const Duration(hours: 10),
        (Timer timer) async {
          await _automaticInputExpense();
          await _automaticInputIncome();
        },
      );
    },
    catchError: (error, p1) async {
      print(error);
    },
  );

  await Future<void>.sync(
      NotificationService().initializePlatformNotifications);
  runApp(ProviderScope(
      overrides: [
        // sharedPreferencesインスタンス生成
        sharedPreferencesProvider
            .overrideWithValue(await SharedPreferences.getInstance()),
        categoryExpenseModelProvider
            .overrideWith((ref) => categoryExoenseModel),
        categoryIncomeModelProvider.overrideWith((ref) => categoryIncomeModel)
      ],
      child: MaterialApp(
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('ja'),
          ],
          theme: ThemeData(
            primarySwatch: Colors.green,
          ),
          home: const MyApp())));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  final List<BottomNavigationBarItem> _tabItems = const [
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: 'ホーム',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.edit_note_outlined),
      label: '入力',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.list),
      label: 'リスト',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.settings),
      label: '設定',
    ),
  ];

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(selectedPageProvider);
    final selectedIndexController = ref.read(selectedPageProvider.notifier);
    final lock = ref.watch(lockProvider);
    final List<Widget> pageList = [
      const HomePage(),
      const InputPage(),
      const ListPage(),
      const SettingPage()
    ];

    return lock == true
        ? const PasscodeLockScreen()
        : Scaffold(
            body: pageList[selectedIndex],
            bottomNavigationBar: BottomNavigationBar(
                unselectedLabelStyle:
                    const TextStyle(color: Colors.black, fontSize: 14),
                unselectedItemColor: Colors.black45,
                selectedItemColor: Colors.green,
                currentIndex: selectedIndex,
                onTap: (index) {
                  selectedIndexController.state = index;
                },
                items: _tabItems));
  }
}
