import 'package:budget/notifications/notification_service.dart';
import 'package:budget/page/home/home_page.dart';
import 'package:budget/page/input/input_page.dart';
import 'package:budget/page/list/list_page.dart';
import 'package:budget/page/setting/setting_page.dart';
import 'package:budget/provider/shared_preferences_provider.dart';
import 'package:budget/widgets/passcode/passcode_lock_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  await Future<void>.sync(
      NotificationService().initializePlatformNotifications);
  runApp(ProviderScope(overrides: [
    // sharedPreferencesインスタンス生成
    sharedPreferencesProvider
        .overrideWithValue(await SharedPreferences.getInstance()),
  ], child: const MyApp()));
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
    List<Widget> pageList = [
      const HomePage(),
      const InputPage(),
      const ListPage(),
      const SettingPage()
    ];

    return MaterialApp(
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
        home: lock == true
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
                    items: _tabItems)));
  }
}
