import 'package:budget/notifications/notification_service.dart';
import 'package:budget/page/category/category_setting_page.dart';
import 'package:budget/page/notification/notification_setting_page.dart';
import 'package:budget/page/passcode/passcode_rock_setting.dart';
import 'package:budget/provider/notification_time_provider.dart';
import 'package:budget/provider/shared_preferences_provider.dart';
import 'package:budget/utils/util.dart';
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
              children: const [
                Padding(
                  padding: EdgeInsets.only(
                    top: 8,
                    left: 8,
                  ),
                  child: Text("設定", style: TextStyle(color: Colors.white)),
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
                      title: const Text("カテゴリー"),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const CategorySettingPage()));
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
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    child: ListTile(
                      title: Row(
                        children: const [
                          Text("パズコードロック"),
                          SizedBox(
                            width: 180,
                          ),
                          Expanded(child: Icon(size: 30, Icons.arrow_right))
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const PassCodeRockSetting()));
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
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10)),
                    ),
                    child: ListTile(
                      title: const Text("通知"),
                      onTap: () async {
                        await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const NotificationSettingPage()));
                        final notification = ref
                            .watch(sharedPreferencesProvider)
                            .getBool("notification");
                        if (notification == true) {
                          final notificationTime =
                              ref.watch(notificationTimeProvider);
                          final time = Util.convartDateToTime(notificationTime);
                          NotificationService().scheduledNotification(
                              hour: time.hour, minutes: time.minute, id: 0);
                        }
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
                  const ListTile(title: Text("パスワードロック"))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
