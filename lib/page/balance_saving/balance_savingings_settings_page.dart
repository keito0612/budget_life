import 'package:budget/model/balance_with_saving/balance_with_saving.dart';
import 'package:budget/provider/shared_preferences_provider.dart';
import 'package:budget/viewModels/balance_with_saving_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

final balanceProvider = StateProvider.autoDispose((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return prefs.getInt("balanse") ?? 0;
});
final savingProvider = StateProvider.autoDispose((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return prefs.getInt("saving") ?? 0;
});

class BalanceSavingSettingsPage extends ConsumerWidget {
  BalanceSavingSettingsPage({super.key});
  int balance = 0;
  int saving = 0;
  TextEditingController textBalanceEditController = TextEditingController();
  TextEditingController textSavingEditController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
          backgroundColor: Colors.grey,
          appBar: AppBar(
              iconTheme: const IconThemeData(color: Colors.white),
              backgroundColor: Colors.green,
              title: const Text("月の手取りと貯金の設定",
                  style: TextStyle(color: Colors.white))),
          body: Center(
            child: Padding(
              padding: EdgeInsets.all(8.0.r),
              child: Container(
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
                height: 400.h,
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
      padding: EdgeInsets.only(left: 25.w, bottom: 5.h),
      child: Container(
        width: double.infinity,
        child: Text(itemName,
            textAlign: TextAlign.left,
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20.sp)),
      ),
    );
  }

  //残金欄
  Widget balanceTextField(WidgetRef ref, String itemName) {
    balance = ref.watch(balanceProvider);
    final balanceController = ref.read(balanceProvider.notifier);
    textBalanceEditController.text = balance == 0 ? "" : balance.toString();

    return Padding(
      padding: EdgeInsets.only(top: 50),
      child: Column(
        children: [
          itemLabel(itemName),
          Container(
            height: 60.h,
            width: 320.w,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(20.r),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black38,
                  offset: Offset(2.0.r, 2.0.r),
                  blurRadius: 4.0.r,
                  spreadRadius: 4.0.r,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                    flex: 1,
                    child: Icon(
                      Icons.currency_yen,
                      size: 20.sp,
                    )),
                Expanded(
                  flex: 5,
                  child: TextField(
                    controller: textBalanceEditController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    style: TextStyle(fontSize: 20.sp),
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
    textSavingEditController.text = saving == 0 ? "" : saving.toString();
    final savingController = ref.read(savingProvider.notifier);
    return Padding(
      padding: EdgeInsets.only(top: 40.h),
      child: Column(
        children: [
          itemLabel(itemName),
          Container(
            height: 60.h,
            width: 320.w,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(20.r),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black38,
                  offset: Offset(2.0.r, 2.0.r),
                  blurRadius: 4.0.r,
                  spreadRadius: 4.0.r,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                    flex: 1,
                    child: Icon(
                      Icons.currency_yen,
                      size: 20.sp,
                    )),
                Expanded(
                  flex: 5,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    controller: textSavingEditController,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    style: TextStyle(fontSize: 20.sp),
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
      padding: EdgeInsets.only(top: 30.r),
      child: Container(
        height: 50.h,
        width: 100.w,
        color: Colors.green,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: 10,
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            side: BorderSide(color: Colors.white, width: 3.w),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.r),
            ),
          ),
          child: Text("設定",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp)),
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
              child: const Text('OK', style: TextStyle(color: Colors.green)),
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
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
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
              child: const Text('OK', style: TextStyle(color: Colors.green)),
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
