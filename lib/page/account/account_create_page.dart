import 'package:budget/firebase_auth/firebase_auth_excption_handler.dart';
import 'package:budget/repositorys/auth_repository.dart';
import 'package:budget/widgets/loading_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

final isObscureProvider = StateProvider.autoDispose((ref) => false);
final passwordProvider = StateProvider.autoDispose((ref) => "");
final emailProvider = StateProvider.autoDispose((ref) => "");

class AccountCreatePage extends ConsumerWidget {
  AccountCreatePage({super.key});

  String _email = "";
  String _password = "";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _password = ref.watch(passwordProvider);
    _email = ref.watch(emailProvider);
    final user = ref.watch(authRepositoryImplProvider)..currentUser;
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        backgroundColor: Colors.green,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("アカウント作成", style: TextStyle(color: Colors.white)),
      ),
      body: Center(
        child: Column(
          children: [_mailAddressAndPasswordWidget(context, ref)],
        ),
      ),
    );
  }

  Widget _mailAddressAndPasswordWidget(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.only(top: 100.h),
      child: Container(
        width: 350.w,
        height: 300.h,
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
            _mailAddressTextField(ref),
            SizedBox(height: 50.h),
            _passwordTextField(ref),
            _createButton(context, ref)
          ],
        ),
      ),
    );
  }

  Widget _mailAddressTextField(WidgetRef ref) {
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

  Widget _passwordTextField(WidgetRef ref) {
    final isObscure = ref.watch(isObscureProvider);
    final isObscureController = ref.read(isObscureProvider.notifier);
    final passwordController = ref.read(passwordProvider.notifier);

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
          padding: EdgeInsets.only(
            left: 20.w,
          ),
          child: TextField(
            style: TextStyle(fontSize: 15.sp),
            obscureText: isObscure,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "パスワード",
              suffixIcon: IconButton(
                padding: EdgeInsets.only(right: 20.w),
                icon: Icon(isObscure ? Icons.visibility_off : Icons.visibility,
                    size: 25.sp),
                onPressed: () {
                  isObscureController.state = !isObscureController.state;
                },
              ),
            ),
            onChanged: (password) {
              passwordController.state = password;
            },
          ),
        ),
      ),
    );
  }

  Widget _createButton(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.only(top: 30.h),
      child: Container(
        height: 50.h,
        width: 100.w,
        color: Colors.green,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            side: BorderSide(color: Colors.white, width: 3.w),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.r),
            ),
          ),
          child: Text("作成",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp)),
          onPressed: () async {
            await _createDialog(context, ref);
          },
        ),
      ),
    );
  }

  Future _createDialog(BuildContext context, WidgetRef ref) async {
    final authRepository = ref.watch(authRepositoryImplProvider);
    await LoadingWidget.easyLoadingShow();
    try {
      await authRepository.signUp(email: _email, password: _password);
      await LoadingWidget.easyLoadingDismiss();
      await _dialogSuccess(context);
      if (context.mounted) {
        Navigator.of(context).pop();
      }
    } on FirebaseAuthException catch (e) {
      await LoadingWidget.easyLoadingDismiss();
      final result = FirebaseAuthExceptionHandler.handleException(e);
      final errorMessage =
          FirebaseAuthExceptionHandler.exceptionMessage(result);
      await _dialogError(errorMessage, context);
    } catch (e) {
      await LoadingWidget.easyLoadingDismiss();
      await _dialogError(e.toString(), context);
    }
  }

  Future _dialogSuccess(BuildContext context) async {
    await showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text('作成しました。'),
          content: const Text(''),
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

  Future _dialogError(String error, BuildContext context) async {
    await showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const  Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children:  [
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
