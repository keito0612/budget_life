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
        backgroundColor: Colors.grey,
        appBar: AppBar(
            backgroundColor: Colors.green,
            iconTheme: const IconThemeData(color: Colors.white),
            title: _cupertinoListSlidingWidget(ref, pageValue)),
        body: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: pageWidgets[pageValue]));
  }

  Widget _cupertinoListSlidingWidget(WidgetRef ref, int pageValue) {
    final pageValue = ref.watch(pageValueProvider);
    final pageValueController = ref.read(pageValueProvider.notifier);

    return SizedBox(
      width: 200.sp,
      child: CupertinoSlidingSegmentedControl(
        children: {
          0: Text(
            "支出",
            style: TextStyle(
              color: pageValue == 0 ? Colors.green : Colors.white,
              fontSize: 15.sp,
              fontWeight: FontWeight.w400,
              fontFamily: "SFProRounded",
            ),
            textAlign: TextAlign.center,
          ),
          1: Text(
            "収入",
            style: TextStyle(
              color: pageValue == 1 ? Colors.green : Colors.white,
              fontSize: 15.sp,
              fontWeight: FontWeight.w400,
              fontFamily: "SFProRounded",
            ),
            textAlign: TextAlign.center,
          ),
        },
        groupValue: pageValue,
        onValueChanged: (index) {
          pageValueController.state = index!;
        },
        thumbColor: Colors.white,
        backgroundColor: Colors.green,
      ),
    );
  }
}
