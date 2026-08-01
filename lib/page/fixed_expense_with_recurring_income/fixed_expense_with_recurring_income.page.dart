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
      backgroundColor: const Color(0xFFF5F7FA),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildHeader(context)),
          SliverToBoxAdapter(child: _buildContent(context, ref)),
        ],
      ),
      floatingActionButton: Container(
        width: 60.sp,
        height: 60.sp,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF00C853), Color(0xFF00E676)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF00C853).withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: FloatingActionButton(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Icon(Icons.add, color: Colors.white, size: 28.sp),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                fullscreenDialog: true,
                builder: (context) => const fixedExpenseWithRecurringIncomeAddPage(),
              ),
            );
          },
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
          Icon(Icons.repeat, color: Colors.white, size: 28.sp),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              '固定費・定期収入',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
              ),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 8.h),
          _buildSectionLabel('固定支出', const Color(0xFFFF5252)),
          SizedBox(height: 12.h),
          _buildFixedExpenseCard(ref, context),
          SizedBox(height: 24.h),
          _buildSectionLabel('定期収入', const Color(0xFF00C853)),
          SizedBox(height: 12.h),
          _buildRecurringIncomeCard(ref, context),
          SizedBox(height: 80.h),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String text, Color color) {
    return Row(
      children: [
        Container(
          width: 4.w,
          height: 24.h,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2.r),
          ),
        ),
        SizedBox(width: 12.w),
        Text(
          text,
          style: TextStyle(
            color: const Color(0xFF2D3748),
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildFixedExpenseCard(WidgetRef ref, BuildContext context) {
    final fixedExpenses = ref.watch(fixedExpenseViewModelProvider);
    final fixedExpenseModel = ref.read(fixedExpenseViewModelProvider.notifier);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: fixedExpenses.fixedExpenses.isEmpty
          ? Padding(
              padding: EdgeInsets.all(24.w),
              child: Center(
                child: Text(
                  '固定支出がありません',
                  style: TextStyle(
                    color: const Color(0xFFA0AEC0),
                    fontSize: 14.sp,
                  ),
                ),
              ),
            )
          : ListView.separated(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: fixedExpenses.fixedExpenses.length,
              separatorBuilder: (context, index) => Divider(
                height: 1,
                color: const Color(0xFFE2E8F0),
                indent: 16.w,
                endIndent: 16.w,
              ),
              itemBuilder: (context, index) {
                final expense = fixedExpenses.fixedExpenses[index];
                return _buildExpenseItem(context, fixedExpenseModel, expense);
              },
            ),
    );
  }

  Widget _buildExpenseItem(
      BuildContext context, FixedExpenseModel model, FixedExpense expense) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            backgroundColor: const Color(0xFF718096),
            foregroundColor: Colors.white,
            icon: Icons.edit,
            label: '編集',
            onPressed: (context) async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FixedExpenseEditPage(
                    id: expense.id!,
                    amount: expense.amount,
                    category: Category(
                      category: expense.category!,
                      icon: expense.icon,
                      color: expense.color,
                    ),
                    memo: expense.memo,
                    autoMaticInputDate: expense.autoMaticInputDate,
                    autoMaticInputDateIndex: expense.autoMaticInuputDateIndex,
                    autoMaticInputDay: expense.autoMaticInputDay,
                    categoryExpenseIndex: expense.categoryIndex,
                  ),
                ),
              );
            },
          ),
          SlidableAction(
            backgroundColor: const Color(0xFFFF5252),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: '削除',
            onPressed: (context) async {
              model.deleteExpense(expense.id!);
            },
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: Color(expense.color!).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                IconData(expense.icon!, fontFamily: 'MaterialIcons'),
                color: Color(expense.color!),
                size: 24.sp,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    expense.category!,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF2D3748),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    expense.autoMaticInputDate ?? '',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: const Color(0xFF718096),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '¥${expense.amount}',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFFFF5252),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecurringIncomeCard(WidgetRef ref, BuildContext context) {
    final recurringIncomes = ref.watch(recurringIncomeViewModelProvider);
    final recurringIncomeModel = ref.read(recurringIncomeViewModelProvider.notifier);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: recurringIncomes.recurringIncomes.isEmpty
          ? Padding(
              padding: EdgeInsets.all(24.w),
              child: Center(
                child: Text(
                  '定期収入がありません',
                  style: TextStyle(
                    color: const Color(0xFFA0AEC0),
                    fontSize: 14.sp,
                  ),
                ),
              ),
            )
          : ListView.separated(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: recurringIncomes.recurringIncomes.length,
              separatorBuilder: (context, index) => Divider(
                height: 1,
                color: const Color(0xFFE2E8F0),
                indent: 16.w,
                endIndent: 16.w,
              ),
              itemBuilder: (context, index) {
                final income = recurringIncomes.recurringIncomes[index];
                return _buildIncomeItem(context, recurringIncomeModel, income);
              },
            ),
    );
  }

  Widget _buildIncomeItem(
      BuildContext context, RecurringIncomeModel model, RecurringIncome income) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            backgroundColor: const Color(0xFF718096),
            foregroundColor: Colors.white,
            icon: Icons.edit,
            label: '編集',
            onPressed: (context) async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RecurringIncomeEditPage(
                    id: income.id!,
                    amount: income.amount,
                    category: Category(
                      category: income.category!,
                      icon: income.icon,
                      color: income.color,
                    ),
                    memo: income.memo,
                    autoMaticInputDate: income.autoMaticInputDate,
                    autoMaticInputDateIndex: income.autoMaticInuputDateIndex,
                    autoMaticInputDay: income.autoMaticInputDay,
                    categoryIncomeIndex: income.categoryIndex,
                  ),
                ),
              );
            },
          ),
          SlidableAction(
            backgroundColor: const Color(0xFFFF5252),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: '削除',
            onPressed: (context) async {
              model.deleteRecurringIncome(income.id!);
            },
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: Color(income.color!).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                IconData(income.icon!, fontFamily: 'MaterialIcons'),
                color: Color(income.color!),
                size: 24.sp,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    income.category!,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF2D3748),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    income.autoMaticInputDate ?? '',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: const Color(0xFF718096),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '¥${income.amount}',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF00C853),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
