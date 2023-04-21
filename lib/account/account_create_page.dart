import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final isObscureProvider = StateProvider.autoDispose((ref) => false);
final passwordProvider = StateProvider.autoDispose((ref) => "");
final mailAddressProvider = StateProvider.autoDispose((ref) => "");

class AccountCreatePage extends ConsumerWidget {
  AccountCreatePage({super.key});

  String _mailAddress = "";
  String _password = "";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _password = ref.watch(passwordProvider);
    _mailAddress = ref.watch(mailAddressProvider);
    return Scaffold(
      backgroundColor: Colors.green,
      appBar: AppBar(title: const Text("アカウント作成")),
      body: Center(
        child: Column(
          children: [_mailAddressAndPasswordWidget(ref)],
        ),
      ),
    );
  }

  Widget _mailAddressAndPasswordWidget(ref) {
    return Padding(
      padding: const EdgeInsets.only(top: 100),
      child: Container(
        width: 350,
        height: 300,
        decoration: BoxDecoration(
            color: Colors.green,
            border: Border.all(width: 5, color: Colors.white),
            borderRadius: BorderRadius.circular(20)),
        child: Column(
          children: [
            const SizedBox(height: 50),
            _mailAddressTextField(ref),
            const SizedBox(height: 50),
            _passwordTextField(ref),
            _createButton()
          ],
        ),
      ),
    );
  }

  Widget _mailAddressTextField(WidgetRef ref) {
    final mailAddressController = ref.read(mailAddressProvider.notifier);
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
              mailAddressController.state = mailAddress;
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

  Widget _createButton() {
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
              const Text("追加", style: TextStyle(fontWeight: FontWeight.bold)),
          onPressed: () async {},
        ),
      ),
    );
  }

  Future addDialog(BuildContext context, WidgetRef ref) async {
    try {} on Exception catch (e) {
      await dialogError(e.toString(), context);
    } catch (e) {
      await dialogError(e.toString(), context);
    }
  }

  Future dialogSuccess(BuildContext context) async {
    await showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text('追加しました。'),
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

  Future dialogError(String error, BuildContext context) async {
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
