import 'package:budget/model/category/category.dart';
import 'package:budget/model/fixed_expense/fixed_expense.dart';
import 'package:budget/viewModels/category_expense_model.dart';
import 'package:budget/viewModels/fixed_expense_model.dart';
import 'package:budget/widgets/automatic_input_date_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../widgets/category_bottom_sheet_dar.dart';

final amountProvider = StateProvider.autoDispose((ref) => "");
final memoProvider = StateProvider.autoDispose((ref) => "");
final automaticInputdateProvider = StateProvider.autoDispose((ref) => "月の始まり");
final automaticInputDateIndex = StateProvider.autoDispose((ref) => 0);

class FixedExpensePage extends ConsumerWidget {
  FixedExpensePage({super.key});
  String amount = "";
  Category? category;
  String memo = "";
  String date = "";
  String autoMaticInputDate = "";
  int autoMaticInputDay = 1;
  int categoryExpenseIndex = 0;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoryExpenseModel = ref.watch(categoryExpenseModelProvider);
    return SingleChildScrollView(
        child: Container(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
            width: 380,
            height: 640,
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
              automaticInputDate(context, ref, "自動入力"),
              amountTextField(ref, "支出"),
              categoryBar(
                  context, ref, "カテゴリー", categoryExpenseModel.categorys),
              memoTextField("メモ", ref),
              addButton(ref, context)
            ])),
      ),
    ));
  }

  void _selectedAutoMaticDate(String autoMaticDate) {
    DateTime now = DateTime.now();
    DateTime dateTime = DateTime.now();
    switch (autoMaticDate) {
      case "月の始まり":
        dateTime = DateTime(now.year, now.month + 1, 1);
        autoMaticInputDay = dateTime.day;
        break;
      case "月の終わり":
        autoMaticInputDay =
            int.parse(DateTime(now.year, now.month + 1, 0).day.toString());
        break;
      default:
        autoMaticInputDay =
            int.parse(RegExp(r'\d+').stringMatch(autoMaticDate)!);
        break;
    }
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

  Widget automaticInputDate(
      BuildContext context, WidgetRef ref, String itemName) {
    autoMaticInputDate = ref.watch(automaticInputdateProvider);
    final automaticInputDateController =
        ref.read(automaticInputdateProvider.notifier);
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
                const SizedBox(width: 20),
                Expanded(
                  flex: 7,
                  child: Text(
                    autoMaticInputDate,
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_downward),
                    onPressed: () {
                      AutomaticInputDatePicker.showModalPicker(context,
                          (selectedItem) {
                        automaticInputDateController.state = selectedItem;
                      });
                    },
                  ),
                ),
              ])),
        ],
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
                    style: const TextStyle(fontSize: 20),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: (amountText) {
                      amountController.state = amountText;
                    },
                    decoration: const InputDecoration(
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
  Widget categoryBar(BuildContext context, WidgetRef ref, String itemName,
      List<Category> categorys) {
    categoryExpenseIndex = ref.watch(categoryExpenseIndexProvider);
    category = categorys[categoryExpenseIndex];
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
                Icon(IconData(category!.icon!, fontFamily: 'MaterialIcons'),
                    color: Color(category!.color!)),
                const SizedBox(width: 20),
                Expanded(
                  flex: 8,
                  child: Text(category!.category,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20)),
                ),
                categoryBottomSheetBarButtom(
                  categorys: categorys,
                  onSelectedItemChanged: (index) {
                    ref.read(categoryExpenseIndexProvider.notifier).state =
                        index;
                  },
                )
              ])),
        ],
      ),
    );
  }

  //メモ欄
  Widget memoTextField(String itemName, WidgetRef ref) {
    memo = ref.watch(memoProvider);
    final memoController = ref.read(memoProvider.notifier);
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
  Widget addButton(WidgetRef ref, BuildContext context) {
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
            "追加",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          onPressed: () async {
            _selectedAutoMaticDate(autoMaticInputDate);
            await addDialog(context, ref);
          },
        ),
      ),
    );
  }

  //追加ダイアログ
  Future addDialog(BuildContext context, WidgetRef ref) async {
    final expenseViewModel = ref.read(fixedExpenseViewModelProvider.notifier);
    final fixedExpensAddData = FixedExpense(
        amount: amount,
        autoMaticInputDate: autoMaticInputDate,
        autoMaticInputDay: autoMaticInputDay,
        memo: memo,
        category: category!.category,
        color: category!.color!,
        icon: category!.icon!,
        categoryIndex: categoryExpenseIndex);
    try {
      await expenseViewModel.addExpense(fixedExpensAddData);
      await expenseViewModel.getExpenses();
      await dialogResult(context, expenseViewModel, ref);
    } on Exception catch (e) {
      await dialogError(e.toString(), context);
    } catch (e) {
      await dialogError(e.toString(), context);
    }
  }

  //成功した時のダイアログー
  Future dialogResult(
      BuildContext context, FixedExpenseModel model, WidgetRef ref) async {
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
                int count = 0;
                Navigator.popUntil(context, (_) => count++ >= 2);
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
