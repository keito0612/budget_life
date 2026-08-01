import 'package:budget/provider/chart_date_provider.dart';
import 'package:budget/provider/expense_chart_provider.dart';
import 'package:budget/provider/income_chart_provider.dart';
import 'package:budget/utils/util.dart';
import 'package:budget/widgets/common_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pie_chart/pie_chart.dart';

final chartCupertinoSlidingValueProvider = StateProvider.autoDispose((ref) {
  return 0;
});

class ChartPage extends ConsumerWidget {
  const ChartPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(
            child: CommonHeader(
              title: '分析',
              icon: Icons.pie_chart,
            ),
          ),
          SliverToBoxAdapter(
            child: _buildContent(context, ref),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          SizedBox(height: 8.h),
          _buildChartCard(context, ref),
          SizedBox(height: 16.h),
          _buildCategoryListCard(ref),
          SizedBox(height: 32.h),
        ],
      ),
    );
  }

  Widget _buildChartCard(BuildContext context, WidgetRef ref) {
    final incomeChartData = ref.watch(incomeChartProvider);
    final selectedIndex = ref.watch(chartCupertinoSlidingValueProvider);
    final expenseChartData = ref.watch(expenseChartProvider);
    final chartDate = ref.watch(chartDateProvider);

    late List<Color> colorList;
    late int totalAmount;
    late Map<String, double>? chartData;
    late String emptyMessage;
    late String totalLabel;
    late Color accentColor;

    if (selectedIndex == 0) {
      colorList = (expenseChartData.colorList[Util.toDate2(chartDate)] ?? [])
          .map((color) => Color(color))
          .toList();
      totalAmount = expenseChartData.totalAmount[Util.toDate2(chartDate)] ?? 0;
      chartData = expenseChartData.expense[Util.toDate2(chartDate)];
      emptyMessage = '支出データがありません';
      totalLabel = '合計支出';
      accentColor = const Color(0xFFFF5252);
    } else {
      colorList = (incomeChartData.colorList[Util.toDate2(chartDate)] ?? [])
          .map((color) => Color(color))
          .toList();
      totalAmount = incomeChartData.totalAmount[Util.toDate2(chartDate)] ?? 0;
      chartData = incomeChartData.income[Util.toDate2(chartDate)];
      emptyMessage = '収入データがありません';
      totalLabel = '合計収入';
      accentColor = const Color(0xFF00C853);
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildDateSelector(ref),
          _buildSegmentControl(ref, selectedIndex),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            child: chartData != null
                ? Column(
                    children: [
                      PieChart(
                        dataMap: chartData,
                        animationDuration: const Duration(milliseconds: 800),
                        chartLegendSpacing: 32.w,
                        chartRadius: MediaQuery.of(context).size.width / 3.2,
                        colorList: colorList.isEmpty ? [Colors.grey] : colorList,
                        initialAngleInDegree: 0,
                        chartType: ChartType.ring,
                        ringStrokeWidth: 32.w,
                        centerText: selectedIndex == 0 ? "支出" : "収入",
                        centerTextStyle: TextStyle(
                          fontSize: 15.sp,
                          color: accentColor,
                          fontWeight: FontWeight.bold,
                        ),
                        emptyColor: Colors.grey.shade300,
                        legendOptions: LegendOptions(
                          showLegendsInRow: false,
                          legendPosition: LegendPosition.right,
                          showLegends: true,
                          legendShape: BoxShape.circle,
                          legendTextStyle: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF2D3748),
                          ),
                        ),
                        chartValuesOptions: ChartValuesOptions(
                          chartValueStyle: TextStyle(fontSize: 14.sp),
                          showChartValueBackground: false,
                          showChartValues: false,
                          showChartValuesInPercentage: false,
                          showChartValuesOutside: false,
                          decimalPlaces: 1,
                        ),
                      ),
                      SizedBox(height: 24.h),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                        decoration: BoxDecoration(
                          color: accentColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              totalLabel,
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF2D3748),
                              ),
                            ),
                            Text(
                              '${_formatNumber(totalAmount)}円',
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                                color: accentColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : Container(
                    padding: EdgeInsets.symmetric(vertical: 48.h),
                    child: Column(
                      children: [
                        Icon(
                          Icons.pie_chart_outline,
                          size: 64.sp,
                          color: const Color(0xFFA0AEC0),
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          emptyMessage,
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: const Color(0xFF718096),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelector(WidgetRef ref) {
    final chartDate = ref.watch(chartDateProvider);
    final chartDateController = ref.read(chartDateProvider.notifier);

    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () => chartDateController.decrementDate(),
            child: Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: const Color(0xFFF7FAFC),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                Icons.chevron_left,
                color: const Color(0xFF00C853),
                size: 24.sp,
              ),
            ),
          ),
          SizedBox(width: 16.w),
          Text(
            Util.toDate2(chartDate),
            style: TextStyle(
              fontSize: 18.sp,
              color: const Color(0xFF2D3748),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 16.w),
          GestureDetector(
            onTap: () => chartDateController.incrementChartDate(),
            child: Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: const Color(0xFFF7FAFC),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                Icons.chevron_right,
                color: const Color(0xFF00C853),
                size: 24.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSegmentControl(WidgetRef ref, int selectedIndex) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAFC),
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
        ref.read(chartCupertinoSlidingValueProvider.notifier).state = index;
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
              color: isSelected ? activeColor : const Color(0xFF718096),
            ),
            SizedBox(width: 6.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? activeColor : const Color(0xFF718096),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryListCard(WidgetRef ref) {
    final expenseChartData = ref.watch(expenseChartProvider);
    final incomeChartData = ref.watch(incomeChartProvider);
    final selectedIndex = ref.watch(chartCupertinoSlidingValueProvider);
    final chartDate = ref.watch(chartDateProvider);

    late List<Color> colorList;
    late List<ChartData> chartDataList;
    late List<IconData> iconDataList;
    late String title;

    if (selectedIndex == 0) {
      colorList = (expenseChartData.colorList[Util.toDate2(chartDate)] ?? [])
          .map((color) => Color(color))
          .toList();
      iconDataList = (expenseChartData.iconList[Util.toDate2(chartDate)] ?? [])
          .map((icon) => IconData(icon, fontFamily: 'MaterialIcons'))
          .toList();
      chartDataList = (expenseChartData.expense[Util.toDate2(chartDate)] ?? {})
          .entries
          .map((e) => ChartData(e.key, e.value))
          .toList();
      title = 'カテゴリー別支出';
    } else {
      colorList = (incomeChartData.colorList[Util.toDate2(chartDate)] ?? [])
          .map((color) => Color(color))
          .toList();
      iconDataList = (incomeChartData.iconList[Util.toDate2(chartDate)] ?? [])
          .map((icon) => IconData(icon, fontFamily: 'MaterialIcons'))
          .toList();
      chartDataList = (incomeChartData.income[Util.toDate2(chartDate)] ?? {})
          .entries
          .map((e) => ChartData(e.key, e.value))
          .toList();
      title = 'カテゴリー別収入';
    }

    if (chartDataList.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF2D3748),
              ),
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE2E8F0)),
          ListView.separated(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: chartDataList.length,
            separatorBuilder: (context, index) => Padding(
              padding: EdgeInsets.only(left: 64.w),
              child: const Divider(height: 1, color: Color(0xFFE2E8F0)),
            ),
            itemBuilder: (context, index) {
              final data = chartDataList[index];
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10.w),
                      decoration: BoxDecoration(
                        color: colorList[index].withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Icon(
                        iconDataList[index],
                        size: 22.sp,
                        color: colorList[index],
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: Text(
                        data.category,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF2D3748),
                        ),
                      ),
                    ),
                    Text(
                      '${_formatNumber(data.amount.toInt())}円',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF2D3748),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }
}

class ChartData {
  ChartData(this.category, this.amount);
  String category;
  double amount;
}
