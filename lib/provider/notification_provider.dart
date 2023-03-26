import 'package:budget/provider/shared_preferences_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final initializationNotificationProvider = StateProvider.autoDispose((ref) {
  return false;
});

final notificationProvider =
    StateNotifierProvider.autoDispose<NotificationNotifier, bool>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return NotificationNotifier(prefs);
});

final timeProvider = StateProvider((ref) {
  final toTime = DateTime.now();
  return toTime;
});

class NotificationNotifier extends StateNotifier<bool> {
  NotificationNotifier(
    this._prefs,
  ) : super(false) {
    getNotification();
  }

  final SharedPreferences _prefs;

  void setNotification(bool isOn) {
    state = isOn;
    _prefs.setBool("notification", state);
  }

  void getNotification() {
    state = _prefs.getBool("notification") ?? false;
  }
}
