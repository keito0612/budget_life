import 'package:budget/model/balance_with_saving/balance_with_saving.dart';
import 'package:budget/viewModels/balance_with_saving_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final balanceProvider = StateProvider.autoDispose((ref) => 0);
final savingProvider = StateProvider.autoDispose((ref) => 0);

class BalanceSavingSettingsPage extends ConsumerWidget {
  BalanceSavingSettingsPage({super.key});
  int balance = 0;
  int saving = 0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
          backgroundColor: Colors.grey,
          appBar: AppBar(
            backgroundColor: Colors.green,
            title: const Text("月の手取りと貯金の設定"),
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
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
                height: 400,
                child: Column(
                  children: [
                    balanceTextField(ref, "月の手取り"),
                    savingTextField("貯金額", ref),
                    settingButton(context, ref)
                  ],
                ),
              ),
            ),
          )),
    );
  }

  Widget itemLabel(String itemName) {
    return Padding(
      padding: const EdgeInsets.only(left: 30),
      child: Container(
        width: double.infinity,
        child: Text(itemName,
            textAlign: TextAlign.left,
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20)),
      ),
    );
  }

  //残金欄
  Widget balanceTextField(WidgetRef ref, String itemName) {
    balance = ref.watch(balanceProvider);
    final balanceController = ref.read(balanceProvider.notifier);

    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: Column(
        children: [
          itemLabel(itemName),
          Container(
            height: 60,
            width: 320,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black38,
                  offset: Offset(2.0, 2.0),
                  blurRadius: 4.0,
                  spreadRadius: 4.0,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Expanded(flex: 1, child: Icon(Icons.currency_yen)),
                Expanded(
                  flex: 5,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    style: const TextStyle(fontSize: 20),
                    onChanged: (monthAmount) {
                      balanceController.state = int.tryParse(monthAmount) ?? 0;
                    },
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "手取り",
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //貯金額欄
  Widget savingTextField(String itemName, WidgetRef ref) {
    saving = ref.watch(savingProvider);
    final savingController = ref.read(savingProvider.notifier);
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: Column(
        children: [
          itemLabel(itemName),
          Container(
            height: 60,
            width: 320,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black38,
                  offset: Offset(2.0, 2.0),
                  blurRadius: 4.0,
                  spreadRadius: 4.0,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Expanded(flex: 1, child: Icon(Icons.currency_yen)),
                Expanded(
                  flex: 5,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    style: const TextStyle(fontSize: 20),
                    onChanged: (amount) {
                      savingController.state = int.tryParse(amount) ?? 0;
                    },
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "貯金",
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget settingButton(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: Container(
        height: 50,
        width: 100,
        color: Colors.green,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: 10,
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            side: const BorderSide(color: Colors.white, width: 3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child:
              const Text("設定", style: TextStyle(fontWeight: FontWeight.bold)),
          onPressed: () async {
            await settingDialog(context, ref);
          },
        ),
      ),
    );
  }

  //追加ダイアログ
  Future settingDialog(BuildContext context, WidgetRef ref) async {
    final model = ref.read(balanceWithSavingModelProvider.notifier);
    final balanceWithSaving =
        BalanceWithSaving(balance: balance, saving: saving);
    try {
      await model.setBalanseWithSaving(balanceWithSaving);
      await dialogResult(context, model);
    } on Exception catch (e) {
      await dialogError(e.toString(), context);
    } catch (e) {
      await dialogError(e.toString(), context);
    }
  }

  //成功した時のダイアログー
  Future dialogResult(
      BuildContext context, BalanceWithSavingModel model) async {
    await showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text('設定が完了しました。'),
          content: const Text(''),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () async {
                model.getBalanseWithSaving();
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  //エラーダイアログ
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
