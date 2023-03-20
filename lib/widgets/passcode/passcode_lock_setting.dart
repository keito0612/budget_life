import 'package:budget/main.dart';
import 'package:budget/page/passcode_rock_setting.dart';
import 'package:budget/provider/local_auth_controller_provider.dart';
import 'package:budget/provider/shared_preferences_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';

final passcodePassWordProvider = StateProvider((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return prefs.getString("passcode_password");
});

class PasscodeLockScreen extends ConsumerWidget {
  const PasscodeLockScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lockController = ref.read(lockProvider.notifier);
    final passcodePassword = ref.watch(passcodePassWordProvider);
    final auch = ref.read(authControllerProvider);
    final faceId = ref.watch(faceProvider);
    return ScreenLock(
      onUnlocked: () {
        lockController.unlock();
      },
      onOpened: () async {
        if (faceId == true) {
          final didAuthenticate = await auch.didAuthenticate();
          if (didAuthenticate) {
            lockController.unlock();
          }
        }
      },
      correctString: passcodePassword!,
      title: const Text("パスワードを入力してください"),
      config: const ScreenLockConfig(
        textStyle: TextStyle(color: Colors.white),
        backgroundColor: Colors.green,
      ),
      secretsConfig: SecretsConfig(
        spacing: 15,
        padding: const EdgeInsets.all(40),
        secretConfig: SecretConfig(
          borderColor: Colors.white,
          borderSize: 2.0,
          disabledColor: Colors.green,
          enabledColor: Colors.white,
          size: 15,
          builder: (context, config, enabled) => Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: enabled ? config.enabledColor : config.disabledColor,
              border: Border.all(
                width: config.borderSize,
                color: config.borderColor,
              ),
            ),
            padding: const EdgeInsets.all(10),
            width: config.size,
            height: config.size,
          ),
        ),
      ),
      keyPadConfig: KeyPadConfig(
        buttonConfig: KeyPadButtonConfig(
          foregroundColor: Colors.black,
          buttonStyle: OutlinedButton.styleFrom(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            backgroundColor: Colors.white,
          ),
        ),
        displayStrings: ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'],
      ),
      cancelButton: null,
      deleteButton: const Icon(Icons.delete, color: Colors.white),
    );
  }
}
