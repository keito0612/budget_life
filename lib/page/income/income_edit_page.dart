import 'package:budget/model/category/category.dart';
import 'package:budget/model/income/income.dart';
import 'package:budget/provider/shared_preferences_provider.dart';
import 'package:budget/utils/util.dart';
import 'package:budget/viewModels/category_income_model.dart';
import 'package:budget/widgets/category_bottom_sheet_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../viewModels/income_model.dart';
import '../../widgets/dateBar_widget.dart';

class IncomeEditPage extends ConsumerWidget {
  late final amountEditProvider = StateProvider.autoDispose((ref) => amount);
  late final memoEditProvider = StateProvider.autoDispose((ref) => memo);
  late final categoryEditProvider =
      StateProvider.autoDispose((ref) => categoryIndex);
  late final savingsAmountEditProvider =
      StateProvider.autoDispose((ref) => savingsAmount);
  late final walletCashAmountEditProvider =
      StateProvider.autoDispose((ref) => walletCashAmount);

  IncomeEditPage(
      {super.key,
      required this.id,
      required this.amount,
      required this.category,
      required this.memo,
      required this.categoryIndex,
      required this.savingsAmount,
      required this.walletCashAmount}) {
    amountTextEditingController.text = amount!;
    memoTextEditingController.text = memo!;
    savingsAmountTextEditingController.text = savingsAmount ?? "";
    walletCashAmountTextEditingController.text = walletCashAmount ?? "";
  }
  int? id;
  String? amount;
  Category? category;
  String? memo;
  int? categoryIndex;
  String? savingsAmount;
  String? walletCashAmount;
  TextEditingController amountTextEditingController = TextEditingController();
  TextEditingController memoTextEditingController = TextEditingController();
  TextEditingController savingsAmountTextEditingController = TextEditingController();
  TextEditingController walletCashAmountTextEditingController = TextEditingController();

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
            '収入編集',
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
                Icon(Icons.trending_up, color: Colors.white, size: 28.sp),
                SizedBox(width: 12.w),
                Text(
                  '収入情報',
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
                _buildWalletCashField(ref),
                SizedBox(height: 16.h),
                _buildSavingsField(ref),
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
    amount = ref.watch(amountEditProvider);
    final amountController = ref.read(amountEditProvider.notifier);
    return _buildInputContainer(
      label: '収入金額',
      icon: Icons.currency_yen,
      iconColor: const Color(0xFF00C853),
      child: TextField(
        controller: amountTextEditingController,
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF2D3748),
        ),
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
    );
  }

  Widget _buildWalletCashField(WidgetRef ref) {
    walletCashAmount = ref.watch(walletCashAmountEditProvider);
    final walletCashController = ref.read(walletCashAmountEditProvider.notifier);

    return _buildInputContainer(
      label: '財布に入れる金額（任意）',
      icon: Icons.account_balance_wallet,
      iconColor: const Color(0xFF5C6BC0),
      child: TextField(
        controller: walletCashAmountTextEditingController,
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
    savingsAmount = ref.watch(savingsAmountEditProvider);
    final savingsController = ref.read(savingsAmountEditProvider.notifier);

    return _buildInputContainer(
      label: '貯金に回す金額（任意）',
      icon: Icons.savings,
      iconColor: const Color(0xFFFFB300),
      child: TextField(
        controller: savingsAmountTextEditingController,
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
    final categoryIndex = ref.watch(categoryIncomeIndexProvider);
    final categorysIncome = ref.watch(categoryIncomeModelProvider);
    category = categorysIncome.categoryIncomes[categoryIndex];
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
                categorys: categorysIncome.categoryIncomes,
                onSelectedItemChanged: ((int index) {
                  ref.read(categoryIncomeIndexProvider.notifier).state = index;
                }),
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
    final incomeViewModel = ref.read(incomeViewModelProvider.notifier);
    final date = ref.watch(dateProvider);
    final incomeEditData = Income(
        id: id,
        amount: amount!,
        date: date,
        memo: memo!,
        category: category!.category,
        icon: category!.icon!,
        color: category!.color,
        savingsAmount: savingsAmount ?? "",
        walletCashAmount: walletCashAmount ?? "");
    try {
      await incomeViewModel.updateIncome(incomeEditData);
      await dialogResult(context, incomeViewModel, ref);
    } on Exception catch (e) {
      await dialogError(e.toString(), context);
    } catch (e) {
      await dialogError(e.toString(), context);
    }
  }

  Future dialogResult(
      BuildContext context, IncomeViewModel model, WidgetRef ref) async {
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
