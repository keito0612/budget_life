import 'package:budget/notifications/notification_service.dart';
import 'package:budget/provider/notification_provider.dart';
import 'package:budget/provider/notification_time_provider.dart';
import 'package:budget/provider/shared_preferences_provider.dart';
import 'package:budget/widgets/cupertino_switch_tile.dart';
import 'package:budget/widgets/cupertino_time_piker_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotificationSettingPage extends ConsumerWidget {
  const NotificationSettingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notification = ref.watch(notificationProvider);
    final notificationController = ref.read(notificationProvider.notifier);
    final notificationTime = ref.watch(notificationTimeProvider);
    final notificationTimeController = ref.read(notificationTimeProvider.notifier);
    final prefs = ref.watch(sharedPreferencesProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: _buildHeader(context),
          ),
          SliverToBoxAdapter(
            child: _buildContent(
              context,
              ref,
              notification,
              notificationController,
              notificationTime,
              notificationTimeController,
              prefs,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 60.h, 20.w, 24.h),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF00C853), Color(0xFF00E676)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32.r),
          bottomRight: Radius.circular(32.r),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00C853).withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20.sp),
            ),
          ),
          SizedBox(width: 16.w),
          Icon(Icons.notifications, color: Colors.white, size: 28.sp),
          SizedBox(width: 12.w),
          Text(
            '通知設定',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    bool notification,
    dynamic notificationController,
    String notificationTime,
    NotificationTimeNotifier notificationTimeController,
    dynamic prefs,
  ) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          SizedBox(height: 8.h),
          _buildSettingsCard(
            notification,
            notificationController,
            notificationTime,
            notificationTimeController,
            prefs,
          ),
          SizedBox(height: 24.h),
          _buildInfoCard(),
        ],
      ),
    );
  }

  Widget _buildSettingsCard(
    bool notification,
    dynamic notificationController,
    String notificationTime,
    NotificationTimeNotifier notificationTimeController,
    dynamic prefs,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFB300).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(
                    Icons.notifications_active,
                    color: const Color(0xFFFFB300),
                    size: 22.sp,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '通知',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF2D3748),
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        notification ? '通知がオンです' : '通知がオフです',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: const Color(0xFF718096),
                        ),
                      ),
                    ],
                  ),
                ),
                CupertinoSwitchTile(
                  title: "",
                  value: notification,
                  onChanged: (bool value) async {
                    notificationController.setNotification(value);
                    if (notification == false) {
                      prefs.remove("notification_time");
                      NotificationService().cancelAllNotification();
                    }
                  },
                ),
              ],
            ),
          ),
          if (notification) ...[
            Padding(
              padding: EdgeInsets.only(left: 64.w),
              child: const Divider(height: 1, color: Color(0xFFE2E8F0)),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(10.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFF5C6BC0).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Icon(
                      Icons.access_time,
                      color: const Color(0xFF5C6BC0),
                      size: 22.sp,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Text(
                      '通知時刻',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF2D3748),
                      ),
                    ),
                  ),
                  CupertinoTimePikerTile(
                    title: "",
                    time: notificationTime,
                    onDateTimeChanged: (DateTime dateTime) async {
                      NotificationService().cancelAllNotification();
                      notificationTimeController.setNotificationTime(dateTime);
                    },
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: const Color(0xFF00C853).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(
              Icons.info_outline,
              color: const Color(0xFF00C853),
              size: 22.sp,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'リマインダー',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2D3748),
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  '設定した時刻に入力を促す通知が届きます。毎日の記録を習慣化しましょう。',
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: const Color(0xFF718096),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
