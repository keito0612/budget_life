import 'package:budget/utils/util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CupertinoTimePikerTile extends ConsumerWidget {
  CupertinoTimePikerTile(
      {required this.title,
      required this.time,
      required this.onDateTimeChanged});

  final String title;
  final String time;
  final void Function(DateTime) onDateTimeChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () {
        _showCupertinoDatePicker(context);
      },
      child: Container(
        height: 70.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(50.r)),
          boxShadow: [
            BoxShadow(
              color: Colors.black38,
              offset: Offset(2.0.r, 2.0.r),
              blurRadius: 4.0.r,
              spreadRadius: 4.0.r,
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.only(left: 10.w, right: 20.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 20.sp),
              ),
              Text(time, style: TextStyle(fontSize: 21.sp))
            ],
          ),
        ),
      ),
    );
  }

  void _showCupertinoDatePicker(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height / 3,
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Column(
              children: [
                TextButton(
                    style: TextButton.styleFrom(
                      splashFactory: NoSplash.splashFactory,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "閉じる",
                      style: TextStyle(fontSize: 20.sp),
                    )),
                SizedBox(
                    height: 200.h,
                    child: CupertinoDatePicker(
                        initialDateTime: Util.convartDateToTime(time),
                        use24hFormat: true,
                        mode: CupertinoDatePickerMode.time,
                        onDateTimeChanged: onDateTimeChanged)),
              ],
            ),
          ),
        );
      },
    );
  }
}
