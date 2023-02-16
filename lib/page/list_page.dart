import 'package:budget/model.dart';
import 'package:budget/page/expense_list_page.dart';
import 'package:budget/viewModels/expense_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final cupertinoSlidingListValueProvider = StateProvider.autoDispose((ref) => 0);

class ListPage extends ConsumerWidget {
  const ListPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cupertinoSliderValue = ref.watch(cupertinoSlidingListValueProvider);
    List<Widget> pageList = [ExpenseListPage()];
    return Scaffold(
        backgroundColor: Colors.grey,
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: cupertinoListSlidingWidget(ref),
        ),
        body: const ExpenseListPage());
  }

  Widget cupertinoListSlidingWidget(WidgetRef ref) {
    final cupertinoSlidingValue = ref.watch(cupertinoSlidingListValueProvider);
    final cupertinoSlidingValueController =
        ref.read(cupertinoSlidingListValueProvider.notifier);
    return CupertinoSlidingSegmentedControl(
      children: {
        0: Text(
          "支出",
          style: TextStyle(
            color: cupertinoSlidingValue == 0 ? Colors.black : Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w400,
            fontFamily: "SFProRounded",
          ),
          textAlign: TextAlign.center,
        ),
        1: Text(
          "収入",
          style: TextStyle(
            color: cupertinoSlidingValue == 1 ? Colors.black : Colors.white,
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
      thumbColor: Colors.green,
      backgroundColor: Colors.white,
    );
  }
}
