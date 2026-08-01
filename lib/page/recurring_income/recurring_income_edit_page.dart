import 'package:budget/model/category/category.dart';
import 'package:budget/model/recurring_income/recurring_income.dart';
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
      backgroundColor: const Color(0xFFF5F7FA),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildHeader(context)),
            SliverToBoxAdapter(child: _buildContent(context, ref)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 60.h, 20.w, 24.h),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF00C853), Color(0xFF00E676)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32.r),
          bottomRight: Radius.circular(32.r),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00C853).withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20.sp),
            ),
          ),
          SizedBox(width: 16.w),
          Icon(Icons.edit, color: Colors.white, size: 28.sp),
          SizedBox(width: 12.w),
          Text(
            '定期収入編集',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          SizedBox(height: 16.h),
          _buildEditCard(context, ref),
        ],
      ),
    );
  }

  Widget _buildEditCard(BuildContext context, WidgetRef ref) {
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
                colors: [Color(0xFF00C853), Color(0xFF00E676)],
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
                  '定期収入情報',
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
                _buildCategoryField(context, ref),
                SizedBox(height: 16.h),
                _buildMemoField(ref),
                SizedBox(height: 24.h),
                _buildEditButton(ref, context),
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
    autoMaticInputDate = ref.watch(automaticInputDateEditProvider);
    final automaticInputDateController =
        ref.read(automaticInputDateEditProvider.notifier);
    autoMaticInputDateIndex = ref.watch(automaticInputDateIndexEditProvider);
    final autoMaticInputDateIndexController =
        ref.read(automaticInputDateIndexEditProvider.notifier);
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
                child: Icon(Icons.calendar_today, size: 24.sp, color: const Color(0xFF00C853)),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  child: Text(
                    autoMaticInputDate!,
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
                    autoMaticInputDateIndexController.state = index;
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
    amount = ref.watch(amountEditProvider);
    final amountController = ref.read(amountEditProvider.notifier);
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
                child: Icon(Icons.currency_yen, size: 24.sp, color: const Color(0xFF00C853)),
              ),
              Expanded(
                child: TextField(
                  controller: amountTextEditingController,
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

  Widget _buildCategoryField(BuildContext context, WidgetRef ref) {
    categoryIncomeIndex = ref.watch(categoryEditIndexProvider);
    final categoryIncomeModel = ref.watch(categoryIncomeModelProvider);
    category = categoryIncomeModel.categoryIncomes[categoryIncomeIndex!];
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
                categorys: categoryIncomeModel.categoryIncomes,
                onSelectedItemChanged: (index) {
                  ref.read(categoryEditIndexProvider.notifier).state = index;
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMemoField(WidgetRef ref) {
    memo = ref.watch(memoEditProvider);
    final memoController = ref.read(memoEditProvider.notifier);
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
                  controller: memoTextEditingController,
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

  Widget _buildEditButton(WidgetRef ref, BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56.h,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF00C853),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        ),
        onPressed: () async {
          _selectedAutoMaticDate(autoMaticInputDate!);
          await addDialog(context, ref);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle_outline, size: 24.sp),
            SizedBox(width: 8.w),
            Text('保存', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

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
      if (context.mounted) await dialogResult(context, recurringIncomeModel, ref);
    } on Exception catch (e) {
      if (context.mounted) await dialogError(e.toString(), context);
    } catch (e) {
      if (context.mounted) await dialogError(e.toString(), context);
    }
  }

  Future dialogResult(
      BuildContext context, RecurringIncomeModel model, WidgetRef ref) async {
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
            child: const Text('編集しました。'),
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
