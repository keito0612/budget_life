import 'package:budget/model/category/category.dart';
import 'package:budget/model/income/income.dart';
import 'package:budget/page/expense/expense_page.dart';
import 'package:budget/provider/shared_preferences_provider.dart';
import 'package:budget/utils/util.dart';
import 'package:budget/viewModels/category_income_model.dart';
import 'package:budget/viewModels/income_model.dart';
import 'package:budget/widgets/category_bottom_sheet_bar.dart';
import 'package:budget/widgets/dateBar_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class IncomePage extends ConsumerWidget {
  IncomePage({super.key});
  String amount = "";
  String memo = "";
  int categoryIncomeIndex = 0;
  Category? category;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      child: Column(children: <Widget>[
        dateBarWidget(),
        SizedBox(height: 10.h),
        Padding(
          padding: EdgeInsets.all(10.0.r),
          child: Container(
              width: 380.w,
              height: 500.h,
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
                amountTextField(ref, "収入"),
                categoryBar(context, ref, "カテゴリー"),
                memoTextField("メモ"),
                addButton(ref, context)
              ])),
        )
      ]),
    );
  }

  Widget itemLabel(String itemName) {
    return Padding(
      padding: EdgeInsets.only(left: 20.w),
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

  //支出欄
  Widget amountTextField(WidgetRef ref, String itemName) {
    amount = ref.watch(amountProvider);
    final amountController = ref.read(amountProvider.notifier);
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
                Expanded(flex: 1, child: Icon(Icons.currency_yen, size: 30.sp)),
                Expanded(
                  flex: 5,
                  child: TextField(
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
    categoryIncomeIndex = ref.watch(categoryIncomeIndexProvider);
    final categorys = ref.watch(categoryIncomeModelProvider);
    category = categorys.categoryIncomes[categoryIncomeIndex];

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
                    size: 30.sp, color: Color(category!.color!)),
                SizedBox(width: 20.w),
                Expanded(
                  flex: 8,
                  child: Text(category!.category,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20.sp)),
                ),
                categoryBottomSheetBarButtom(
                  categorys: categorys.categoryIncomes,
                  onSelectedItemChanged: (int index) {
                    ref.read(categoryIncomeIndexProvider.notifier).state =
                        index;
                  },
                ),
              ])),
        ],
      ),
    );
  }

  //メモ欄
  Widget memoTextField(String itemName) {
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
                Expanded(flex: 1, child: Icon(Icons.edit, size: 30.sp)),
                Expanded(
                  flex: 5,
                  child: TextField(
                    style: TextStyle(fontSize: 20.sp),
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
          child: Text("追加",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp)),
          onPressed: () async {
            await addDialog(context, ref);
          },
        ),
      ),
    );
  }

  //追加ダイアログ
  Future addDialog(BuildContext context, WidgetRef ref) async {
    final incomeViewModel = ref.read(incomeViewModelProvider.notifier);
    final date = ref.watch(dateProvider);
    final incomeAddData = Income(
        amount: amount,
        date: date,
        memo: memo,
        category: category!.category,
        icon: category!.icon,
        color: category!.color,
        categoryIndex: categoryIncomeIndex);
    try {
      await incomeViewModel.addIncomes(incomeAddData);
      await dialogResult(context, incomeViewModel, ref);
    } on Exception catch (e) {
      await dialogError(e.toString(), context);
    } catch (e) {
      await dialogError(e.toString(), context);
    }
  }

  //成功した時のダイアログー
  Future dialogResult(
      BuildContext context, IncomeViewModel model, WidgetRef ref) async {
    final prefs = ref.watch(sharedPreferencesProvider);
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
                final addedDay = DateTime.now();
                prefs.setString("added_day", Util.toDate(addedDay));
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
