import 'package:background_fetch/background_fetch.dart';

class BackgroundTaskManager {
  static void initBackgroundFech(Function(String taskId) onFetch) {
    BackgroundFetch.configure(
        BackgroundFetchConfig(
          minimumFetchInterval: 15,
          stopOnTerminate: false,
          enableHeadless: true,
          requiresBatteryNotLow: false,
          requiresCharging: false,
          requiresStorageNotLow: false,
          requiresDeviceIdle: false,
          startOnBoot: true,
        ),
        onFetch);
  }

  static void backgroundFechStart({
    required Function(int status) fetch,
    required Future<dynamic> Function(Object, StackTrace) catchError,
  }) {
    BackgroundFetch.start().then(fetch).catchError(catchError);
  }
}
