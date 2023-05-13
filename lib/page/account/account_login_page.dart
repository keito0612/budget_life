import 'package:budget/firebase_auth/firebase_auth_excption_handler.dart';
import 'package:budget/page/account/account_create_page.dart';
import 'package:budget/page/forgot_password/forgot_password_page.dart';
import 'package:budget/provider/firebase_provider.dart';
import 'package:budget/repositorys/accunt_repository.dart';
import 'package:budget/repositorys/auth_repository.dart';
import 'package:budget/widgets/loading_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AccountLoginPage extends ConsumerWidget {
  AccountLoginPage({super.key});
  String _email = "";
  String _password = "";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _password = ref.watch(passwordProvider);
    _email = ref.watch(emailProvider);
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(title: const Text("ログイン")),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [_mailAddressAndPasswordWidget(context, ref)],
          ),
        ),
      ),
    );
  }

  Widget _mailAddressAndPasswordWidget(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(top: 100),
      child: Container(
        width: 350,
        height: 350,
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
        child: Column(
          children: [
            const SizedBox(height: 50),
            _mailAddressTextField(ref),
            const SizedBox(height: 50),
            _passwordTextField(ref),
            _loginButton(context, ref),
            _fargotPasswordTextButton(context)
          ],
        ),
      ),
    );
  }

  Widget _mailAddressTextField(WidgetRef ref) {
    final emailController = ref.read(emailProvider.notifier);
    return Container(
      height: 50,
      width: 320,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: TextField(
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
      height: 50,
      width: 320,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: TextField(
            obscureText: isObscure,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "パスワード",
              suffixIcon: IconButton(
                icon: Icon(isObscure ? Icons.visibility_off : Icons.visibility),
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

  Widget _loginButton(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: Container(
        height: 50,
        width: 100,
        color: Colors.green,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            side: const BorderSide(color: Colors.white, width: 3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child:
              const Text("ログイン", style: TextStyle(fontWeight: FontWeight.bold)),
          onPressed: () async {
            await _loginDialog(context, ref);
          },
        ),
      ),
    );
  }

  Widget _fargotPasswordTextButton(BuildContext context) {
    return TextButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  fullscreenDialog: true,
                  builder: (context) => forgotPasswordPage()));
        },
        child: const Text(
          "パスワードがわからない場合",
          style: TextStyle(color: Colors.white),
        ));
  }

  Future _loginDialog(BuildContext context, WidgetRef ref) async {
    final authRepository = ref.watch(authRepositoryImplProvider);
    final user = ref.watch(authRepositoryImplProvider).currentUser;
    await LoadingWidget.easyLoadingShow();
    try {
      await authRepository.signIn(email: _email, password: _password);
      await LoadingWidget.easyLoadingDismiss();
      await AccountRepository().getDate(ref);
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
      print(e);
      LoadingWidget.easyLoadingDismiss();
      await _dialogError(e.toString(), context);
    }
  }

  Future _dialogSuccess(BuildContext context) async {
    await showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text('ログインしました。'),
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
