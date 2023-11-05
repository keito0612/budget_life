import 'package:budget/provider/chart_date_provider.dart';
import 'package:budget/provider/expense_chart_provider.dart';
import 'package:budget/provider/income_chart_provider.dart';
import 'package:budget/utils/util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graphic/graphic.dart';
import 'package:path/path.dart';
import 'package:pie_chart/pie_chart.dart';

final chartCupertinoSlidingValueProvider = StateProvider.autoDispose((ref) {
  return 0;
});

class ChartPage extends ConsumerWidget {
  const ChartPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.green,
        title: const Text("分析", style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _chartContainerWidget(context, ref),
              _categoryListWidget(ref)
            ],
          ),
        ),
      ),
    );
  }

  Widget _chartCupertinoSlidingWidget(WidgetRef ref) {
    final cupertinoSlidingValue = ref.watch(chartCupertinoSlidingValueProvider);
    final cupertinoSlidingValueController =
        ref.read(chartCupertinoSlidingValueProvider.notifier);
    return Padding(
      padding: EdgeInsets.only(bottom: 25.h),
      child: SizedBox(
        width: 300.w,
        child: CupertinoSlidingSegmentedControl(
          children: {
            0: Text(
              "支出",
              style: TextStyle(
                color: cupertinoSlidingValue == 0 ? Colors.green : Colors.white,
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
                fontFamily: "SFProRounded",
              ),
              textAlign: TextAlign.center,
            ),
            1: Text(
              "収入",
              style: TextStyle(
                color: cupertinoSlidingValue == 1 ? Colors.green : Colors.white,
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
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
        ),
      ),
    );
  }

  Widget _chartDateWidget(BuildContext context, WidgetRef ref) {
    final chartDate = ref.watch(chartDateProvider);
    final chartDateController = ref.read(chartDateProvider.notifier);
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(right: 10.w),
            child: IconButton(
              onPressed: () {
                chartDateController.decrementDate();
              },
              icon: Icon(
                Icons.chevron_left,
                color: Colors.green,
                size: 30.sp,
              ),
            ),
          ),
          Text(Util.toDate2(chartDate),
              style: TextStyle(
                  fontSize: 20.sp,
                  color: Colors.green,
                  fontWeight: FontWeight.bold)),
          Padding(
            padding: EdgeInsets.only(left: 10.w),
            child: IconButton(
              onPressed: () {
                chartDateController.incrementChartDate();
              },
              icon: Icon(
                Icons.chevron_right,
                color: Colors.green,
                size: 30.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _chartContainerWidget(BuildContext context, WidgetRef ref) {
    final incomeChartData = ref.watch(incomeChartProvider);
    final cupertinoSlidingValue = ref.watch(chartCupertinoSlidingValueProvider);
    final expeneseChartData = ref.watch(expenseChartProvider);
    final expenseChartColors = ref.watch(expenseChartProvider);
    final chartDate = ref.watch(chartDateProvider);
    late List<Color> colorList;
    late int totalAmount;

    if (cupertinoSlidingValue == 0) {
      if (expenseChartColors.colorList[Util.toDate2(chartDate)] != null) {
        colorList = expenseChartColors.colorList[Util.toDate2(chartDate)]!
            .map((color) => Color(color))
            .toList();
      } else {
        colorList = [];
      }
      if (expeneseChartData.totalAmount[Util.toDate2(chartDate)] != null) {
        totalAmount = expeneseChartData.totalAmount[Util.toDate2(chartDate)]!;
      }
    } else {
      if (incomeChartData.colorList[Util.toDate2(chartDate)] != null) {
        colorList = incomeChartData.colorList[Util.toDate2(chartDate)]!
            .map((color) => Color(color))
            .toList();
      } else {
        colorList = [];
      }
      if (incomeChartData.totalAmount[Util.toDate2(chartDate)] != null) {
        totalAmount = incomeChartData.totalAmount[Util.toDate2(chartDate)]!;
      }
    }

    if (cupertinoSlidingValue == 0) {
      return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: Column(
              children: [
                _chartDateWidget(context, ref),
                _chartCupertinoSlidingWidget(ref),
                Center(
                    child: expeneseChartData.expense[Util.toDate2(chartDate)] !=
                            null
                        ? PieChart(
                            dataMap: expeneseChartData
                                .expense[Util.toDate2(chartDate)]!,
                            animationDuration:
                                const Duration(milliseconds: 800),
                            chartLegendSpacing: 32.w,
                            chartRadius:
                                MediaQuery.of(context).size.width / 3.2,
                            colorList: colorList,
                            initialAngleInDegree: 0,
                            chartType: ChartType.ring,
                            ringStrokeWidth: 32.w,
                            centerText: "支出",
                            centerTextStyle: const TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold),
                            emptyColor: Colors.green,
                            legendOptions: const LegendOptions(
                              showLegendsInRow: false,
                              legendPosition: LegendPosition.right,
                              showLegends: true,
                              legendShape: BoxShape.circle,
                              legendTextStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            chartValuesOptions: const ChartValuesOptions(
                              showChartValueBackground: false,
                              showChartValues: false,
                              showChartValuesInPercentage: false,
                              showChartValuesOutside: false,
                              decimalPlaces: 1,
                            ),
                            // gradientList: ---To add gradient colors---
                            // emptyColorGradient: ---Empty Color gradient---
                          )
                        : Padding(
                            padding:
                                const EdgeInsets.only(top: 80, bottom: 100),
                            child: Text("現在支出はありません。",
                                style: TextStyle(
                                    fontSize: 20.sp,
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold)),
                          )),
                expeneseChartData.expense[Util.toDate2(chartDate)] != null
                    ? Padding(
                        padding: EdgeInsets.only(
                            top: 30.h, left: 20.w, right: 10.w, bottom: 10.h),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("合計支出:",
                                  style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.sp)),
                              Text(totalAmount.toString(),
                                  style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.sp))
                            ]),
                      )
                    : const SizedBox()
              ],
            )),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: Column(
              children: [
                _chartDateWidget(context, ref),
                _chartCupertinoSlidingWidget(ref),
                Center(
                    child:
                        incomeChartData.income[Util.toDate2(chartDate)] != null
                            ? PieChart(
                                dataMap: incomeChartData
                                    .income[Util.toDate2(chartDate)]!,
                                animationDuration:
                                    const Duration(milliseconds: 800),
                                chartLegendSpacing: 32.w,
                                chartRadius:
                                    MediaQuery.of(context).size.width / 3.2,
                                colorList: colorList,
                                initialAngleInDegree: 0,
                                chartType: ChartType.ring,
                                ringStrokeWidth: 32.w,
                                centerText: "収入",
                                centerTextStyle: const TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold),
                                emptyColor: Colors.green,
                                legendOptions: const LegendOptions(
                                  showLegendsInRow: false,
                                  legendPosition: LegendPosition.right,
                                  showLegends: true,
                                  legendShape: BoxShape.circle,
                                  legendTextStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                chartValuesOptions: const ChartValuesOptions(
                                  showChartValueBackground: false,
                                  showChartValues: false,
                                  showChartValuesInPercentage: false,
                                  showChartValuesOutside: false,
                                  decimalPlaces: 1,
                                ),
                                // gradientList: ---To add gradient colors---
                                // emptyColorGradient: ---Empty Color gradient---
                              )
                            : Padding(
                                padding:
                                    const EdgeInsets.only(top: 80, bottom: 100),
                                child: Text("現在収入はありません。",
                                    style: TextStyle(
                                        fontSize: 20.sp,
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold)),
                              )),
                expeneseChartData.expense[Util.toDate2(chartDate)] != null
                    ? Padding(
                        padding: EdgeInsets.only(
                            top: 30.h, left: 20.w, right: 10.w, bottom: 10.h),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("合計収入:",
                                  style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.sp)),
                              Text(totalAmount.toString(),
                                  style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.sp))
                            ]),
                      )
                    : const SizedBox()
              ],
            )),
      );
    }
  }

  Widget _categoryListWidget(WidgetRef ref) {
    final expeneseChartData = ref.watch(expenseChartProvider).expense;
    final expenseChartColors = ref.watch(expenseChartProvider);
    final expenseChartIcons = ref.watch(expenseChartProvider);
    final incomeChartData = ref.watch(incomeChartProvider);
    final cupertinoSlidingValue = ref.watch(chartCupertinoSlidingValueProvider);
    final chartDate = ref.watch(chartDateProvider);
    late List<Color> colorList;
    late List<ChartData> chartDateList;
    late List<IconData> iconDataList;

    if (cupertinoSlidingValue == 0) {
      if (expenseChartColors.colorList[Util.toDate2(chartDate)] != null) {
        colorList = expenseChartColors.colorList[Util.toDate2(chartDate)]!
            .map((color) => Color(color))
            .toList();
      } else {
        colorList = [];
      }

      if (expenseChartIcons.iconList[Util.toDate2(chartDate)] != null) {
        iconDataList = expenseChartIcons.iconList[Util.toDate2(chartDate)]!
            .map((icon) => IconData(icon, fontFamily: 'MaterialIcons'))
            .toList();
      } else {
        iconDataList = [];
      }

      if (expeneseChartData[Util.toDate2(chartDate)] != null) {
        chartDateList = expeneseChartData[Util.toDate2(chartDate)]!
            .entries
            .map((expense) => ChartData(expense.key, expense.value))
            .toList();
      } else {
        chartDateList = [];
      }
    } else {
      if (incomeChartData.colorList[Util.toDate2(chartDate)] != null) {
        colorList = incomeChartData.colorList[Util.toDate2(chartDate)]!
            .map((color) => Color(color))
            .toList();
      } else {
        colorList = [];
      }

      if (incomeChartData.iconList[Util.toDate2(chartDate)] != null) {
        iconDataList = incomeChartData.iconList[Util.toDate2(chartDate)]!
            .map((icon) => IconData(icon, fontFamily: 'MaterialIcons'))
            .toList();
      } else {
        iconDataList = [];
      }

      if (incomeChartData.income[Util.toDate2(chartDate)] != null) {
        chartDateList = incomeChartData.income[Util.toDate2(chartDate)]!.entries
            .map((income) => ChartData(income.key, income.value))
            .toList();
      } else {
        chartDateList = [];
      }
    }

    return Padding(
        padding: const EdgeInsets.all(10),
        child: Container(
          width: 380.w,
          height: 200.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20.r)),
            color: Colors.white,
          ),
          child: SingleChildScrollView(
            child: ListView(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                children: chartDateList.asMap().entries.map((chart) {
                  int index = chart.key;
                  return ListTile(
                    leading: Icon(
                      iconDataList[index],
                      size: 25.sp,
                      color: colorList[index],
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(chart.value.category,
                            style: TextStyle(fontSize: 21.sp)),
                        Text(chart.value.amount.toInt().toString()),
                      ],
                    ),
                  );
                }).toList()),
          ),
        ));
  }
}

class ChartData {
  ChartData(this.category, this.amount);
  String category;
  double amount;
}
