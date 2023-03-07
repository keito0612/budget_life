import 'package:budget/page/expense/expense_page.dart';
import 'package:budget/page/income_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final cupertinoSlidingValueProvider = StateProvider.autoDispose((ref) {
  return 0;
});

class InputPage extends ConsumerWidget {
  const InputPage({
    super.key,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cupertinoSlidingValue = ref.watch(cupertinoSlidingValueProvider);
    List<Widget> pageWidget = [ExpensePage(), IncomePage()];

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
          backgroundColor: Colors.grey,
          appBar: AppBar(
            backgroundColor: Colors.green,
            title: cupertinoSlidingWidget(ref),
          ),
          body: pageWidget[cupertinoSlidingValue]),
    );
  }

  Widget cupertinoSlidingWidget(WidgetRef ref) {
    final cupertinoSlidingValue = ref.watch(cupertinoSlidingValueProvider);
    final cupertinoSlidingValueController =
        ref.read(cupertinoSlidingValueProvider.notifier);
    return CupertinoSlidingSegmentedControl(
      children: {
        0: Text(
          "支出",
          style: TextStyle(
            color:
                cupertinoSlidingValue == 0 ? Colors.lightGreen : Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w400,
            fontFamily: "SFProRounded",
          ),
          textAlign: TextAlign.center,
        ),
        1: Text(
          "収入",
          style: TextStyle(
            color:
                cupertinoSlidingValue == 1 ? Colors.lightGreen : Colors.white,
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
      backgroundColor: Colors.lightGreen,
    );
  }
}
