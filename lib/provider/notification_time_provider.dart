import 'package:budget/provider/shared_preferences_provider.dart';
import 'package:budget/utils/util.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final notificationTimeProvider =
    StateNotifierProvider.autoDispose<NotificationTimeNotifier, String>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return NotificationTimeNotifier(prefs);
});

class NotificationTimeNotifier extends StateNotifier<String> {
  NotificationTimeNotifier(
    this._prefs,
  ) : super(Util.toTime(DateTime.now())) {
    getNotificationTime();
  }

  final SharedPreferences _prefs;

  void setNotificationTime(DateTime dateTime) {
    final time = Util.toTime(dateTime);
    state = time;
    _prefs.setString("notification_time", time);
  }

  void getNotificationTime() {
    final toTime = Util.toTime(DateTime.now());
    final time = _prefs.getString("notification_time") ?? toTime;
    state = time;
  }
}
