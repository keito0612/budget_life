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
          Center(
            child: Text(
              title,
              style: TextStyle(fontSize: 25.sp),
            ),
          ),
        ],
      ),
      trailing: Container(
        width: 70.h,
        height: 70.h,
        child: Center(
          child: Transform.scale(
            scale: 1.1.sp,
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
