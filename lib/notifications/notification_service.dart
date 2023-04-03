import 'package:budget/main.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart';

class NotificationService {
  NotificationService();
  final _localNotifications = FlutterLocalNotificationsPlugin();

  Future<void> initializePlatformNotifications() async {
    await _configureLocalTimeZone();
    const IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
            requestSoundPermission: true,
            requestBadgePermission: true,
            requestAlertPermission: true,
            onDidReceiveLocalNotification: null);
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: null,
      iOS: initializationSettingsIOS,
    );
    await _localNotifications.initialize(
      initializationSettings,
    );
  }

  Future<void> _configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  }

  Future<void> cancelAllNotification() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  tz.TZDateTime _convertTime(int hour, int minutes) {
    final detroit = getLocation("Asia/Tokyo");
    final tz.TZDateTime now = tz.TZDateTime.now(detroit);
    tz.TZDateTime scheduleDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minutes,
    );
    if (scheduleDate.isBefore(now)) {
      scheduleDate = scheduleDate.add(const Duration(days: 1));
    }
    return scheduleDate;
  }

  scheduledNotification({
    required int hour,
    required int minutes,
    required int id,
  }) async {
    await _localNotifications.zonedSchedule(
        id,
        "家計簿アプリLife",
        'お金は大切に使いましょう。今日の支出はもう記録しましたか？',
        _convertTime(hour, minutes),
        const NotificationDetails(
          android: null,
          iOS: IOSNotificationDetails(),
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time);
  }
}
