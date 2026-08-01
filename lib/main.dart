import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:background_fetch/background_fetch.dart';
import 'package:budget/background/background_task_manager.dart';
import 'package:budget/datebases/category_expense_database.dart';
import 'package:budget/datebases/category_income_database.dart';
import 'package:budget/datebases/datebase_helper.dart';
import 'package:budget/datebases/fixed_expense_database.dart';
import 'package:budget/datebases/recurring_income_database.dart';
import 'package:budget/firebase_options.dart';
import 'package:budget/model/fixed_expense/fixed_expense.dart';
import 'package:budget/model/recurring_income/recurring_income.dart';
import 'package:budget/notifications/notification_service.dart';
import 'package:budget/page/chart%20/chart_page.dart';
import 'package:budget/page/home/home_page.dart';
import 'package:budget/page/input/input_page.dart';
import 'package:budget/page/list/list_page.dart';
import 'package:budget/page/setting/setting_page.dart';
import 'package:budget/provider/ad_banner_provider.dart';
import 'package:budget/provider/expense_chart_provider.dart';
import 'package:budget/provider/reward_ad._provider.dart';
import 'package:budget/provider/shared_preferences_provider.dart';
import 'package:budget/repositorys/category_expense_repository.dart';
import 'package:budget/repositorys/category_income_repository.dart';
import 'package:budget/repositorys/fixed_expense_repository.dart';
import 'package:budget/utils/util.dart';
import 'package:budget/viewModels/category_expense_model.dart';
import 'package:budget/viewModels/category_income_model.dart';
import 'package:budget/viewModels/fixed_expense_model.dart';
import 'package:budget/viewModels/recurringI_income_model.dart';
import 'package:budget/widgets/loading_widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'repositorys/recurring_income_repository.dart';
import 'widgets/passcode/passcode_lock_Screen.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';

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

/// 固定支出の自動入力（重複チェック付き）
Future _automaticInputExpense(SharedPreferences prefs) async {
  final db = await DateBaseHelper.db.database;
  const String tableName = 'fixed_expense';
  final res = await db.query(tableName);
  if (res.isEmpty) return;

  final fixedExpenses = res.map((res) => FixedExpense.fromJson(res)).toList();
  final now = DateTime.now();

  for (final fixedExpense in fixedExpenses) {
    final day = fixedExpense.autoMaticInputDay;

    // この固定支出が今月既に処理されたかチェック
    final processedKey = 'fixed_expense_${fixedExpense.id}_${now.year}_${now.month}';
    final alreadyProcessed = prefs.getBool(processedKey) ?? false;

    if (alreadyProcessed) continue;

    // 今日がその日か、または今月のその日が既に過ぎているかチェック
    if (day <= now.day) {
      final date = DateTime(now.year, now.month, day);
      Map<String, dynamic> expense = {
        'amount': fixedExpense.amount,
        'date': Util.toDate(date),
        'memo': fixedExpense.memo,
        'category': fixedExpense.category,
        'icon': fixedExpense.icon,
        'color': fixedExpense.color,
        'categoryIndex': fixedExpense.categoryIndex,
        'walletId': fixedExpense.walletId ?? 0,
      };
      await db.insert('expense', expense);
      // 処理済みとしてマーク
      await prefs.setBool(processedKey, true);
    }
  }
}

/// 定期収入の自動入力（重複チェック付き）
Future _automaticInputIncome(SharedPreferences prefs) async {
  final db = await DateBaseHelper.db.database;
  const String tableName = 'recurring_income';
  final res = await db.query(tableName);
  if (res.isEmpty) return;

  final recurringIncomes = res.map((res) => RecurringIncome.fromJson(res)).toList();
  final now = DateTime.now();

  for (final recurringIncome in recurringIncomes) {
    final day = recurringIncome.autoMaticInputDay;

    // この定期収入が今月既に処理されたかチェック
    final processedKey = 'recurring_income_${recurringIncome.id}_${now.year}_${now.month}';
    final alreadyProcessed = prefs.getBool(processedKey) ?? false;

    if (alreadyProcessed) continue;

    // 今日がその日か、または今月のその日が既に過ぎているかチェック
    if (day <= now.day) {
      final date = DateTime(now.year, now.month, day);
      final income = {
        'amount': recurringIncome.amount,
        'date': Util.toDate(date),
        'memo': recurringIncome.memo,
        'category': recurringIncome.category,
        'icon': recurringIncome.icon,
        'color': recurringIncome.color,
        'categoryIndex': recurringIncome.categoryIndex,
        'walletId': recurringIncome.walletId ?? 1,
      };
      await db.insert('income', income);
      // 処理済みとしてマーク
      await prefs.setBool(processedKey, true);
    }
  }
}

Future<void> initPlugin() async {
  final status = await AppTrackingTransparency.trackingAuthorizationStatus;
  if (status == TrackingStatus.notDetermined) {
    await Future.delayed(const Duration(milliseconds: 200));
    await AppTrackingTransparency.requestTrackingAuthorization();
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  LoadingWidget.configLoading();
  await dotenv.load(fileName: ".env");
  await MobileAds.instance.initialize();
  WidgetsBinding.instance.addPostFrameCallback((_) => initPlugin());
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final categoryExoenseModel = CategoryExpenseModel(
      CategoryExpenseRepository(CategoryExpenseDatabase()));
  final categoryIncomeModel =
      CategoryIncomeModel(CategoryIncomeRepository(CategoryIncomeDatabase()));
  final fixedExpenseModel =
      FixedExpenseModel(FixedExpenseRepository(FixedExpenseDatabase()));
  final recurringIncomeViewModel = RecurringIncomeModel(
      RecurringIncomeRepository(RecurringIncomeDatabase()));
  final rewardAdNotifier = RewardAdNotifier();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  // SharedPreferencesのインスタンスを取得
  final prefs = await SharedPreferences.getInstance();

  // アプリ起動時に自動入力を実行
  await _automaticInputExpense(prefs);
  await _automaticInputIncome(prefs);

  await BackgroundTaskManager.initBackgroundFech(
      onFetch: (String taskId) async {
    // バックグラウンドでも自動入力を実行
    final bgPrefs = await SharedPreferences.getInstance();
    await _automaticInputExpense(bgPrefs);
    await _automaticInputIncome(bgPrefs);
    BackgroundFetch.finish(taskId);
  });
  await BackgroundTaskManager.backgroundFechStart(
    fetch: (int status) async {
      // バックグラウンドフェッチ開始成功
    },
    catchError: (error, p1) async {
      // エラー時は何もしない
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
        categoryIncomeModelProvider.overrideWith((ref) => categoryIncomeModel),
        fixedExpenseViewModelProvider.overrideWith((ref) => fixedExpenseModel),
        recurringIncomeViewModelProvider
            .overrideWith((ref) => recurringIncomeViewModel),
        rewardAdProvider.overrideWith((ref) => rewardAdNotifier),
        expenseChartProvider
            .overrideWith((ref) => ExpenseChartProviderNotifier(ref))
      ],
      child: ScreenUtilInit(
        designSize: const Size(390, 844),
        minTextAdapt: true,
        splitScreenMode: true,
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
                colorScheme: const ColorScheme(
                    brightness: Brightness.light,
                    primary: Colors.green,
                    onPrimary: Colors.green,
                    secondary: Colors.grey,
                    error: Colors.red,
                    onError: Colors.black,
                    background: Colors.white,
                    onBackground: Colors.white,
                    surface: Colors.white,
                    onSecondary: Colors.black,
                    onSurface: Colors.black),
                primaryIconTheme: const IconThemeData(color: Colors.white)),
            builder: EasyLoading.init(),
            debugShowCheckedModeBanner: false,
            home: const MyApp()),
      )));
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
      label: '履歴',
    ),
    BottomNavigationBarItem(
      icon: Icon(
        Icons.pie_chart,
      ),
      label: '分析',
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
    final adBanner =
        ref.watch(adBannerProvider.select((value) => value.bannerAd));
    final isLoaded =
        ref.watch(adBannerProvider.select((value) => value.isLoaded));
    final lock = ref.watch(lockProvider);
    final List<Widget> pageList = [
      const HomePage(),
      const InputPage(),
      const ListPage(),
      const ChartPage(),
      const SettingPage()
    ];

    return lock == true
        ? const PasscodeLockScreen()
        : Scaffold(
            body: pageList[selectedIndex],
            bottomNavigationBar: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  isLoaded != false
                      ? SizedBox(height: 80.h, child: AdWidget(ad: adBanner!))
                      : loadingAdBannerWidget(),
                  BottomNavigationBar(
                      iconSize: 35.sp,
                      selectedLabelStyle: TextStyle(fontSize: 14.sp),
                      unselectedLabelStyle:
                          TextStyle(color: Colors.black, fontSize: 14.sp),
                      unselectedItemColor: Colors.black45,
                      selectedItemColor: Colors.green,
                      currentIndex: selectedIndex,
                      onTap: (index) {
                        selectedIndexController.state = index;
                      },
                      items: _tabItems)
                ]));
  }

  Widget loadingAdBannerWidget() {
    return SizedBox(
        width: 100.w,
        height: 80.h,
        child: const SizedBox(
          height: 50,
          width: 50,
          child: Center(
            child: CircularProgressIndicator(
              color: Colors.green,
            ),
          ),
        ));
  }
}
