import 'package:budget/model/category/category.dart';
import 'package:budget/model/expense/expense.dart';
import 'package:budget/provider/shared_preferences_provider.dart';
import 'package:budget/utils/util.dart';
import 'package:budget/viewModels/balance_with_saving_model.dart';
import 'package:budget/viewModels/category_expense_model.dart';
import 'package:budget/viewModels/expense_model.dart';
import 'package:budget/widgets/category_bottom_sheet_bar.dart';
import 'package:budget/widgets/dateBar_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

final amountProvider = StateProvider.autoDispose((ref) => "");
final memoProvider = StateProvider.autoDispose((ref) => "");
// 0: 口座から, 1: 財布から
final paymentMethodProvider = StateProvider.autoDispose((ref) => 0);

class ExpensePage extends ConsumerWidget {
  ExpensePage({super.key});
  String amount = "";
  Category? category;
  String memo = "";
  int categoryExpenseIndex = 0;
  int paymentMethod = 0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: const Color(0xFFF5F7FA),
      child: SingleChildScrollView(
        child: Column(
          children: [
            dateBarWidget(),
            SizedBox(height: 16.h),
            _buildInputCard(context, ref),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }

  Widget _buildInputCard(BuildContext context, WidgetRef ref) {
    final categoryExpenseModel = ref.watch(categoryExpenseModelProvider);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
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
          // ヘッダー
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
                Icon(Icons.remove_circle_outline,
                    color: Colors.white, size: 28.sp),
                SizedBox(width: 12.w),
                Text(
                  '支出を追加',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          // 入力フィールド
          Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              children: [
                _buildAmountField(ref),
                SizedBox(height: 16.h),
                _buildPaymentMethodField(ref),
                SizedBox(height: 16.h),
                _buildCategoryField(
                    context, ref, categoryExpenseModel.categorys),
                SizedBox(height: 16.h),
                _buildMemoField(ref),
                SizedBox(height: 24.h),
                _buildSubmitButton(ref, context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputContainer({
    required String label,
    required Widget child,
    required IconData icon,
    Color? iconColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 4.w, bottom: 8.h),
          child: Text(
            label,
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
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(14.w),
                child: Icon(
                  icon,
                  size: 24.sp,
                  color: iconColor ?? const Color(0xFF718096),
                ),
              ),
              Expanded(child: child),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAmountField(WidgetRef ref) {
    amount = ref.watch(amountProvider);
    final amountController = ref.read(amountProvider.notifier);

    return _buildInputContainer(
      label: '支出金額',
      icon: Icons.currency_yen,
      iconColor: const Color(0xFFFF5252),
      child: TextField(
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF2D3748),
        ),
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        onChanged: (text) => amountController.state = text,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: '金額を入力',
          hintStyle: TextStyle(
            color: const Color(0xFFA0AEC0),
            fontSize: 16.sp,
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 14.h),
        ),
      ),
    );
  }

  Widget _buildPaymentMethodField(WidgetRef ref) {
    paymentMethod = ref.watch(paymentMethodProvider);

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
                    ref.read(paymentMethodProvider.notifier).state = 0;
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    decoration: BoxDecoration(
                      color: paymentMethod == 0
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
                          color: paymentMethod == 0
                              ? Colors.white
                              : const Color(0xFF718096),
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          '口座から',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: paymentMethod == 0
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
                    ref.read(paymentMethodProvider.notifier).state = 1;
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    decoration: BoxDecoration(
                      color: paymentMethod == 1
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
                          color: paymentMethod == 1
                              ? Colors.white
                              : const Color(0xFF718096),
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          '財布から',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: paymentMethod == 1
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

  Widget _buildCategoryField(
      BuildContext context, WidgetRef ref, List<Category> categorys) {
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
            border: Border.all(
              color: const Color(0xFFE2E8F0),
              width: 1,
            ),
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
                flex: 8,
                child: Text(
                  category!.category,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF2D3748),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: categoryBottomSheetBarButtom(
                  categorys: categorys,
                  onSelectedItemChanged: (int index) {
                    ref.read(categoryExpenseIndexProvider.notifier).state =
                        index;
                  },
                ),
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

    return _buildInputContainer(
      label: 'メモ（任意）',
      icon: Icons.note_alt_outlined,
      child: TextField(
        style: TextStyle(
          fontSize: 16.sp,
          color: const Color(0xFF2D3748),
        ),
        onChanged: (text) => memoController.state = text,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'メモを入力',
          hintStyle: TextStyle(
            color: const Color(0xFFA0AEC0),
            fontSize: 16.sp,
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 14.h),
        ),
      ),
    );
  }

  Widget _buildSubmitButton(WidgetRef ref, BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56.h,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFF5252),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
        onPressed: () async {
          await addDialog(context, ref);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle_outline, size: 24.sp),
            SizedBox(width: 8.w),
            Text(
              '追加する',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future addDialog(BuildContext context, WidgetRef ref) async {
    final expenseViewModel = ref.read(expenseViewModelProvider.notifier);
    final balanceModel = ref.read(balanceWithSavingModelProvider.notifier);
    final date = ref.read(dateProvider);
    // プロバイダーから最新の値を取得
    final currentAmount = ref.read(amountProvider);
    final currentMemo = ref.read(memoProvider);
    final currentPaymentMethod = ref.read(paymentMethodProvider);
    final currentCategoryIndex = ref.read(categoryExpenseIndexProvider);
    final categoryExpenseModel = ref.read(categoryExpenseModelProvider);
    final currentCategory = categoryExpenseModel.categorys[currentCategoryIndex];

    // paymentMethod: 0 = 口座から, 1 = 財布から
    final expenseAddData = Expense(
      amount: currentAmount,
      date: date,
      memo: currentMemo,
      category: currentCategory.category,
      color: currentCategory.color!,
      icon: currentCategory.icon!,
      categoryIndex: currentCategoryIndex,
      walletId: currentPaymentMethod, // 0: 口座, 1: 財布
    );

    try {
      await expenseViewModel.addExpense(expenseAddData);

      // 状態を更新（ViewModelで財布残高を計算）
      await balanceModel.getBalanseWithSaving();
      await expenseViewModel.getExpenses();

      if (context.mounted) {
        await _showSuccessDialog(context, ref);
      }
    } on Exception catch (e) {
      if (context.mounted) {
        await _showErrorDialog(e.toString(), context);
      }
    } catch (e) {
      if (context.mounted) {
        await _showErrorDialog(e.toString(), context);
      }
    }
  }

  Future _showSuccessDialog(BuildContext context, WidgetRef ref) async {
    final prefs = ref.read(sharedPreferencesProvider);
    await showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle,
                  color: const Color(0xFFFF5252), size: 24.sp),
              SizedBox(width: 8.w),
              const Text('追加しました'),
            ],
          ),
          actions: [
            TextButton(
              child:
                  const Text('OK', style: TextStyle(color: Color(0xFFFF5252))),
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

  Future _showErrorDialog(String error, BuildContext context) async {
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
          content: Padding(
            padding: EdgeInsets.only(top: 12.h),
            child: Text(error),
          ),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        );
      },
    );
  }
}
