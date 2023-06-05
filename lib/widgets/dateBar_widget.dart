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
  //翌日
  void _incrementDate(WidgetRef ref) {
    initializeDateFormatting("ja");
    _toDay = _toDay.add(const Duration(days: 1));
    final nextDay = _toDay;
    final formattedDate = DateFormat.yMMMMEEEEd('ja').format(nextDay);
    ref.read(dateProvider.notifier).state = formattedDate;
  }

  //前日
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
      padding:
          EdgeInsets.only(top: 25.h, bottom: 12.h, right: 12.w, left: 12.w),
      child: Container(
        width: 380.w,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(25.0.r),
          color: Colors.green,
          boxShadow: [
            BoxShadow(
              color: Colors.black38,
              offset: Offset(2.0.r, 2.0.r),
              blurRadius: 4.0.r,
              spreadRadius: 4.0.r,
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 1.h),
              child: Container(
                child: Text(
                  "日付",
                  style: TextStyle(
                      fontSize: 25.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            TextButton(
                child: Text(date,
                    style: TextStyle(
                        fontSize: 30.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.bold)),
                onPressed: () async {
                  await showModalBottomSheet<void>(
                      context: context,
                      builder: (BuildContext context) => SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height / 3,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        '閉じる',
                                        style: TextStyle(
                                            fontSize: 20.sp,
                                            color: Colors.green),
                                      )),
                                ),
                                Expanded(
                                  child: CupertinoTheme(
                                    data: CupertinoThemeData(
                                        textTheme: CupertinoTextThemeData(
                                            dateTimePickerTextStyle:
                                                TextStyle(fontSize: 20.sp))),
                                    child: SizedBox(
                                      width: 300.w,
                                      child: CupertinoDatePicker(
                                        initialDateTime: _toDay,
                                        mode: CupertinoDatePickerMode.date,
                                        minimumDate: _toDay,
                                        maximumDate: DateTime.utc(2100, 12, 30),
                                        onDateTimeChanged: (value) {
                                          dateController.state =
                                              Util.toDate(value);
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ));
                }),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      EdgeInsets.only(left: 15.w, right: 200.w, bottom: 10.h),
                  child: SizedBox(
                    width: 70.w,
                    height: 40.h,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 10,
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          side: BorderSide(color: Colors.white, width: 3.w),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.r),
                          ),
                        ),
                        onPressed: () {
                          _decrementDate(ref);
                        },
                        child: Text("昨日",
                            style: TextStyle(
                                fontSize: 16.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.bold))),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10.h),
                  child: SizedBox(
                    width: 70.w,
                    height: 40.h,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 10,
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          side: BorderSide(color: Colors.white, width: 3.w),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.r),
                          ),
                        ),
                        onPressed: () {
                          _incrementDate(ref);
                        },
                        child: Text("翌日",
                            style: TextStyle(
                                fontSize: 16.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.bold))),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
