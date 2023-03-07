import 'package:flutter/material.dart';

class HpGauge3Color extends StatelessWidget {
  const HpGauge3Color(
      {required this.currentHp,
      required this.maxHp,
      required this.title,
      Key? key})
      : super(key: key);
  final int currentHp;
  final int maxHp;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(50)),
          border: Border.all(width: 5, color: Colors.black)),
      width: 350,
      height: 80,
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
                      value: currentHp / maxHp,
                      valueColor:
                          AlwaysStoppedAnimation(getCurrentHpColor(currentHp)),
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
                '${currentHp.toString().padLeft(4, '  ')}/${maxHp}円',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: getHpTextColor(currentHp),
                    fontSize: 20),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Color getCurrentHpColor(int hp) {
    if (hp > maxHp / 2) {
      return const Color(0xFF00D308);
    }
    if (hp > maxHp / 5) {
      return const Color(0xFFFFC107);
    }
    return const Color(0xFFFF0707);
  }

  Color getHpTextColor(int hp) {
    if (hp > maxHp / 2) {
      return const Color(0xFF00D308);
    }
    if (hp > maxHp / 5) {
      return const Color(0xFFFFC107);
    }
    return const Color(0xFFFF0707);
  }
}
