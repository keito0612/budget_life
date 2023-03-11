import 'package:budget/page/category_setting_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingPage extends ConsumerWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(title: const Text("設定"), backgroundColor: Colors.green),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 8,
                    left: 8,
                  ),
                  child:
                      const Text("設定", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Ink(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10)),
                    ),
                    child: ListTile(
                      title: Text("カテゴリー"),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => categorySettingPage()));
                      },
                    ),
                  ),
                  const Divider(
                    color: Colors.grey,
                    thickness: 2,
                    height: 1,
                    indent: 0,
                    endIndent: 0,
                  ),
                  Ink(
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: ListTile(
                      title: Text("カテゴリー"),
                      onTap: () {},
                    ),
                  ),
                  const Divider(
                    color: Colors.grey,
                    thickness: 2,
                    height: 1,
                    indent: 0,
                    endIndent: 0,
                  ),
                  Ink(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10)),
                    ),
                    child: ListTile(
                      title: Text("カテゴリー"),
                      onTap: () {},
                    ),
                  ),
                  Divider(
                    color: Colors.grey,
                    thickness: 2,
                    height: 1,
                    indent: 0,
                    endIndent: 0,
                  ),
                  ListTile(title: Text("パスワードロック"))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
