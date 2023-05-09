import 'package:background_fetch/background_fetch.dart';

class BackgroundTaskManager {
  static Future initBackgroundFech({Function(String taskId)? onFetch}) async {
    await BackgroundFetch.configure(
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
      onFetch!,
    );
  }

  static Future backgroundFechStart({
    required Function(int status) fetch,
    required Future<dynamic> Function(Object, StackTrace) catchError,
  }) async {
    await BackgroundFetch.start().then(fetch).catchError(catchError);
  }
}
