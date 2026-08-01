import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommonHeader extends StatelessWidget {
  const CommonHeader({
    required this.title,
    required this.icon,
    this.trailing,
    this.child,
    super.key,
  });

  final String title;
  final IconData icon;
  final Widget? trailing;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 60.h, 20.w, child != null ? 20.h : 24.h),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF00C853), Color(0xFF00E676)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32.r),
          bottomRight: Radius.circular(32.r),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00C853).withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.white, size: 28.sp),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
          if (child != null) ...[
            SizedBox(height: 20.h),
            child!,
          ],
        ],
      ),
    );
  }
}
