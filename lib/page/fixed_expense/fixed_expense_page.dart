import 'package:budget/model/category/category.dart';
import 'package:budget/model/fixed_expense/fixed_expense.dart';
import 'package:budget/page/recurring_income/recurring_income_page.dart';
import 'package:budget/viewModels/category_expense_model.dart';
import 'package:budget/viewModels/fixed_expense_model.dart';
import 'package:budget/widgets/automatic_input_date_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../widgets/category_bottom_sheet_bar.dart';

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
  int autoMaticInputDateIndex = 0;
  int autoMaticInputDay = 1;
  int categoryExpenseIndex = 0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoryExpenseModel = ref.watch(categoryExpenseModelProvider);
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: _buildInputCard(context, ref, categoryExpenseModel.categorys),
      ),
    );
  }

  Widget _buildInputCard(BuildContext context, WidgetRef ref, List<Category> categorys) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFF5252), Color(0xFFFF8A80)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24.r),
                topRight: Radius.circular(24.r),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.repeat, color: Colors.white, size: 28.sp),
                SizedBox(width: 12.w),
                Text(
                  '固定支出',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              children: [
                _buildAutomaticInputDateField(context, ref),
                SizedBox(height: 16.h),
                _buildAmountField(ref),
                SizedBox(height: 16.h),
                _buildCategoryField(context, ref, categorys),
                SizedBox(height: 16.h),
                _buildMemoField(ref),
                SizedBox(height: 24.h),
                _buildAddButton(ref, context),
              ],
            ),
          ),
        ],
      ),
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

  Widget _buildAutomaticInputDateField(BuildContext context, WidgetRef ref) {
    autoMaticInputDate = ref.watch(automaticInputdateProvider);
    final automaticInputDateController =
        ref.read(automaticInputdateProvider.notifier);
    autoMaticInputDateIndex = ref.watch(automaticInputDateIndexProvider);
    final automaticInputDateIndexController =
        ref.watch(automaticInputDateIndexProvider.notifier);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 4.w, bottom: 8.h),
          child: Text(
            '自動入力日',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF4A5568),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF7FAFC),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(14.w),
                child: Icon(Icons.calendar_today, size: 24.sp, color: const Color(0xFFFF5252)),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  child: Text(
                    autoMaticInputDate,
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: const Color(0xFF2D3748),
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.expand_more, size: 24.sp, color: const Color(0xFF718096)),
                onPressed: () {
                  AutomaticInputDatePicker.showModalPicker(context, (selectedItem, index) {
                    automaticInputDateIndexController.state = index;
                    automaticInputDateController.state = selectedItem;
                  });
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAmountField(WidgetRef ref) {
    amount = ref.watch(amountProvider);
    final amountController = ref.read(amountProvider.notifier);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 4.w, bottom: 8.h),
          child: Text(
            '金額',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF4A5568),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF7FAFC),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(14.w),
                child: Icon(Icons.currency_yen, size: 24.sp, color: const Color(0xFFFF5252)),
              ),
              Expanded(
                child: TextField(
                  style: TextStyle(fontSize: 16.sp, color: const Color(0xFF2D3748)),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: '金額を入力',
                    hintStyle: TextStyle(color: const Color(0xFFA0AEC0), fontSize: 16.sp),
                    contentPadding: EdgeInsets.symmetric(vertical: 14.h),
                  ),
                  onChanged: (amountText) {
                    amountController.state = amountText;
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryField(BuildContext context, WidgetRef ref, List<Category> categorys) {
    categoryExpenseIndex = ref.watch(categoryExpenseIndexProvider);
    category = categorys[categoryExpenseIndex];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 4.w, bottom: 8.h),
          child: Text(
            'カテゴリー',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF4A5568),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF7FAFC),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(14.w),
                child: Icon(
                  IconData(category!.icon!, fontFamily: 'MaterialIcons'),
                  size: 24.sp,
                  color: Color(category!.color!),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  child: Text(
                    category!.category,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF2D3748),
                    ),
                  ),
                ),
              ),
              categoryBottomSheetBarButtom(
                categorys: categorys,
                onSelectedItemChanged: (index) {
                  ref.read(categoryExpenseIndexProvider.notifier).state = index;
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMemoField(WidgetRef ref) {
    memo = ref.watch(memoProvider);
    final memoController = ref.read(memoProvider.notifier);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 4.w, bottom: 8.h),
          child: Text(
            'メモ',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF4A5568),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF7FAFC),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(14.w),
                child: Icon(Icons.edit_note, size: 24.sp, color: const Color(0xFF718096)),
              ),
              Expanded(
                child: TextField(
                  style: TextStyle(fontSize: 16.sp, color: const Color(0xFF2D3748)),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'メモを入力',
                    hintStyle: TextStyle(color: const Color(0xFFA0AEC0), fontSize: 16.sp),
                    contentPadding: EdgeInsets.symmetric(vertical: 14.h),
                  ),
                  onChanged: (memoText) {
                    memoController.state = memoText;
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAddButton(WidgetRef ref, BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56.h,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFF5252),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        ),
        onPressed: () async {
          _selectedAutoMaticDate(autoMaticInputDate);
          await addDialog(context, ref);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_circle_outline, size: 24.sp),
            SizedBox(width: 8.w),
            Text('追加', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Future addDialog(BuildContext context, WidgetRef ref) async {
    final expenseViewModel = ref.read(fixedExpenseViewModelProvider.notifier);
    final fixedExpensAddData = FixedExpense(
        amount: amount,
        autoMaticInputDate: autoMaticInputDate,
        autoMaticInputDay: autoMaticInputDay,
        autoMaticInuputDateIndex: autoMaticInputDateIndex,
        memo: memo,
        category: category!.category,
        color: category!.color!,
        icon: category!.icon!,
        categoryIndex: categoryExpenseIndex);
    try {
      await expenseViewModel.addExpense(fixedExpensAddData);
      await expenseViewModel.getExpenses();
      if (context.mounted) await dialogResult(context, expenseViewModel, ref);
    } on Exception catch (e) {
      if (context.mounted) await dialogError(e.toString(), context);
    } catch (e) {
      if (context.mounted) await dialogError(e.toString(), context);
    }
  }

  Future dialogResult(
      BuildContext context, FixedExpenseModel model, WidgetRef ref) async {
    await showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle, color: const Color(0xFF00C853), size: 24.sp),
              SizedBox(width: 8.w),
              const Text('完了'),
            ],
          ),
          content: Padding(
            padding: EdgeInsets.only(top: 12.h),
            child: const Text('追加しました。'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK', style: TextStyle(color: Color(0xFF00C853))),
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

  Future dialogError(String error, BuildContext context) async {
    await showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, color: Colors.red, size: 24.sp),
              SizedBox(width: 8.w),
              const Text('エラー'),
            ],
          ),
          content: Padding(padding: EdgeInsets.only(top: 12.h), child: Text(error)),
          actions: <Widget>[
            TextButton(child: const Text('OK'), onPressed: () => Navigator.of(context).pop())
          ],
        );
      },
    );
  }
}
