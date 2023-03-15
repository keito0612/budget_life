import 'package:budget/model/income.dart';
import 'package:budget/widgets/category_bottom_sheet_dar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../viewModels/income_model.dart';
import '../../widgets/dateBar_widget.dart';

class IncomeEditPage extends ConsumerWidget {
  late final amountEditProvider = StateProvider.autoDispose((ref) => amount);
  late final memoEditProvider = StateProvider.autoDispose((ref) => memo);

  IncomeEditPage(
      {super.key,
      required this.id,
      required this.amount,
      required this.category,
      required this.memo}) {
    amountTextEditingController.text = amount!;
    memoTextEditingController.text = memo!;
  }
  List<String> categoryList = ["交際費", "衣服"];
  int? id;
  String? amount;
  String? category;
  String? memo;
  TextEditingController amountTextEditingController = TextEditingController();
  TextEditingController memoTextEditingController = TextEditingController();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text("編集"),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(children: <Widget>[
            dateBarWidget(),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                  width: 380,
                  height: 500,
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
                  child: Column(children: [
                    amountTextField(ref, "支出"),
                    categoryBar(context, ref, "カテゴリー"),
                    memoTextField("メモ", ref),
                    editButton(ref, context)
                  ])),
            )
          ]),
        ),
      ),
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

  //支出欄
  Widget amountTextField(WidgetRef ref, String itemName) {
    amount = ref.watch(amountEditProvider);
    final amountController = ref.read(amountEditProvider.notifier);
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
                    controller: amountTextEditingController,
                    style: TextStyle(fontSize: 20),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: (amountText) {
                      amountController.state = amountText;
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "支出",
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

  //カテゴリ欄
  Widget categoryBar(BuildContext context, WidgetRef ref, String itemName) {
    final categoryIndex = ref.watch(categoryIndexProvider);
    category = categoryList[categoryIndex];
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
                borderRadius: BorderRadius.all(Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black38,
                    offset: Offset(2.0, 2.0),
                    blurRadius: 4.0,
                    spreadRadius: 4.0,
                  ),
                ],
              ),
              child: Row(children: <Widget>[
                const SizedBox(width: 15),
                const Icon(Icons.category),
                const SizedBox(width: 20),
                Expanded(
                  flex: 8,
                  child: Text(categoryList[categoryIndex],
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                ),
                categoryBottomSheetBarButtom()
              ])),
        ],
      ),
    );
  }

  //メモ欄
  Widget memoTextField(String itemName, WidgetRef ref) {
    memo = ref.watch(memoEditProvider);
    final memoController = ref.read(memoEditProvider.notifier);
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
                const Expanded(flex: 1, child: Icon(Icons.edit)),
                Expanded(
                  flex: 5,
                  child: TextField(
                    controller: memoTextEditingController,
                    style: const TextStyle(fontSize: 20),
                    onChanged: (memoText) {
                      memoController.state = memoText;
                    },
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "メモ",
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

  //追加ボタン
  Widget editButton(WidgetRef ref, BuildContext context) {
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
          child: const Text(
            "編集",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          onPressed: () async {
            await editDialog(context, ref);
          },
        ),
      ),
    );
  }

  //追加ダイアログ
  Future editDialog(BuildContext context, WidgetRef ref) async {
    final incomeViewModel = ref.read(incomeViewModelProvider.notifier);
    final date = ref.watch(dateProvider);
    final expenseEditData = Income(
        id: id, amount: amount!, date: date, memo: memo!, category: category!);
    try {
      await incomeViewModel.updateIncome(expenseEditData);
      await dialogResult(context, incomeViewModel);
    } on Exception catch (e) {
      await dialogError(e.toString(), context);
    } catch (e) {
      await dialogError(e.toString(), context);
    }
  }

  //成功した時のダイアログー
  Future dialogResult(BuildContext context, IncomeViewModel model) async {
    await showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text('編集しました。'),
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
