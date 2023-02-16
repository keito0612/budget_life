import 'package:budget/model/expense.dart';
import 'package:budget/repositorys/expense_repository.dart';
import 'package:budget/utils/util.dart';
import 'package:budget/viewModels/expense_model.dart';
import 'package:budget/widgets/bottom_sheet_dar.dart';
import 'package:budget/widgets/dateBar_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';

final amountProvider = StateProvider.autoDispose((ref) => "");
final memoProvider = StateProvider.autoDispose((ref) => "");
final alertMessageProvider = StateProvider((ref) => "");

class ExpensePage extends ConsumerWidget {
  ExpensePage({super.key});
  List<String> categoryList = ["交際費", "衣服"];
  String amount = "";
  String category = "";
  String memo = "";
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      child: Container(
        child: Column(children: <Widget>[
          dateBarWidget(),
          SizedBox(height: 10),
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
                  memoTextField("メモ"),
                  addButton(ref, context)
                ])),
          )
        ]),
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
    amount = ref.watch(amountProvider);
    final amountController = ref.read(amountProvider.notifier);
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
                Expanded(
                  flex: 3,
                  child: IconButton(
                      onPressed: () {
                        bottomSheetBar.showModalPicker(
                            categoryList, context, ref);
                      },
                      icon: Icon(Icons.arrow_downward)),
                )
              ])),
        ],
      ),
    );
  }

  //メモ欄
  Widget memoTextField(String itemName) {
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
                    style: const TextStyle(fontSize: 20),
                    onChanged: (memoText) {
                      memo = memoText;
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
  Widget addButton(WidgetRef ref, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: Container(
        color: Colors.green,
        child: ElevatedButton(
          child: Text("追加"),
          onPressed: () async {
            await addDialog(context, ref);
          },
        ),
      ),
    );
  }

  //追加ダイアログ
  Future addDialog(BuildContext context, WidgetRef ref) async {
    final expenseViewModel = ref.watch(expenseViewModelProvider.notifier);
    final date = ref.watch(dateProvider);
    final expenseAddData =
        Expense(amount: amount, date: date, memo: memo, category: category);
    try {
      print(expenseAddData);
      await expenseViewModel.addExpense(expenseAddData);
      await dialogResult(context);
    } on Exception catch (e) {
      await dialogError(e.toString(), context);
    } catch (e) {
      await dialogError(e.toString(), context);
    }
  }

  //成功した時のダイアログー
  Future dialogResult(BuildContext context) async {
    await showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text('追加しました。'),
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
