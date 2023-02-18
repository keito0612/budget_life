import 'dart:async';

import 'package:budget/page/input_page.dart';
import 'package:budget/page/list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectedPageProvider = StateProvider.autoDispose((ref) => 0);

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  MyApp({super.key});

  final List<BottomNavigationBarItem> _tabItems = const [
    BottomNavigationBarItem(
      icon: Icon(Icons.edit_note_outlined),
      label: '入力',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.list),
      label: 'リスト',
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
    List<Widget> pageList = [InputPage(), const ListPage()];
    return MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
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
