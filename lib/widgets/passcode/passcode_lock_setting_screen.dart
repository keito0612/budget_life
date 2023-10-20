import 'package:budget/page/passcode/passcode_rock_setting.dart';
import 'package:budget/provider/shared_preferences_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PasscodeLockSettingScreen {
  static void passcodeLockSettingScreen(BuildContext context, WidgetRef ref) {
    final passcodeController = ref.read(passcodeProvider.notifier);
    final inputController = InputController();
    final prefs = ref.watch(sharedPreferencesProvider);
    screenLockCreate(
      inputController: inputController,
      context: context,
      title: const Text('パスコードを設定してください'),
      confirmTitle: const Text('もう一度入力してください'),
      onConfirmed: (value) {
        value = value.replaceAll(",", "");
        prefs.setString("passcode_password", value);
        if (!context.mounted) return;
        Navigator.of(context).pop();
      },
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
      cancelButton: Icon(size: 20.0.sp, Icons.close, color: Colors.white),
      deleteButton: Icon(size: 20.0.sp, Icons.delete, color: Colors.white),
      onCancelled: () async {
        passcodeController.setPasscode(false);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.remove("passcode_password");
        Navigator.pop(context);
      },
    );
  }
}
