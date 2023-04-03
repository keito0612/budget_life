import 'package:budget/notifications/notification_service.dart';
import 'package:budget/provider/notification_provider.dart';
import 'package:budget/provider/notification_time_provider.dart';
import 'package:budget/provider/shared_preferences_provider.dart';
import 'package:budget/widgets/cupertino_switch_tile.dart';
import 'package:budget/widgets/cupertino_time_piker_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationSettingPage extends ConsumerWidget {
  const NotificationSettingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notification = ref.watch(notificationProvider);
    final notificationController = ref.read(notificationProvider.notifier);
    final notificationTime = ref.watch(notificationTimeProvider);
    final notificationTimeController =
        ref.read(notificationTimeProvider.notifier);
    final prefs = ref.watch(sharedPreferencesProvider);

    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(title: const Text("通知設定")),
      body: Center(
        child: Container(
          width: 380,
          height: 280,
          decoration: const BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.all(Radius.circular(50)),
            boxShadow: [
              BoxShadow(
                color: Colors.black38,
                offset: Offset(2.0, 2.0),
                blurRadius: 4.0,
                spreadRadius: 4.0,
              ),
            ],
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black38,
                        offset: Offset(2.0, 2.0),
                        blurRadius: 4.0,
                        spreadRadius: 4.0,
                      ),
                    ],
                  ),
                  child: CupertinoSwitchTile(
                      title: "通知",
                      value: notification,
                      onChanged: (bool value) async {
                        notificationController.setNotification(value);
                        if (notification == false) {
                          prefs.remove("notification_time");
                          NotificationService().cancelAllNotification();
                        }
                      }),
                ),
              ),
              notification == true
                  ? Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black38,
                              offset: Offset(2.0, 2.0),
                              blurRadius: 4.0,
                              spreadRadius: 4.0,
                            ),
                          ],
                        ),
                        child: CupertinoTimePikerTile(
                            title: "時刻",
                            time: notificationTime,
                            onDateTimeChanged: (DateTime dateTime) async {
                              NotificationService().cancelAllNotification();
                              notificationTimeController
                                  .setNotificationTime(dateTime);
                            }),
                      ),
                    )
                  : const SizedBox()
            ],
          ),
        ),
      ),
    );
  }
}
