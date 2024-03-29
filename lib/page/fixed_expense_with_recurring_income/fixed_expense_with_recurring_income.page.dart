import 'package:budget/model/category/category.dart';
import 'package:budget/model/fixed_expense/fixed_expense.dart';
import 'package:budget/model/recurring_income/recurring_income.dart';
import 'package:budget/page/fixed_expense/fixed_expense_edit_page.dart';
import 'package:budget/page/fixed_expense_with_recurring_income/fixed_expense_with_recurring_income_add_page.dart';
import 'package:budget/page/recurring_income/recurring_income_edit_page.dart';
import 'package:budget/viewModels/fixed_expense_model.dart';
import 'package:budget/viewModels/recurringI_income_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class FixedExpenseWithRecurringIncomePage extends ConsumerWidget {
  const FixedExpenseWithRecurringIncomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: const Text("月の固定費•定期収入", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10.r),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  labelWidget(
                      text: "支出",
                      right: 0.0.w,
                      left: 0.0.w,
                      top: 0.0.h,
                      bottom: 10.h),
                ],
              ),
              _fixedExpenseWidget(ref, context),
              Row(
                children: [
                  labelWidget(
                      text: "収入",
                      right: 120.0.w,
                      left: 0.0.w,
                      top: 10.0.h,
                      bottom: 10.h),
                ],
              ),
              _recurringIncomeWidget(ref, context)
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        width: 60.0.sp,
        height: 60.0.sp,
        child: FloatingActionButton(
          child: Icon(
            color: Colors.white,
            Icons.add,
            size: 20.sp,
          ),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    fullscreenDialog: true,
                    builder: (context) =>
                        const fixedExpenseWithRecurringIncomeAddPage()));
          },
        ),
      ),
    );
  }

  Widget labelWidget(
      {String? text,
      double? right,
      double? left,
      double? top,
      double? bottom}) {
    return Padding(
      padding: EdgeInsets.only(
          right: right!, left: left!, top: top!, bottom: bottom!),
      child: Text(
        text!,
        style: TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20.sp),
      ),
    );
  }

  Widget _fixedExpenseWidget(WidgetRef ref, BuildContext context) {
    final fixedExpenses = ref.watch(fixedExpenseViewModelProvider);
    final fixedExpenseModel = ref.read(fixedExpenseViewModelProvider.notifier);
    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: 100.h,
      ),
      child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.all(Radius.circular(20.r))),
          child: _fixedExpenseList(
              fixedExpenses.fixedExpenses, fixedExpenseModel, context)),
    );
  }

  Widget _fixedExpenseList(List<FixedExpense> fixedExpenses,
      FixedExpenseModel fixedExpenseModel, BuildContext context) {
    return ListView(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: fixedExpenses
            .map((fixedExpnese) =>
                _fixedExpenseItem(context, fixedExpenseModel, fixedExpnese))
            .toList());
  }

  Widget _fixedExpenseItem(BuildContext context,
      FixedExpenseModel fixedExpenseModel, FixedExpense fixedExpnese) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6.0.r),
      ),
      elevation: 8.0,
      margin: EdgeInsets.symmetric(horizontal: 10.0.r, vertical: 6.0.r),
      child: SizedBox(
        child: Slidable(
          endActionPane: ActionPane(
            motion: const ScrollMotion(),
            children: [
              SlidableAction(
                  backgroundColor: Colors.black38,
                  foregroundColor: Colors.white,
                  icon: Icons.edit,
                  label: '編集',
                  onPressed: (context) async {
                    await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FixedExpenseEditPage(
                                id: fixedExpnese.id!,
                                amount: fixedExpnese.amount,
                                category: Category(
                                    category: fixedExpnese.category!,
                                    icon: fixedExpnese.icon,
                                    color: fixedExpnese.color),
                                memo: fixedExpnese.memo,
                                autoMaticInputDate:
                                    fixedExpnese.autoMaticInputDate,
                                autoMaticInputDateIndex:
                                    fixedExpnese.autoMaticInuputDateIndex,
                                autoMaticInputDay:
                                    fixedExpnese.autoMaticInputDay,
                                categoryExpenseIndex:
                                    fixedExpnese.categoryIndex)));
                  }),
              SlidableAction(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  icon: Icons.error_sharp,
                  label: '消去',
                  onPressed: (context) async {
                    fixedExpenseModel.deleteExpense(fixedExpnese.id!);
                  }),
            ],
          ),
          child: ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      IconData(
                        fixedExpnese.icon!,
                        fontFamily: 'MaterialIcons',
                      ),
                      color: Color(fixedExpnese.color!),
                      size: 25.sp,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      fixedExpnese.category!,
                      style: TextStyle(fontSize: 20.sp),
                    ),
                  ],
                ),
                Text(
                  "金額：${fixedExpnese.amount}円",
                  style: TextStyle(fontSize: 20.sp),
                ),
                Text("自動入力：${fixedExpnese.autoMaticInputDate}",
                    style: TextStyle(fontSize: 20.sp)),
                Text("メモ：${fixedExpnese.memo}",
                    style: TextStyle(fontSize: 20.sp)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _recurringIncomeWidget(WidgetRef ref, BuildContext context) {
    final recurringIncomes = ref.watch(recurringIncomeViewModelProvider);
    final recurringIncomeModel =
        ref.read(recurringIncomeViewModelProvider.notifier);
    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: 100.h,
      ),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.all(Radius.circular(20.r))),
        child: _recurringIncomeList(
            recurringIncomes.recurringIncomes, recurringIncomeModel, context),
      ),
    );
  }

  Widget _recurringIncomeList(List<RecurringIncome> recurringIncomes,
      RecurringIncomeModel recurringIncomeModel, BuildContext context) {
    return ListView(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: recurringIncomes
            .map((recurringIncome) => _recurringIncomeItem(
                recurringIncome, recurringIncomeModel, context))
            .toList());
  }

  Widget _recurringIncomeItem(RecurringIncome recurringIncome,
      RecurringIncomeModel recurringIncomeModel, BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6.0.r),
      ),
      elevation: 8.0,
      margin: EdgeInsets.symmetric(horizontal: 10.0.r, vertical: 6.0.r),
      child: SizedBox(
        child: Slidable(
          endActionPane: ActionPane(
            motion: const ScrollMotion(),
            children: [
              SlidableAction(
                  backgroundColor: Colors.black38,
                  foregroundColor: Colors.white,
                  icon: Icons.edit,
                  label: '編集',
                  onPressed: (context) async {
                    await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RecurringIncomeEditPage(
                                id: recurringIncome.id!,
                                amount: recurringIncome.amount,
                                category: Category(
                                    category: recurringIncome.category!,
                                    icon: recurringIncome.icon,
                                    color: recurringIncome.color),
                                memo: recurringIncome.memo,
                                autoMaticInputDate:
                                    recurringIncome.autoMaticInputDate,
                                autoMaticInputDateIndex:
                                    recurringIncome.autoMaticInuputDateIndex,
                                autoMaticInputDay:
                                    recurringIncome.autoMaticInputDay,
                                categoryIncomeIndex:
                                    recurringIncome.categoryIndex)));
                  }),
              SlidableAction(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  icon: Icons.error_sharp,
                  label: '消去',
                  onPressed: (context) async {
                    recurringIncomeModel
                        .deleteRecurringIncome(recurringIncome.id!);
                  }),
            ],
          ),
          child: ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      IconData(recurringIncome.icon!,
                          fontFamily: 'MaterialIcons'),
                      color: Color(recurringIncome.color!),
                      size: 25.sp,
                    ),
                    SizedBox(width: 5.w),
                    Text(recurringIncome.category!,
                        style: TextStyle(fontSize: 20.sp)),
                  ],
                ),
                Text(
                  "金額：${recurringIncome.amount}円",
                  style: TextStyle(fontSize: 20.sp),
                ),
                Text("自動入力：${recurringIncome.autoMaticInputDate}",
                    style: TextStyle(fontSize: 20.sp)),
                Text(
                  "メモ：${recurringIncome.memo}",
                  style: TextStyle(fontSize: 20.sp),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
