import 'package:budget/model/category/category.dart';
import 'package:budget/model/recurring_income/recurring_income.dart';
import 'package:budget/viewModels/category_expense_model.dart';
import 'package:budget/viewModels/recurringI_income_model.dart';
import 'package:budget/widgets/automatic_input_date_picker.dart';
import 'package:budget/widgets/category_bottom_sheet_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../viewModels/category_income_model.dart';

class RecurringIncomeEditPage extends ConsumerWidget {
  late final amountEditProvider = StateProvider.autoDispose((ref) => amount);
  late final memoEditProvider = StateProvider.autoDispose((ref) => memo);
  late final automaticInputDateEditProvider =
      StateProvider.autoDispose((ref) => autoMaticInputDate);
  late final automaticInputDateIndexEditProvider =
      StateProvider.autoDispose((ref) => autoMaticInputDateIndex);
  late final categoryEditIndexProvider =
      StateProvider.autoDispose((ref) => categoryIncomeIndex);
  RecurringIncomeEditPage({
    super.key,
    required this.id,
    required this.amount,
    required this.category,
    required this.memo,
    required this.autoMaticInputDate,
    required this.autoMaticInputDateIndex,
    required this.autoMaticInputDay,
    required this.categoryIncomeIndex,
  }) {
    amountTextEditingController.text = amount!;
    memoTextEditingController.text = memo!;
  }
  int? id;
  String? amount;
  Category? category;
  String? memo;
  String? autoMaticInputDate;
  int? autoMaticInputDateIndex;
  int? autoMaticInputDay;
  int? categoryIncomeIndex;
  TextEditingController amountTextEditingController = TextEditingController();
  TextEditingController memoTextEditingController = TextEditingController();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        backgroundColor: Colors.green,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("編集", style: TextStyle(color: Colors.white)),
      ),
      body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
              child: Container(
            child: Padding(
              padding: EdgeInsets.all(10.0.r),
              child: Container(
                  width: 380.w,
                  height: 640.h,
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
                  child: Column(children: [
                    automaticInputDate(context, ref, "自動入力"),
                    amountTextField(ref, "収入"),
                    categoryBar(context, ref, "カテゴリー"),
                    memoTextField("メモ", ref),
                    addButton(ref, context)
                  ])),
            ),
          ))),
    );
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
      padding: EdgeInsets.only(left: 30.w),
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

  Widget automaticInputDate(
      BuildContext context, WidgetRef ref, String itemName) {
    autoMaticInputDate = ref.watch(automaticInputDateEditProvider);
    final automaticInputDateController =
        ref.read(automaticInputDateEditProvider.notifier);
    autoMaticInputDateIndex = ref.watch(automaticInputDateIndexEditProvider);
    final autoMaticInputDateIndexController =
        ref.read(automaticInputDateIndexEditProvider.notifier);
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
                borderRadius: BorderRadius.all(Radius.circular(20.r)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black38,
                    offset: Offset(2.0.r, 2.0.r),
                    blurRadius: 4.0.r,
                    spreadRadius: 4.0.r,
                  ),
                ],
              ),
              child: Row(children: <Widget>[
                SizedBox(width: 20.w),
                Expanded(
                  flex: 7,
                  child: Text(
                    autoMaticInputDate!,
                    style: TextStyle(fontSize: 20.sp),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: IconButton(
                    icon: Icon(Icons.arrow_downward, size: 25.sp),
                    onPressed: () {
                      AutomaticInputDatePicker.showModalPicker(context,
                          (selectedItem, index) {
                        autoMaticInputDateIndexController.state = index;
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
    amount = ref.watch(amountEditProvider);
    final amountController = ref.read(amountEditProvider.notifier);
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
                Expanded(flex: 1, child: Icon(Icons.currency_yen, size: 25.sp)),
                Expanded(
                  flex: 5,
                  child: TextField(
                    controller: amountTextEditingController,
                    style: TextStyle(fontSize: 20.sp),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: (amountText) {
                      amountController.state = amountText;
                    },
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "金額",
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
    categoryIncomeIndex = ref.watch(categoryEditIndexProvider);
    final categoryIncomeModel = ref.watch(categoryIncomeModelProvider);
    category = categoryIncomeModel.categoryIncomes[categoryIncomeIndex!];
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
                borderRadius: BorderRadius.all(Radius.circular(20.r)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black38,
                    offset: Offset(2.0.r, 2.0.r),
                    blurRadius: 4.0.r,
                    spreadRadius: 4.0.r,
                  ),
                ],
              ),
              child: Row(children: <Widget>[
                SizedBox(width: 15.w),
                Icon(IconData(category!.icon!, fontFamily: 'MaterialIcons'),
                    size: 25.sp, color: Color(category!.color!)),
                SizedBox(width: 20.w),
                Expanded(
                  flex: 8,
                  child: Text(category!.category,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20.sp)),
                ),
                categoryBottomSheetBarButtom(
                  categorys: categoryIncomeModel.categoryIncomes,
                  onSelectedItemChanged: (index) {
                    ref.read(categoryEditIndexProvider.notifier).state = index;
                  },
                )
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
                      Icons.edit,
                      size: 25.sp,
                    )),
                Expanded(
                  flex: 5,
                  child: TextField(
                    controller: memoTextEditingController,
                    style: TextStyle(fontSize: 20.sp),
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
      padding: EdgeInsets.only(top: 30.h),
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
          child: Text(
            "追加",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp),
          ),
          onPressed: () async {
            _selectedAutoMaticDate(autoMaticInputDate!);
            await addDialog(context, ref);
          },
        ),
      ),
    );
  }

  //追加ダイアログ
  Future addDialog(BuildContext context, WidgetRef ref) async {
    final recurringIncomeModel =
        ref.read(recurringIncomeViewModelProvider.notifier);
    final recurringIncomeAddData = RecurringIncome(
        id: id,
        amount: amount!,
        autoMaticInputDate: autoMaticInputDate!,
        autoMaticInuputDateIndex: autoMaticInputDateIndex!,
        autoMaticInputDay: autoMaticInputDay!,
        memo: memo!,
        category: category!.category,
        color: category!.color!,
        icon: category!.icon!,
        categoryIndex: categoryIncomeIndex);
    try {
      await recurringIncomeModel.updateRecurringIncome(recurringIncomeAddData);
      await dialogResult(context, recurringIncomeModel, ref);
    } on Exception catch (e) {
      await dialogError(e.toString(), context);
    } catch (e) {
      await dialogError(e.toString(), context);
    }
  }

  //成功した時のダイアログー
  Future dialogResult(
      BuildContext context, RecurringIncomeModel model, WidgetRef ref) async {
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
