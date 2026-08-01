import 'package:budget/firebase_auth/firebase_auth_excption_handler.dart';
import 'package:budget/repositorys/auth_repository.dart';
import 'package:budget/widgets/loading_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

final isObscureProvider = StateProvider.autoDispose((ref) => false);
final passwordProvider = StateProvider.autoDispose((ref) => "");
final emailProvider = StateProvider.autoDispose((ref) => "");

class AccountCreatePage extends ConsumerWidget {
  AccountCreatePage({super.key});

  String _email = "";
  String _password = "";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _password = ref.watch(passwordProvider);
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
          Icon(Icons.person_add, color: Colors.white, size: 28.sp),
          SizedBox(width: 12.w),
          Text(
            'アカウント作成',
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
          _buildCreateCard(context, ref),
        ],
      ),
    );
  }

  Widget _buildCreateCard(BuildContext context, WidgetRef ref) {
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
                colors: [Color(0xFF00C853), Color(0xFF00E676)],
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
                Icon(Icons.person_add_alt, color: Colors.white, size: 28.sp),
                SizedBox(width: 12.w),
                Text(
                  '新規登録',
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
                _buildEmailField(ref),
                SizedBox(height: 16.h),
                _buildPasswordField(ref),
                SizedBox(height: 24.h),
                _buildCreateButton(context, ref),
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
                child: Icon(Icons.email_outlined, size: 24.sp, color: const Color(0xFF00C853)),
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

  Widget _buildPasswordField(WidgetRef ref) {
    final isObscure = ref.watch(isObscureProvider);
    final isObscureController = ref.read(isObscureProvider.notifier);
    final passwordController = ref.read(passwordProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 4.w, bottom: 8.h),
          child: Text(
            'パスワード',
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
                child: Icon(Icons.lock_outline, size: 24.sp, color: const Color(0xFF00C853)),
              ),
              Expanded(
                child: TextField(
                  style: TextStyle(fontSize: 16.sp, color: const Color(0xFF2D3748)),
                  obscureText: !isObscure,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'パスワードを入力',
                    hintStyle: TextStyle(color: const Color(0xFFA0AEC0), fontSize: 16.sp),
                    contentPadding: EdgeInsets.symmetric(vertical: 14.h),
                  ),
                  onChanged: (password) => passwordController.state = password,
                ),
              ),
              IconButton(
                icon: Icon(
                  isObscure ? Icons.visibility : Icons.visibility_off,
                  size: 22.sp,
                  color: const Color(0xFF718096),
                ),
                onPressed: () => isObscureController.state = !isObscureController.state,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCreateButton(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: double.infinity,
      height: 56.h,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF00C853),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        ),
        onPressed: () async => await _createDialog(context, ref),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle_outline, size: 24.sp),
            SizedBox(width: 8.w),
            Text('アカウント作成', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Future _createDialog(BuildContext context, WidgetRef ref) async {
    final authRepository = ref.watch(authRepositoryImplProvider);
    await LoadingWidget.easyLoadingShow();
    try {
      await authRepository.signUp(email: _email, password: _password);
      await LoadingWidget.easyLoadingDismiss();
      if (context.mounted) {
        await _showSuccessDialog(context);
        Navigator.of(context).pop();
      }
    } on FirebaseAuthException catch (e) {
      await LoadingWidget.easyLoadingDismiss();
      final result = FirebaseAuthExceptionHandler.handleException(e);
      final errorMessage = FirebaseAuthExceptionHandler.exceptionMessage(result);
      if (context.mounted) await _showErrorDialog(errorMessage, context);
    } catch (e) {
      await LoadingWidget.easyLoadingDismiss();
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
            const Text('完了'),
          ],
        ),
        content: Padding(
          padding: EdgeInsets.only(top: 12.h),
          child: const Text('アカウントを作成しました。'),
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
