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
    return Ink(
      child: ListTile(
        onTap: () {
          _showCupertinoDatePicker(context);
        },
        tileColor: Colors.white,
        title: Row(
          children: [
            Expanded(
              flex: 4,
              child: Text(
                title,
                style: TextStyle(fontSize: 20.sp),
              ),
            ),
            Expanded(
                flex: 1, child: Text(time, style: TextStyle(fontSize: 21.sp)))
          ],
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
