import 'package:budget/firebase_auth/firebase_auth_excption_handler.dart';
import 'package:budget/page/account/account_create_page.dart';
import 'package:budget/repositorys/auth_repository.dart';
import 'package:budget/widgets/loading_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class forgotPasswordPage extends ConsumerWidget {
  forgotPasswordPage({super.key});
  String _email = "";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _email = ref.watch(emailProvider);
    return Scaffold(
      appBar: AppBar(title: const Text("パスワード再登録")),
      backgroundColor: Colors.grey,
      body: Center(
        child: Column(
          children: [
            _emailAndPasswordResetButtomWidget(context, ref),
          ],
        ),
      ),
    );
  }

  Widget _emailAndPasswordResetButtomWidget(
      BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.only(top: 100.h),
      child: Container(
        width: 350.w,
        height: 200.h,
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
        child: Column(
          children: [
            SizedBox(height: 50.h),
            _emailTextField(ref),
            _passwordResetButtom(context, ref)
          ],
        ),
      ),
    );
  }

  Widget _emailTextField(WidgetRef ref) {
    final emailController = ref.read(emailProvider.notifier);
    return Container(
      height: 50.h,
      width: 320.w,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(20.r),
        ),
      ),
      child: Center(
        child: Padding(
          padding: EdgeInsets.only(left: 20.w),
          child: TextField(
            style: TextStyle(fontSize: 15.sp),
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: "メールアドレス",
            ),
            onChanged: (mailAddress) {
              emailController.state = mailAddress;
            },
          ),
        ),
      ),
    );
  }

  Widget _passwordResetButtom(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.only(top: 30.h),
      child: Container(
        height: 50.h,
        width: 250.w,
        color: Colors.green,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            side: BorderSide(color: Colors.white, width: 3.w),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: Text("パスワード再設定メールを送る",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp)),
          onPressed: () async {
            await _passwordResetDialog(context, ref);
          },
        ),
      ),
    );
  }

  Future _passwordResetDialog(BuildContext context, WidgetRef ref) async {
    final authRepository = ref.watch(authRepositoryImplProvider);
    LoadingWidget.easyLoadingShow();
    try {
      await authRepository.sendPasswordResetEmail(email: _email);
      LoadingWidget.easyLoadingDismiss();
      await _dialogSuccess(context);
      if (context.mounted) {
        Navigator.of(context).pop();
      }
    } on FirebaseAuthException catch (e) {
      LoadingWidget.easyLoadingDismiss();
      final result = FirebaseAuthExceptionHandler.handleException(e);
      final errorMessage =
          FirebaseAuthExceptionHandler.exceptionMessage(result);
      await _dialogError(errorMessage, context);
    } catch (e) {
      LoadingWidget.easyLoadingDismiss();
      await _dialogError(e.toString(), context);
    }
  }

  Future _dialogSuccess(BuildContext context) async {
    await showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text('パスワード再設定メールを送りました。'),
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
}
