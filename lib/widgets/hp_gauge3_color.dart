import 'package:budget/page/expense/expense_page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class HpGauge3Color extends StatelessWidget {
  HpGauge3Color(
      {required this.currentAmount,
      required this.maxAmount,
      required this.title,
      Key? key})
      : super(key: key);
  int currentAmount;
  int maxAmount;
  final String title;

  @override
  Widget build(BuildContext context) {
    if (maxAmount < currentAmount) {
      maxAmount = currentAmount;
      print("最大金額 :$maxAmount");
      print("残高: $currentAmount");
    }
    if (maxAmount == 0 && currentAmount == 0) {
      return zeroAmountGauge(title, currentAmount, maxAmount);
    } else {
      return amountGauge();
    }
  }

  Widget amountGauge() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(50)),
          border: Border.all(width: 5, color: Colors.black)),
      width: 350,
      height: 100,
      child: SizedBox(
        child: Padding(
          padding:
              const EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 10),
          child: Column(children: [
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    height: 25,
                    decoration: const BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomLeft: Radius.circular(10))),
                    child: Center(
                      child: Text(
                        title,
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(5),
                        bottomRight: Radius.circular(5)),
                    child: LinearProgressIndicator(
                      value: currentAmount / maxAmount,
                      valueColor: AlwaysStoppedAnimation(
                          getCurrentHpColor(currentAmount)),
                      backgroundColor: Colors.grey,
                      minHeight: 25,
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              flex: 1,
              child: Text(
                '${currentAmount.toString().padLeft(4, '  ')}/${maxAmount}円',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: getAmontTextColor(currentAmount),
                    fontSize: 20),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Widget zeroAmountGauge(String title, int currentAmount, int maxAmount) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(50)),
          border: Border.all(width: 5, color: Colors.black)),
      width: 350,
      height: 100,
      child: SizedBox(
        child: Padding(
          padding:
              const EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 10),
          child: Column(children: [
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    height: 25,
                    decoration: const BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomLeft: Radius.circular(10))),
                    child: Center(
                      child: Text(
                        title,
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(5),
                        bottomRight: Radius.circular(5)),
                    child: LinearProgressIndicator(
                      value: 0.0,
                      valueColor: AlwaysStoppedAnimation(
                          getCurrentHpColor(currentAmount)),
                      backgroundColor: Colors.grey,
                      minHeight: 25,
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              flex: 1,
              child: Text(
                '${currentAmount.toString().padLeft(4, '  ')}/${maxAmount}円',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: getAmontTextColor(currentAmount),
                    fontSize: 20),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Color getCurrentHpColor(int hp) {
    if (hp > maxAmount / 2) {
      return const Color(0xFF00D308);
    }
    if (hp > maxAmount / 5) {
      return const Color(0xFFFFC107);
    }
    return const Color(0xFFFF0707);
  }

  Color getAmontTextColor(int hp) {
    if (hp > maxAmount / 2) {
      return const Color(0xFF00D308);
    }
    if (hp > maxAmount / 5) {
      return const Color(0xFFFFC107);
    }
    return const Color(0xFFFF0707);
  }
}
