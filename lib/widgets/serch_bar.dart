import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SerchBar extends StatelessWidget {
  SerchBar({required this.onChanged, required this.hintText, super.key});
  final void Function(String)? onChanged;
  String hintText;

  @override
  Widget build(BuildContext context) {
    return CupertinoSearchTextField(
      itemSize: 25.sp,
      style: TextStyle(fontSize: 20.sp),
      placeholder: hintText,
      backgroundColor: Colors.white,
      onChanged: onChanged,
    );
  }
}
