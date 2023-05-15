import 'package:budget/page/account/account_create_page.dart';
import 'package:budget/page/account/account_login_page.dart';
import 'package:budget/provider/firebase_provider.dart';
import 'package:budget/repositorys/accunt_repository.dart';
import 'package:budget/repositorys/auth_repository.dart';
import 'package:budget/widgets/loading_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountPage extends ConsumerWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userStateProvider);
    return Scaffold(
        backgroundColor: Colors.grey,
        appBar: AppBar(title: const Text("アカウント")),
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
        _userEmailWidget(user),
        Container(
          width: double.infinity,
          height: 491,
          color: Colors.green,
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
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Icon(
              Icons.cloud_rounded,
              color: Colors.white,
              size: 100,
            ),
            const Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text(
                "データをバックアップ",
                style: TextStyle(fontSize: 30, color: Colors.white),
              ),
            ),
            const SizedBox(height: 50),
            Container(
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
              width: 300,
              height: 250,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 50, bottom: 50),
                    child: SizedBox(
                      width: 200,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AccountCreatePage()));
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          side: const BorderSide(
                            color: Colors.white, //色
                            width: 3, //太さ
                          ),
                        ),
                        child: const Text(
                          "アカウント作成",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 200,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AccountLoginPage()));
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        side: const BorderSide(
                          color: Colors.white,
                          width: 3,
                        ),
                      ),
                      child: const Text(
                        "ログイン",
                        style: TextStyle(fontWeight: FontWeight.bold),
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
        padding: const EdgeInsets.only(top: 50),
        child: SizedBox(
          width: 300,
          height: 50,
          child: ElevatedButton(
            onPressed: () async {
              _syncDialog(context, ref);
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              side: const BorderSide(
                color: Colors.white, //色
                width: 3, //太さ
              ),
            ),
            child: const Text(
              "データを同期する",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ));
  }

  Widget _signOutButton(WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 30,
      ),
      child: SizedBox(
        width: 300,
        height: 50,
        child: ElevatedButton(
          onPressed: () async {
            await ref.watch(authRepositoryImplProvider).signOut();
          },
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            side: const BorderSide(
              color: Colors.white, //色
              width: 3, //太さ
            ),
          ),
          child: const Text(
            "サインアウト",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _unsubscribeButton(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 30,
      ),
      child: SizedBox(
        width: 300,
        height: 50,
        child: ElevatedButton(
          onPressed: () async {
            await _unsubscribeDialog(context, ref);
          },
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            side: const BorderSide(
              color: Colors.white, //色
              width: 3, //太さ
            ),
          ),
          child: const Text(
            "退会",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  //追加ダイアログ
  Future _syncDialog(BuildContext context, WidgetRef ref) async {
    try {
      await LoadingWidget.easyDataSyncLoadingShow();
      await AccountRepository().dateSync(ref);
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
      },
    );
  }

  Widget _userEmailWidget(User user) {
    return Container(
        width: double.infinity,
        height: 250,
        color: Colors.white,
        child: Center(
          child: Text(
            "メールアドレス：${user.email}",
            style: const TextStyle(
                color: Colors.green, fontWeight: FontWeight.bold, fontSize: 18),
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
