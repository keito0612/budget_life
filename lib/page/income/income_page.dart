import 'package:budget/model/category/category.dart';
import 'package:budget/model/income/income.dart';
import 'package:budget/page/expense/expense_page.dart';
import 'package:budget/provider/shared_preferences_provider.dart';
import 'package:budget/utils/util.dart';
import 'package:budget/viewModels/balance_with_saving_model.dart';
import 'package:budget/viewModels/category_income_model.dart';
import 'package:budget/viewModels/income_model.dart';
import 'package:budget/widgets/category_bottom_sheet_bar.dart';
import 'package:budget/widgets/dateBar_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

final savingsAmountProvider = StateProvider.autoDispose((ref) => "");
final walletCashAmountProvider = StateProvider.autoDispose((ref) => "");

class IncomePage extends ConsumerWidget {
  IncomePage({super.key});
  String amount = "";
  String memo = "";
  String savingsAmount = "";
  String walletCashAmount = "";
  int categoryIncomeIndex = 0;
  Category? category;

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
                Icon(Icons.add_circle_outline,
                    color: Colors.white, size: 28.sp),
                SizedBox(width: 12.w),
                Text(
                  '収入を追加',
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
                _buildWalletCashField(ref),
                SizedBox(height: 16.h),
                _buildSavingsField(ref),
                SizedBox(height: 16.h),
                _buildCategoryField(context, ref),
                SizedBox(height: 16.h),
                _buildMemoField(),
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
      label: '収入金額',
      icon: Icons.currency_yen,
      iconColor: const Color(0xFF00C853),
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

  Widget _buildWalletCashField(WidgetRef ref) {
    walletCashAmount = ref.watch(walletCashAmountProvider);
    final walletCashController = ref.read(walletCashAmountProvider.notifier);

    return _buildInputContainer(
      label: '財布に入れる金額（任意）',
      icon: Icons.account_balance_wallet,
      iconColor: const Color(0xFF5C6BC0),
      child: TextField(
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF2D3748),
        ),
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        onChanged: (text) => walletCashController.state = text,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: '0',
          hintStyle: TextStyle(
            color: const Color(0xFFA0AEC0),
            fontSize: 16.sp,
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 14.h),
        ),
      ),
    );
  }

  Widget _buildSavingsField(WidgetRef ref) {
    savingsAmount = ref.watch(savingsAmountProvider);
    final savingsController = ref.read(savingsAmountProvider.notifier);

    return _buildInputContainer(
      label: '貯金に回す金額（任意）',
      icon: Icons.savings,
      iconColor: const Color(0xFFFFB300),
      child: TextField(
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF2D3748),
        ),
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        onChanged: (text) => savingsController.state = text,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: '0',
          hintStyle: TextStyle(
            color: const Color(0xFFA0AEC0),
            fontSize: 16.sp,
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 14.h),
        ),
      ),
    );
  }

  Widget _buildCategoryField(BuildContext context, WidgetRef ref) {
    categoryIncomeIndex = ref.watch(categoryIncomeIndexProvider);
    final categorys = ref.watch(categoryIncomeModelProvider);
    category = categorys.categoryIncomes[categoryIncomeIndex];

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
                  categorys: categorys.categoryIncomes,
                  onSelectedItemChanged: (int index) {
                    ref.read(categoryIncomeIndexProvider.notifier).state =
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

  Widget _buildMemoField() {
    return _buildInputContainer(
      label: 'メモ（任意）',
      icon: Icons.note_alt_outlined,
      child: TextField(
        style: TextStyle(
          fontSize: 16.sp,
          color: const Color(0xFF2D3748),
        ),
        onChanged: (text) => memo = text,
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
          backgroundColor: const Color(0xFF00C853),
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
    final incomeViewModel = ref.read(incomeViewModelProvider.notifier);
    final balanceModel = ref.read(balanceWithSavingModelProvider.notifier);
    final prefs = ref.read(sharedPreferencesProvider);
    final date = ref.read(dateProvider);
    final incomeAddData = Income(
      amount: amount,
      date: date,
      memo: memo,
      category: category!.category,
      icon: category!.icon,
      color: category!.color,
      categoryIndex: categoryIncomeIndex,
      savingsAmount: savingsAmount,
      walletCashAmount: walletCashAmount,
    );
    try {
      await incomeViewModel.addIncomes(incomeAddData);

      // 貯金に回す金額を追加
      if (savingsAmount.isNotEmpty) {
        final currentSavings = prefs.getInt("total_savings") ?? 0;
        final addedSavings = int.tryParse(savingsAmount) ?? 0;
        await prefs.setInt("total_savings", currentSavings + addedSavings);
      }

      // 財布に入れる金額を追加
      if (walletCashAmount.isNotEmpty) {
        final currentWalletCash = prefs.getInt("wallet_cash") ?? 0;
        final addedWalletCash = int.tryParse(walletCashAmount) ?? 0;
        await prefs.setInt("wallet_cash", currentWalletCash + addedWalletCash);
      }

      // 状態を更新
      await balanceModel.getBalanseWithSaving();

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
                  color: const Color(0xFF00C853), size: 24.sp),
              SizedBox(width: 8.w),
              const Text('追加しました'),
            ],
          ),
          actions: [
            TextButton(
              child:
                  const Text('OK', style: TextStyle(color: Color(0xFF00C853))),
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
