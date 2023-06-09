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
    return ListTile(
      leading: null,
      title: Row(
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 20.sp),
          ),
        ],
      ),
      trailing: Container(
        height: 60.h,
        width: 60.w,
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
    );
  }
}
