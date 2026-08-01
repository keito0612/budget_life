import 'package:budget/firebase_auth/firebase_auth_excption_handler.dart';
import 'package:budget/page/account/account_create_page.dart';
import 'package:budget/repositorys/auth_repository.dart';
import 'package:budget/widgets/loading_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class forgotPasswordPage extends ConsumerWidget {
  forgotPasswordPage({super.key});
  String _email = "";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _email = ref.watch(emailProvider);
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildHeader(context)),
          SliverToBoxAdapter(child: _buildContent(context, ref)),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 60.h, 20.w, 24.h),
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
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20.sp),
            ),
          ),
          SizedBox(width: 16.w),
          Icon(Icons.lock_reset, color: Colors.white, size: 28.sp),
          SizedBox(width: 12.w),
          Text(
            'パスワード再設定',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          SizedBox(height: 32.h),
          _buildResetCard(context, ref),
        ],
      ),
    );
  }

  Widget _buildResetCard(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFFB300), Color(0xFFFFD54F)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24.r),
                topRight: Radius.circular(24.r),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.email_outlined, color: Colors.white, size: 28.sp),
                SizedBox(width: 12.w),
                Text(
                  'メール送信',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF8E1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: const Color(0xFFFFB300), size: 24.sp),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Text(
                          '登録したメールアドレスにパスワード再設定メールを送信します。',
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: const Color(0xFF5D4037),
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
                _buildEmailField(ref),
                SizedBox(height: 24.h),
                _buildResetButton(context, ref),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmailField(WidgetRef ref) {
    final emailController = ref.read(emailProvider.notifier);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 4.w, bottom: 8.h),
          child: Text(
            'メールアドレス',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF4A5568),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF7FAFC),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(14.w),
                child: Icon(Icons.email_outlined, size: 24.sp, color: const Color(0xFFFFB300)),
              ),
              Expanded(
                child: TextField(
                  style: TextStyle(fontSize: 16.sp, color: const Color(0xFF2D3748)),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'example@email.com',
                    hintStyle: TextStyle(color: const Color(0xFFA0AEC0), fontSize: 16.sp),
                    contentPadding: EdgeInsets.symmetric(vertical: 14.h),
                  ),
                  onChanged: (mailAddress) => emailController.state = mailAddress,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildResetButton(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: double.infinity,
      height: 56.h,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFFB300),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        ),
        onPressed: () async => await _passwordResetDialog(context, ref),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.send, size: 24.sp),
            SizedBox(width: 8.w),
            Text('再設定メールを送信', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Future _passwordResetDialog(BuildContext context, WidgetRef ref) async {
    final authRepository = ref.watch(authRepositoryImplProvider);
    LoadingWidget.easyLoadingShow();
    try {
      await authRepository.sendPasswordResetEmail(email: _email);
      LoadingWidget.easyLoadingDismiss();
      if (context.mounted) {
        await _showSuccessDialog(context);
        Navigator.of(context).pop();
      }
    } on FirebaseAuthException catch (e) {
      LoadingWidget.easyLoadingDismiss();
      final result = FirebaseAuthExceptionHandler.handleException(e);
      final errorMessage = FirebaseAuthExceptionHandler.exceptionMessage(result);
      if (context.mounted) await _showErrorDialog(errorMessage, context);
    } catch (e) {
      LoadingWidget.easyLoadingDismiss();
      if (context.mounted) await _showErrorDialog(e.toString(), context);
    }
  }

  Future _showSuccessDialog(BuildContext context) async {
    await showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, color: const Color(0xFF00C853), size: 24.sp),
            SizedBox(width: 8.w),
            const Text('送信完了'),
          ],
        ),
        content: Padding(
          padding: EdgeInsets.only(top: 12.h),
          child: const Text('パスワード再設定メールを送信しました。'),
        ),
        actions: [
          TextButton(
            child: const Text('OK', style: TextStyle(color: Color(0xFF00C853))),
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
      ),
    );
  }

  Future _showErrorDialog(String error, BuildContext context) async {
    await showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: Colors.red, size: 24.sp),
            SizedBox(width: 8.w),
            const Text('エラー'),
          ],
        ),
        content: Padding(padding: EdgeInsets.only(top: 12.h), child: Text(error)),
        actions: [
          TextButton(child: const Text('OK'), onPressed: () => Navigator.of(context).pop())
        ],
      ),
    );
  }
}
