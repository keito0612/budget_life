import 'dart:async';

import 'package:budget/page/input_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'page/expense_page.dart';

final selectedPageProvider = StateProvider.autoDispose((ref) => 0);

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  MyApp({super.key});

  final List<BottomNavigationBarItem> _tabItems = const [
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: 'ホーム',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.person),
      label: 'ユーザー',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.favorite),
      label: 'お気に入り',
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
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
            body: InputPage(),
            bottomNavigationBar: BottomNavigationBar(
                unselectedLabelStyle:
                    const TextStyle(color: Colors.white, fontSize: 14),
                fixedColor: Colors.green,
                currentIndex: selectedIndex,
                onTap: (index) {
                  selectedIndexController.state = index;
                },
                items: _tabItems)));
  }
}
