import 'package:budget/page/expense/expense_page.dart';
import 'package:budget/page/income/income_page.dart';
import 'package:budget/widgets/common_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

final cupertinoSlidingValueProvider = StateProvider.autoDispose((ref) {
  return 0;
});

class InputPage extends ConsumerWidget {
  const InputPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(cupertinoSlidingValueProvider);
    List<Widget> pageWidget = [ExpensePage(), IncomePage()];

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F7FA),
        body: Column(
          children: [
            CommonHeader(
              title: '入力',
              icon: Icons.edit_note,
              child: _buildSegmentControl(ref, selectedIndex),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: pageWidget[selectedIndex],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSegmentControl(WidgetRef ref, int selectedIndex) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildSegmentButton(
              ref: ref,
              index: 0,
              selectedIndex: selectedIndex,
              icon: Icons.arrow_downward,
              label: '支出',
              activeColor: const Color(0xFFFF5252),
            ),
          ),
          Expanded(
            child: _buildSegmentButton(
              ref: ref,
              index: 1,
              selectedIndex: selectedIndex,
              icon: Icons.arrow_upward,
              label: '収入',
              activeColor: const Color(0xFF00C853),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSegmentButton({
    required WidgetRef ref,
    required int index,
    required int selectedIndex,
    required IconData icon,
    required String label,
    required Color activeColor,
  }) {
    final isSelected = selectedIndex == index;
    return GestureDetector(
      onTap: () {
        ref.read(cupertinoSlidingValueProvider.notifier).state = index;
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(10.r),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18.sp,
              color: isSelected ? activeColor : Colors.white.withValues(alpha: 0.8),
            ),
            SizedBox(width: 6.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? activeColor : Colors.white.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
