import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WalletBalanceCard extends StatelessWidget {
  const WalletBalanceCard({
    required this.currentAmount,
    required this.maxAmount,
    Key? key,
  }) : super(key: key);

  final int currentAmount;
  final int maxAmount;

  @override
  Widget build(BuildContext context) {
    double progress;
    int displayMaxAmount = maxAmount;

    if (maxAmount == 0 && currentAmount == 0) {
      progress = 0.0;
    } else if (maxAmount < currentAmount) {
      displayMaxAmount = currentAmount;
      progress = 1.0;
    } else if (maxAmount == 0) {
      progress = 0.0;
    } else {
      progress = currentAmount / maxAmount;
    }

    return _buildCard(context, progress, displayMaxAmount);
  }

  Widget _buildCard(BuildContext context, double progress, int displayMaxAmount) {
    final gaugeColor = _getGaugeColor(progress);
    final formattedCurrent = _formatNumber(currentAmount);
    final formattedMax = _formatNumber(displayMaxAmount);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: gaugeColor.withValues(alpha:0.2),
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
                      child: Row(
                        children: [
                          Icon(
                            Icons.account_balance_wallet,
                            color: Colors.white,
                            size: 16.sp,
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            '財布',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
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
                        color: gaugeColor.withValues(alpha:0.4),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
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
