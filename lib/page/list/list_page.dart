import 'package:budget/page/expense/expense_list_page.dart';
import 'package:budget/page/income/income_list_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final cupertinoSlidingListValueProvider = StateProvider.autoDispose((ref) => 0);

class ListPage extends ConsumerWidget {
  const ListPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cupertinoSliderValue = ref.watch(cupertinoSlidingListValueProvider);
    List<Widget> pageList = const [ExpenseListPage(), IncomeListPage()];
    return Scaffold(
        backgroundColor: Colors.grey,
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: _cupertinoListSlidingWidget(ref),
        ),
        body: SingleChildScrollView(child: pageList[cupertinoSliderValue]));
  }

  Widget _cupertinoListSlidingWidget(WidgetRef ref) {
    final cupertinoSlidingValue = ref.watch(cupertinoSlidingListValueProvider);
    final cupertinoSlidingValueController =
        ref.read(cupertinoSlidingListValueProvider.notifier);
    return CupertinoSlidingSegmentedControl(
      children: {
        0: Text(
          "支出",
          style: TextStyle(
            color: cupertinoSlidingValue == 0 ? Colors.green : Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w400,
            fontFamily: "SFProRounded",
          ),
          textAlign: TextAlign.center,
        ),
        1: Text(
          "収入",
          style: TextStyle(
            color: cupertinoSlidingValue == 1 ? Colors.green : Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w400,
            fontFamily: "SFProRounded",
          ),
          textAlign: TextAlign.center,
        ),
      },
      groupValue: cupertinoSlidingValue,
      onValueChanged: (index) {
        cupertinoSlidingValueController.state = index!;
      },
      thumbColor: Colors.white,
      backgroundColor: Colors.green,
    );
  }
}
