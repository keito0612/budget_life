import 'package:budget/page/account/account_create_page.dart';
import 'package:budget/page/account/account_login_page.dart';
import 'package:budget/provider/firebase_provider.dart';
import 'package:budget/provider/reward_ad._provider.dart';
import 'package:budget/repositorys/accunt_repository.dart';
import 'package:budget/repositorys/auth_repository.dart';
import 'package:budget/widgets/loading_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AccountPage extends ConsumerWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userStateProvider);
    return Scaffold(
        backgroundColor: Colors.grey,
        appBar: AppBar(
          backgroundColor: Colors.green,
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text("アカウント", style: TextStyle(color: Colors.white)),
        ),
        body: userState.when(
          data: (user) {
            if (user != null) {
              return _loggedInScreen(context, ref, user);
            } else {
              return _sinInScreen(context);
            }
          },
          error: (error, stackTrace) => Center(child: Text("$errorが出ています。")),
          loading: () => const CircularProgressIndicator(
            color: Colors.green,
            backgroundColor: Colors.white,
          ),
        ));
  }

  Widget _loggedInScreen(BuildContext context, WidgetRef ref, User user) {
    return Center(
        child: Column(
      children: [
        _userEmailWidget(user, context),
        Container(
          width: double.infinity,
          child: Column(
            children: [
              _dateSyncButton(context, ref),
              _signOutButton(ref),
              _unsubscribeButton(context, ref)
            ],
          ),
        )
      ],
    ));
  }

  Widget _sinInScreen(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.0.r),
        child: Column(
          children: [
            Icon(
              Icons.cloud_rounded,
              color: Colors.white,
              size: 100.sp,
            ),
            Padding(
              padding: EdgeInsets.only(top: 10.h),
              child: Text(
                "データをバックアップ",
                style: TextStyle(fontSize: 30.sp, color: Colors.white),
              ),
            ),
            SizedBox(height: 50.h),
            Container(
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.all(Radius.circular(50.r)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black38,
                    offset: Offset(2.0.r, 2.0.r),
                    blurRadius: 4.0.r,
                    spreadRadius: 4.0.r,
                  ),
                ],
              ),
              width: 300.w,
              height: 250.h,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 50.h, bottom: 50.h),
                    child: SizedBox(
                      width: 250.w,
                      height: 50.h,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AccountCreatePage()));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          side: BorderSide(
                            color: Colors.white, //色
                            width: 3.w, //太さ
                          ),
                        ),
                        child: Text(
                          "アカウント作成",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20.sp),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 250.w,
                    height: 50.h,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AccountLoginPage()));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        side: BorderSide(
                          color: Colors.white,
                          width: 3.w,
                        ),
                      ),
                      child: Text(
                        "ログイン",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.sp),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dateSyncButton(BuildContext context, WidgetRef ref) {
    return Padding(
        padding: EdgeInsets.only(top: 50.h),
        child: SizedBox(
          width: 300.w,
          height: 50.h,
          child: ElevatedButton(
            onPressed: () async {
              _syncDialog(context, ref);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
              side: BorderSide(
                color: Colors.white, //色
                width: 3.w, //太さ
              ),
            ),
            child: Text(
              "データを同期する",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.sp),
            ),
          ),
        ));
  }

  Widget _signOutButton(WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.only(
        top: 30.h,
      ),
      child: SizedBox(
        width: 300.w,
        height: 50.h,
        child: ElevatedButton(
          onPressed: () async {
            await ref.watch(authRepositoryImplProvider).signOut();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r),
            ),
            side: BorderSide(
              color: Colors.white, //色
              width: 3.w, //太さ
            ),
          ),
          child: Text(
            "サインアウト",
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20.sp),
          ),
        ),
      ),
    );
  }

  Widget _unsubscribeButton(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.only(
        top: 30.h,
      ),
      child: SizedBox(
        width: 300.w,
        height: 50.h,
        child: ElevatedButton(
          onPressed: () async {
            await _unsubscribeDialog(context, ref);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r),
            ),
            side: BorderSide(
              color: Colors.white, //色
              width: 3.w, //太さ
            ),
          ),
          child: Text(
            "退会",
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20.sp),
          ),
        ),
      ),
    );
  }

  //追加ダイアログ
  Future _syncDialog(BuildContext context, WidgetRef ref) async {
    final rewardNotifier = ref.watch(rewardAdProvider.notifier)..loadRewardAd();
    final isLoaded = ref.read(rewardAdProvider).isLoaded;
    try {
      await LoadingWidget.easyDataSyncLoadingShow();
      if (!isLoaded) {
        await AccountRepository().dateSync(ref);
      } else {
        await rewardNotifier.showRewardAd(() async {
          await AccountRepository().dateSync(ref);
        });
      }
      await LoadingWidget.easyLoadingDismiss();
      await _dialogResult(context);
    } on Exception catch (e) {
      print(e);
      await LoadingWidget.easyLoadingDismiss();
      await _dialogError(e.toString(), context);
    } catch (e) {
      await LoadingWidget.easyLoadingDismiss();
      await _dialogError(e.toString(), context);
    }
  }

  //成功した時のダイアログー
  Future _dialogResult(BuildContext context) async {
    await showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text('データを同期しました。'),
          content: const Text(''),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () async {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  //エラーダイアログ
  Future _dialogError(String error, BuildContext context) async {
    await showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: const [
                Icon(
                  Icons.error_outline_rounded,
                  color: Colors.red,
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("エラーが発生しました"),
                )
              ],
            ),
            content: Column(
              children: [
                Text(error),
              ],
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
        });
  }

  Widget _userEmailWidget(User user, BuildContext context) {
    return Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height / 3,
        color: Colors.white,
        child: Center(
          child: Text(
            "メールアドレス：${user.email}",
            style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: 20.sp),
          ),
        ));
  }

  Future _unsubscribeDialog(BuildContext context, WidgetRef ref) async {
    await showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text('退会しますか?'),
          content: const Text(
            '退会するとあなたのアカウントはクラウドから削除され、使用できなくなります。',
            textAlign: TextAlign.left,
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('キョンセル'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('退会する', style: TextStyle(color: Colors.red)),
              onPressed: () async {
                await LoadingWidget.easyDataSyncLoadingShow();
                await AccountRepository.dateAllDelete(ref);
                await ref.watch(authRepositoryImplProvider).deleteUser();
                await LoadingWidget.easyLoadingDismiss();
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }
}
