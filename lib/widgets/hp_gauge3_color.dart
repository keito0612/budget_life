import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HpGauge3Color extends StatelessWidget {
  HpGauge3Color({
    required this.currentAmount,
    required this.maxAmount,
    required this.title,
    Key? key,
  }) : super(key: key);

  int currentAmount;
  int maxAmount;
  final String title;

  @override
  Widget build(BuildContext context) {
    if (maxAmount < currentAmount) {
      maxAmount = currentAmount;
    }
    if (maxAmount == 0 && currentAmount == 0) {
      return _buildGauge(context, 0.0);
    } else {
      return _buildGauge(context, currentAmount / maxAmount);
    }
  }

  Widget _buildGauge(BuildContext context, double progress) {
    final gaugeColor = _getGaugeColor(progress);
    final formattedCurrent = _formatNumber(currentAmount);
    final formattedMax = _formatNumber(maxAmount);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: gaugeColor.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // タイトルと金額
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color: gaugeColor,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        title,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    _buildStatusIcon(progress),
                  ],
                ),
                Text(
                  '$formattedCurrent円',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22.sp,
                    color: gaugeColor,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            // プログレスバー
            Stack(
              children: [
                Container(
                  height: 16.h,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOutCubic,
                  height: 16.h,
                  width: (MediaQuery.of(context).size.width - 72.w) * progress.clamp(0.0, 1.0),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: _getGradientColors(progress),
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(8.r),
                    boxShadow: [
                      BoxShadow(
                        color: gaugeColor.withOpacity(0.4),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            // 設定金額
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  '設定額: $formattedMax円',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey.shade600,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIcon(double progress) {
    IconData icon;
    Color color;

    if (progress > 0.5) {
      icon = Icons.sentiment_very_satisfied;
      color = const Color(0xFF00C853);
    } else if (progress > 0.2) {
      icon = Icons.sentiment_neutral;
      color = const Color(0xFFFFB300);
    } else {
      icon = Icons.sentiment_very_dissatisfied;
      color = const Color(0xFFFF5252);
    }

    return Icon(icon, color: color, size: 24.sp);
  }

  Color _getGaugeColor(double progress) {
    if (progress > 0.5) {
      return const Color(0xFF00C853);
    } else if (progress > 0.2) {
      return const Color(0xFFFFB300);
    }
    return const Color(0xFFFF5252);
  }

  List<Color> _getGradientColors(double progress) {
    if (progress > 0.5) {
      return [const Color(0xFF00E676), const Color(0xFF00C853)];
    } else if (progress > 0.2) {
      return [const Color(0xFFFFD54F), const Color(0xFFFFB300)];
    }
    return [const Color(0xFFFF8A80), const Color(0xFFFF5252)];
  }

  String _formatNumber(int number) {
    if (number >= 10000) {
      return '${(number / 10000).toStringAsFixed(1)}万';
    }
    return number.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }
}
