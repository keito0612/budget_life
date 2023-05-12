import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class LoadingWidget {
  static void configLoading() {
    EasyLoading.instance
      ..indicatorType = EasyLoadingIndicatorType.fadingCircle
      ..loadingStyle = EasyLoadingStyle.custom
      ..indicatorSize = 45.0
      ..radius = 10.0
      ..progressColor = Colors.green
      ..backgroundColor = Colors.white
      ..indicatorColor = Colors.green
      ..textColor = Colors.green
      ..maskColor = Colors.blue.withOpacity(0.5)
      ..userInteractions = true
      ..dismissOnTap = false;
  }

  static Future<void> easyLoadingShow() async {
    await EasyLoading.show(status: '読み込み中です。');
  }

  static Future<void> easyLoadingDismiss() async {
    await EasyLoading.dismiss();
  }

  static Future<void> easyDataSyncLoadingShow() async {
    await EasyLoading.show(status: '同期中です。');
  }
}
