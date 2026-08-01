import 'package:budget/utils/util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

final dateProvider = StateProvider.autoDispose((ref) {
  DateTime toDay = DateTime.now();
  initializeDateFormatting("ja");
  final formattedDate = DateFormat.yMMMMEEEEd('ja').format(toDay);
  return formattedDate;
});

class dateBarWidget extends ConsumerWidget {
  dateBarWidget({
    super.key,
  });

  DateTime _toDay = DateTime.now();

  void _incrementDate(WidgetRef ref) {
    initializeDateFormatting("ja");
    _toDay = _toDay.add(const Duration(days: 1));
    final nextDay = _toDay;
    final formattedDate = DateFormat.yMMMMEEEEd('ja').format(nextDay);
    ref.read(dateProvider.notifier).state = formattedDate;
  }

  void _decrementDate(WidgetRef ref) {
    initializeDateFormatting("ja");
    _toDay = _toDay.add(const Duration(days: 1) * -1);
    final previousDay = _toDay;
    final formattedDate = DateFormat.yMMMMEEEEd('ja').format(previousDay);
    ref.read(dateProvider.notifier).state = formattedDate;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final date = ref.watch(dateProvider);
    final dateController = ref.read(dateProvider.notifier);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Container(
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
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            children: [
              GestureDetector(
                onTap: () async {
                  await _showDatePicker(context, dateController);
                },
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7FAFC),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: const Color(0xFFE2E8F0),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.edit_calendar,
                        color: const Color(0xFF00C853),
                        size: 20.sp,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        date,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF2D3748),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              Row(
                children: [
                  Expanded(
                    child: _buildDateButton(
                      icon: Icons.chevron_left,
                      label: '昨日',
                      onPressed: () => _decrementDate(ref),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _buildDateButton(
                      icon: Icons.chevron_right,
                      label: '翌日',
                      onPressed: () => _incrementDate(ref),
                      isNext: true,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    bool isNext = false,
  }) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFF00C853),
        side: const BorderSide(color: Color(0xFF00C853), width: 1.5),
        padding: EdgeInsets.symmetric(vertical: 12.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: isNext
            ? [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: 4.w),
                Icon(icon, size: 20.sp),
              ]
            : [
                Icon(icon, size: 20.sp),
                SizedBox(width: 4.w),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
      ),
    );
  }

  Future<void> _showDatePicker(
      BuildContext context, StateController<String> dateController) async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (BuildContext context) => SizedBox(
        height: MediaQuery.of(context).size.height / 3,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Color(0xFFE2E8F0), width: 1),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '日付を選択',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF2D3748),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      '完了',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF00C853),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: CupertinoTheme(
                data: CupertinoThemeData(
                  textTheme: CupertinoTextThemeData(
                    dateTimePickerTextStyle: TextStyle(
                      fontSize: 18.sp,
                      color: const Color(0xFF2D3748),
                    ),
                  ),
                ),
                child: CupertinoDatePicker(
                  initialDateTime: _toDay,
                  mode: CupertinoDatePickerMode.date,
                  minimumDate: DateTime.utc(2020, 1, 1),
                  maximumDate: DateTime.utc(2100, 12, 30),
                  onDateTimeChanged: (value) {
                    _toDay = value;
                    dateController.state = Util.toDate(value);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
