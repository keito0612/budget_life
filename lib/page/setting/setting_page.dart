import 'package:budget/page/account/account_page.dart';
import 'package:budget/notifications/notification_service.dart';
import 'package:budget/page/category/category_setting_page.dart';
import 'package:budget/page/fixed_expense_with_recurring_income/fixed_expense_with_recurring_income.page.dart';
import 'package:budget/page/notification/notification_setting_page.dart';
import 'package:budget/page/passcode/passcode_rock_setting.dart';
import 'package:budget/provider/notification_time_provider.dart';
import 'package:budget/provider/shared_preferences_provider.dart';
import 'package:budget/utils/util.dart';
import 'package:budget/viewModels/expense_model.dart';
import 'package:budget/viewModels/income_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingPage extends ConsumerWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: CustomScrollView(
        slivers: [
          // カスタムAppBar
          SliverToBoxAdapter(
            child: _buildHeader(context),
          ),
          // 設定リスト
          SliverToBoxAdapter(
            child: _buildSettingsList(context, ref),
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
          Icon(Icons.settings, color: Colors.white, size: 28.sp),
          SizedBox(width: 12.w),
          Text(
            '設定',
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

  Widget _buildSettingsList(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 8.h),
          _buildSectionTitle('一般'),
          _buildSettingsCard([
            _buildSettingItem(
              icon: Icons.category,
              iconColor: const Color(0xFF5C6BC0),
              title: 'カテゴリー',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CategorySettingPage()),
                );
              },
            ),
            _buildDivider(),
            _buildSettingItem(
              icon: Icons.repeat,
              iconColor: const Color(0xFFFF7043),
              title: '月の固定費・定期入力',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const FixedExpenseWithRecurringIncomePage()),
                );
              },
            ),
          ]),
          SizedBox(height: 24.h),
          _buildSectionTitle('セキュリティ'),
          _buildSettingsCard([
            _buildSettingItem(
              icon: Icons.lock_outline,
              iconColor: const Color(0xFF7E57C2),
              title: 'パスコードロック',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PassCodeRockSetting()),
                );
              },
            ),
          ]),
          SizedBox(height: 24.h),
          _buildSectionTitle('通知'),
          _buildSettingsCard([
            _buildSettingItem(
              icon: Icons.notifications_outlined,
              iconColor: const Color(0xFFFFB300),
              title: '通知設定',
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const NotificationSettingPage()),
                );
                final notification = ref
                    .watch(sharedPreferencesProvider)
                    .getBool("notification");
                if (notification == true) {
                  final notificationTime = ref.watch(notificationTimeProvider);
                  final time = Util.convartDateToTime(notificationTime);
                  NotificationService().scheduledNotification(
                    hour: time.hour,
                    minutes: time.minute,
                    id: 0,
                  );
                }
              },
            ),
          ]),
          SizedBox(height: 24.h),
          _buildSectionTitle('アカウント'),
          _buildSettingsCard([
            _buildSettingItem(
              icon: Icons.person_outline,
              iconColor: const Color(0xFF42A5F5),
              title: 'アカウント',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AccountPage()),
                );
              },
            ),
          ]),
          SizedBox(height: 24.h),
          _buildSectionTitle('サポート'),
          _buildSettingsCard([
            _buildSettingItem(
              icon: Icons.mail_outline,
              iconColor: const Color(0xFF00C853),
              title: 'お問い合わせ',
              onTap: () {
                final url = Uri.parse(
                    'https://docs.google.com/forms/d/e/1FAIpQLSdU47nag_nNwO929APfxUZQKrUGCX7SCyCitICaKwXG4nLBoA/viewform');
                launchUrl(url);
              },
            ),
          ]),
          SizedBox(height: 24.h),
          _buildSectionTitle('データ'),
          _buildSettingsCard([
            _buildSettingItem(
              icon: Icons.delete_outline,
              iconColor: const Color(0xFFFF5252),
              title: '収支をリセットする',
              titleColor: const Color(0xFFFF5252),
              onTap: () async {
                await _resetExpenseAndIncomeDialog(context, ref);
              },
            ),
          ]),
          SizedBox(height: 32.h),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(left: 4.w, bottom: 8.h),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF718096),
        ),
      ),
    );
  }

  Widget _buildSettingsCard(List<Widget> children) {
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
      child: Column(children: children),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    Color? titleColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(icon, color: iconColor, size: 22.sp),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: titleColor ?? const Color(0xFF2D3748),
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: const Color(0xFFA0AEC0),
                size: 24.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: EdgeInsets.only(left: 64.w),
      child: Divider(
        height: 1,
        color: const Color(0xFFE2E8F0),
      ),
    );
  }

  Future _resetExpenseAndIncomeDialog(
      BuildContext context, WidgetRef ref) async {
    await showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.warning_amber_rounded,
                  color: const Color(0xFFFFB300), size: 24.sp),
              SizedBox(width: 8.w),
              const Text('確認'),
            ],
          ),
          content: Padding(
            padding: EdgeInsets.only(top: 12.h),
            child: const Text(
              '全ての収支を削除しますか？\n削除したデータは復元できません。\n（カテゴリーは削除されません）',
              textAlign: TextAlign.center,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('キャンセル'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                '削除する',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                await _lastConfirmation(context, ref);
              },
            )
          ],
        );
      },
    );
  }

  Future _lastConfirmation(BuildContext context, WidgetRef ref) async {
    await showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline,
                  color: const Color(0xFFFF5252), size: 24.sp),
              SizedBox(width: 8.w),
              const Text('最終確認'),
            ],
          ),
          content: Padding(
            padding: EdgeInsets.only(top: 12.h),
            child: const Text(
              '本当に全ての収支を削除しますか？\nこの操作は取り消せません。',
              textAlign: TextAlign.center,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('キャンセル'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                '削除する',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () async {
                try {
                  await ref
                      .read(expenseViewModelProvider.notifier)
                      .expenseAllDelete();
                  await ref
                      .read(incomeViewModelProvider.notifier)
                      .incomeAllDelete();
                  if (context.mounted) {
                    Navigator.of(context).pop();
                    await _successDialog(context);
                  }
                } catch (e) {
                  if (context.mounted) {
                    Navigator.of(context).pop();
                    await _errorDialog(context, e.toString());
                  }
                }
              },
            )
          ],
        );
      },
    );
  }

  Future _successDialog(BuildContext context) async {
    await showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle,
                  color: const Color(0xFF00C853), size: 24.sp),
              SizedBox(width: 8.w),
              const Text('完了'),
            ],
          ),
          content: Padding(
            padding: EdgeInsets.only(top: 12.h),
            child: const Text('全ての収支を削除しました。'),
          ),
          actions: <Widget>[
            TextButton(
              child:
                  const Text('OK', style: TextStyle(color: Color(0xFF00C853))),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  Future _errorDialog(BuildContext context, String error) async {
    await showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, color: Colors.red, size: 24.sp),
              SizedBox(width: 8.w),
              const Text('エラー'),
            ],
          ),
          content: Padding(
            padding: EdgeInsets.only(top: 12.h),
            child: Text(error),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }
}
