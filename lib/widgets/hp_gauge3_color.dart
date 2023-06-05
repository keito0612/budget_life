import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
          borderRadius: BorderRadius.all(Radius.circular(50.r)),
          border: Border.all(width: 5.w, color: Colors.black)),
      width: 350.w,
      height: 100.h,
      child: SizedBox(
        child: Padding(
          padding:
              EdgeInsets.only(top: 10.w, left: 20.w, right: 20.w, bottom: 10.h),
          child: Column(children: [
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    height: 25.h,
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10.r),
                            bottomLeft: Radius.circular(10.r))),
                    child: Center(
                      child: Text(
                        title,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15.sp),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: SizedBox(
                    height: 25.h,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(5),
                          bottomRight: Radius.circular(5)),
                      child: LinearProgressIndicator(
                        value: currentAmount / maxAmount,
                        valueColor: AlwaysStoppedAnimation(
                            getCurrentHpColor(currentAmount)),
                        backgroundColor: Colors.grey,
                        minHeight: 25.h,
                      ),
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
                    fontSize: 20.sp),
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
          borderRadius: BorderRadius.all(Radius.circular(50.r)),
          border: Border.all(width: 5.w, color: Colors.black)),
      width: 350.w,
      height: 100.h,
      child: SizedBox(
        child: Padding(
          padding:
              EdgeInsets.only(top: 10.h, left: 20.w, right: 20.w, bottom: 10.h),
          child: Column(children: [
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    height: 25.h,
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10.r),
                            bottomLeft: Radius.circular(10.r))),
                    child: Center(
                      child: Text(
                        title,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15.sp),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: SizedBox(
                    height: 25.h,
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(5.r),
                          bottomRight: Radius.circular(5.r)),
                      child: LinearProgressIndicator(
                        value: 0.0,
                        valueColor: AlwaysStoppedAnimation(
                            getCurrentHpColor(currentAmount)),
                        backgroundColor: Colors.grey,
                        minHeight: 25.h,
                      ),
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
                    fontSize: 20.sp),
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
