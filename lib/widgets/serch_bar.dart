import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SerchBar extends StatelessWidget {
  const SerchBar({required this.onChanged, required this.hintText, super.key});
  final void Function(String)? onChanged;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 1,
        ),
      ),
      child: CupertinoSearchTextField(
        itemSize: 22.sp,
        style: TextStyle(
          fontSize: 16.sp,
          color: const Color(0xFF2D3748),
        ),
        placeholder: hintText,
        placeholderStyle: TextStyle(
          fontSize: 15.sp,
          color: const Color(0xFFA0AEC0),
        ),
        backgroundColor: Colors.transparent,
        borderRadius: BorderRadius.circular(12.r),
        prefixInsets: EdgeInsets.only(left: 12.w),
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
        onChanged: onChanged,
      ),
    );
  }
}
