import 'package:budget/provider/shared_preferences_provider.dart';
import 'package:budget/widgets/cupertino_switch_tile.dart';
import 'package:budget/widgets/passcode/passcode_lock_setting_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final passcodeProvider =
    StateNotifierProvider.autoDispose<PasscodeNotifier, bool>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return PasscodeNotifier(prefs);
});
final faceProvider =
    StateNotifierProvider.autoDispose<FaceIdNotifier, bool>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return FaceIdNotifier(prefs);
});

class PasscodeNotifier extends StateNotifier<bool> {
  PasscodeNotifier(
    this._prefs,
  ) : super(false) {
    getPasscode();
  }

  final SharedPreferences _prefs;

  void setPasscode(bool isOn) {
    state = isOn;
    _prefs.setBool("passcode", state);
  }

  void getPasscode() {
    state = _prefs.getBool("passcode") ?? false;
  }
}

class FaceIdNotifier extends StateNotifier<bool> {
  FaceIdNotifier(this._prefs) : super(false) {
    getFaceId();
  }

  final SharedPreferences _prefs;

  void setFaceId(bool isOn) {
    state = isOn;
    _prefs.setBool("faceId", state);
  }

  void getFaceId() {
    state = _prefs.getBool("faceId") ?? false;
  }
}

class PassCodeRockSetting extends ConsumerWidget {
  const PassCodeRockSetting({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final passcode = ref.watch(passcodeProvider);
    final passcodeController = ref.read(passcodeProvider.notifier);
    final faceId = ref.watch(faceProvider);
    final faceIdController = ref.read(faceProvider.notifier);
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(title: const Text("パスコードロック")),
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
                      title: "パスコードロック",
                      value: passcode,
                      onChanged: (bool value) {
                        passcodeController.setPasscode(value);
                        if (value == true) {
                          PasscodeLockSettingScreen.passcodeLockSettingScreen(
                              context, ref);
                        }
                      }),
                ),
              ),
              passcode == true
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
                        child: CupertinoSwitchTile(
                            title: "顔認証",
                            value: passcode == true ? faceId : false,
                            onChanged: (bool value) {
                              faceIdController.setFaceId(value);
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
