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
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Transform.scale(
                scale: 1.0,
                child: CupertinoSwitch(
                  value: value,
                  onChanged: onChanged,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
