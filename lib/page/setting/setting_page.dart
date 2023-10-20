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

class SettingPage extends ConsumerWidget {
  const SettingPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
          title: const Text("設定", style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.green),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(10.r),
              child: Column(
                children: [
                  Container(
                    height: 70.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10.r),
                          topRight: Radius.circular(10.r)),
                    ),
                    alignment: Alignment.centerRight,
                    child: ListTile(
                      title: Text("カテゴリー", style: TextStyle(fontSize: 20.sp)),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const CategorySettingPage()));
                      },
                    ),
                  ),
                  Divider(
                    color: Colors.grey,
                    thickness: 2,
                    height: 1.h,
                    indent: 0,
                    endIndent: 0,
                  ),
                  Container(
                    height: 70.h,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    alignment: Alignment.centerRight,
                    child: ListTile(
                      title: Row(
                        children: [
                          Text("パズコードロック", style: TextStyle(fontSize: 20.sp)),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const PassCodeRockSetting()));
                      },
                    ),
                  ),
                  Divider(
                    color: Colors.grey,
                    thickness: 2,
                    height: 1.h,
                    indent: 0,
                    endIndent: 0,
                  ),
                  Container(
                    height: 70.h,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    alignment: Alignment.centerRight,
                    child: ListTile(
                      title: Text(
                        "通知",
                        style: TextStyle(fontSize: 20.sp),
                      ),
                      onTap: () async {
                        await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const NotificationSettingPage()));
                        final notification = ref
                            .watch(sharedPreferencesProvider)
                            .getBool("notification");
                        if (notification == true) {
                          final notificationTime =
                              ref.watch(notificationTimeProvider);
                          final time = Util.convartDateToTime(notificationTime);
                          NotificationService().scheduledNotification(
                              hour: time.hour, minutes: time.minute, id: 0);
                        }
                      },
                    ),
                  ),
                  Divider(
                    color: Colors.grey,
                    thickness: 2,
                    height: 1.h,
                    indent: 0,
                    endIndent: 0,
                  ),
                  Container(
                    height: 70.h,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    alignment: Alignment.centerRight,
                    child: ListTile(
                        title: Text(
                          "月の固定値•定期入力",
                          style: TextStyle(fontSize: 20.sp),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const FixedExpenseWithRecurringIncomePage()));
                        }),
                  ),
                  Divider(
                    color: Colors.grey,
                    thickness: 2,
                    height: 1.h,
                    indent: 0,
                    endIndent: 0,
                  ),
                  Container(
                    height: 70.h,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    alignment: Alignment.centerRight,
                    child: ListTile(
                      title: Text(
                        "収支をリセットする。",
                        style: TextStyle(color: Colors.red, fontSize: 20.sp),
                      ),
                      onTap: () async {
                        await _resetExpenseAndIncomeDialog(context, ref);
                      },
                    ),
                  ),
                  const Divider(
                    color: Colors.grey,
                    thickness: 2,
                    height: 1,
                    indent: 0,
                    endIndent: 0,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10.r),
                          bottomRight: Radius.circular(10.r)),
                    ),
                    alignment: Alignment.centerRight,
                    height: 70.h,
                    child: ListTile(
                      title: Text(
                        textAlign: TextAlign.start,
                        "アカウント",
                        style: TextStyle(fontSize: 20.sp),
                      ),
                      onTap: () async {
                        await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AccountPage()));
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future _resetExpenseAndIncomeDialog(
      BuildContext context, WidgetRef ref) async {
    await showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text('全ての収支を削除しますか?'),
          content: const Text(
            '削除した収支は復元できません。\n(カテゴリーは削除されません)',
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            TextButton(
                child: const Text('キョンセル'),
                onPressed: () async {
                  Navigator.of(context).pop();
                }),
            TextButton(
              child: const Text(
                '削除する',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () async {
                _lastConfirmation(context, ref);
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
          title: const Text('最終確認'),
          content: const Text(
            '全ての収支を削除して宜しいでしょうか?',
            textAlign: TextAlign.left,
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('キョンセル'),
              onPressed: () {
                Navigator.of(context).pop();
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
                    Navigator.of(context).pop();
                    await _successDiarog(context);
                  }
                } catch (e) {
                  if (context.mounted) {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  }
                  _errorDiarog(context, e.toString());
                }
              },
            )
          ],
        );
      },
    );
  }

  Future _successDiarog(BuildContext context) async {
    await showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text('削除しました。'),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'OK',
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  Future _errorDiarog(BuildContext context, String error) async {
    await showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text('エラーが発生しました。'),
          content: Text(error),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'OK',
              ),
              onPressed: () {
                if (context.mounted) {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                }
              },
            )
          ],
        );
      },
    );
  }
}
