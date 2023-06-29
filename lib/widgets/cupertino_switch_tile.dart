import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CupertinoSwitchTile extends StatelessWidget {
  const CupertinoSwitchTile({
    required this.title,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final bool value;
  final void Function(bool)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
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
        padding: EdgeInsets.only(
          left: 20.h,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              textAlign: TextAlign.start,
              title,
              style: TextStyle(fontSize: 20.sp),
            ),
            Container(
              height: 50.h,
              width: 50.w,
              child: Center(
                child: Transform.scale(
                  scale: 1.0.sp,
                  child: CupertinoSwitch(
                    value: value,
                    onChanged: onChanged,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
