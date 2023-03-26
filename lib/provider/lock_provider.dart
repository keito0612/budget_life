import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final lockProvider =
    StateNotifierProvider<LockNotifier, bool>((ref) => LockNotifier());

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
