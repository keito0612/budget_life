import 'package:budget/page/fixed_expense/fixed_expense_page.dart';
import 'package:budget/page/recurring_income/recurring_income_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

final pageValueProvider = StateProvider.autoDispose((ref) => 0);

class fixedExpenseWithRecurringIncomeAddPage extends ConsumerWidget {
  const fixedExpenseWithRecurringIncomeAddPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageValue = ref.watch(pageValueProvider);
    final pageWidgets = [FixedExpensePage(), RecurringIncomePage()];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildHeader(context, ref, pageValue)),
            SliverToBoxAdapter(child: pageWidgets[pageValue]),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref, int pageValue) {
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
      child: Column(
        children: [
          Row(
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
              Icon(Icons.add_circle_outline, color: Colors.white, size: 28.sp),
              SizedBox(width: 12.w),
              Text(
                '新規追加',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          _buildSegmentControl(ref, pageValue),
        ],
      ),
    );
  }

  Widget _buildSegmentControl(WidgetRef ref, int pageValue) {
    final pageValueController = ref.read(pageValueProvider.notifier);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: CupertinoSlidingSegmentedControl<int>(
        children: {
          0: Container(
            padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.trending_down,
                  size: 18.sp,
                  color: pageValue == 0 ? const Color(0xFFFF5252) : Colors.white,
                ),
                SizedBox(width: 6.w),
                Text(
                  "固定支出",
                  style: TextStyle(
                    color: pageValue == 0 ? const Color(0xFFFF5252) : Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          1: Container(
            padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.trending_up,
                  size: 18.sp,
                  color: pageValue == 1 ? const Color(0xFF00C853) : Colors.white,
                ),
                SizedBox(width: 6.w),
                Text(
                  "定期収入",
                  style: TextStyle(
                    color: pageValue == 1 ? const Color(0xFF00C853) : Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        },
        groupValue: pageValue,
        onValueChanged: (index) {
          pageValueController.state = index!;
        },
        thumbColor: Colors.white,
        backgroundColor: Colors.transparent,
      ),
    );
  }
}
