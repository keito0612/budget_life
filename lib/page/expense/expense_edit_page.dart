import 'package:budget/model/category/category.dart';
import 'package:budget/model/expense/expense.dart';
import 'package:budget/provider/shared_preferences_provider.dart';
import 'package:budget/utils/util.dart';
import 'package:budget/viewModels/category_expense_model.dart';
import 'package:budget/viewModels/expense_model.dart';
import 'package:budget/widgets/category_bottom_sheet_bar.dart';
import 'package:budget/widgets/dateBar_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExpenseEditPage extends ConsumerWidget {
  late final amountEditProvider = StateProvider.autoDispose((ref) => amount);
  late final memoEditProvider = StateProvider.autoDispose((ref) => memo);
  late final categoryEditIndexProvider =
      StateProvider.autoDispose((ref) => categoryIndex);
  late final paymentMethodEditProvider =
      StateProvider.autoDispose((ref) => walletId);

  ExpenseEditPage(
      {super.key,
      required this.id,
      required this.amount,
      required this.category,
      required this.memo,
      required this.categoryIndex,
      required this.walletId}) {
    amountTextEditingController.text = amount!;
    memoTextEditingController.text = memo!;
  }
  Category? category;
  int? id;
  String? amount;
  String? memo;
  int? categoryIndex;
  int? walletId;
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
          colors: [Color(0xFFFF5252), Color(0xFFFF8A80)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32.r),
          bottomRight: Radius.circular(32.r),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF5252).withValues(alpha: 0.3),
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
            '支出編集',
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
    return Column(
      children: [
        SizedBox(height: 16.h),
        dateBarWidget(),
        SizedBox(height: 16.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: _buildEditCard(context, ref),
        ),
        SizedBox(height: 24.h),
      ],
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
                Icon(Icons.trending_down, color: Colors.white, size: 28.sp),
                SizedBox(width: 12.w),
                Text(
                  '支出情報',
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
                _buildAmountField(ref),
                SizedBox(height: 16.h),
                _buildPaymentMethodField(ref),
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
                child: Icon(Icons.currency_yen, size: 24.sp, color: const Color(0xFFFF5252)),
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

  Widget _buildPaymentMethodField(WidgetRef ref) {
    walletId = ref.watch(paymentMethodEditProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 4.w, bottom: 8.h),
          child: Text(
            '支払い方法',
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
            border: Border.all(
              color: const Color(0xFFE2E8F0),
              width: 1,
            ),
          ),
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    ref.read(paymentMethodEditProvider.notifier).state = 0;
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    decoration: BoxDecoration(
                      color: walletId == 0
                          ? const Color(0xFF00C853)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.account_balance,
                          size: 20.sp,
                          color: walletId == 0
                              ? Colors.white
                              : const Color(0xFF718096),
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          '口座から',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: walletId == 0
                                ? Colors.white
                                : const Color(0xFF718096),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    ref.read(paymentMethodEditProvider.notifier).state = 1;
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    decoration: BoxDecoration(
                      color: walletId == 1
                          ? const Color(0xFF5C6BC0)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.account_balance_wallet,
                          size: 20.sp,
                          color: walletId == 1
                              ? Colors.white
                              : const Color(0xFF718096),
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          '財布から',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: walletId == 1
                                ? Colors.white
                                : const Color(0xFF718096),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryField(BuildContext context, WidgetRef ref) {
    categoryIndex = ref.watch(categoryEditIndexProvider);
    final categorysExpense = ref.watch(categoryExpenseModelProvider);
    category = categorysExpense.categorys[categoryIndex!];
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
                categorys: categorysExpense.categorys,
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
          backgroundColor: const Color(0xFFFF5252),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        ),
        onPressed: () async => await editDialog(context, ref),
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

  Future editDialog(BuildContext context, WidgetRef ref) async {
    final expenseViewModel = ref.read(expenseViewModelProvider.notifier);
    final date = ref.watch(dateProvider);
    final expenseEditData = Expense(
        id: id,
        amount: amount!,
        date: date,
        memo: memo!,
        category: category!.category,
        icon: category!.icon!,
        color: category!.color,
        categoryIndex: categoryIndex,
        walletId: walletId ?? 0);
    try {
      await expenseViewModel.updateExpense(expenseEditData);
      await dialogResult(context, expenseViewModel, ref);
    } on Exception catch (e) {
      await dialogError(e.toString(), context);
    } catch (e) {
      await dialogError(e.toString(), context);
    }
  }

  Future dialogResult(
      BuildContext context, ExpenseViewModel model, WidgetRef ref) async {
    final prefs = ref.watch(sharedPreferencesProvider);
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
                final addedDay = DateTime.now();
                prefs.setString("added_day", Util.toDate(addedDay));
                model.getExpenses();
                Navigator.of(context).pop();
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
