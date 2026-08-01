import 'package:budget/page/account/account_create_page.dart';
import 'package:budget/page/account/account_login_page.dart';
import 'package:budget/provider/firebase_provider.dart';
import 'package:budget/provider/reward_ad._provider.dart';
import 'package:budget/repositorys/accunt_repository.dart';
import 'package:budget/repositorys/auth_repository.dart';
import 'package:budget/widgets/loading_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AccountPage extends ConsumerWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userStateProvider);
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: _buildHeader(context),
          ),
          SliverToBoxAdapter(
            child: userState.when(
              data: (user) {
                if (user != null) {
                  return _buildLoggedInContent(context, ref, user);
                } else {
                  return _buildSignInContent(context);
                }
              },
              error: (error, stackTrace) => Center(
                child: Padding(
                  padding: EdgeInsets.all(32.w),
                  child: Text(
                    "エラー: $error",
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: const Color(0xFFFF5252),
                    ),
                  ),
                ),
              ),
              loading: () => Padding(
                padding: EdgeInsets.all(32.w),
                child: const Center(
                  child: CircularProgressIndicator(color: Color(0xFF00C853)),
                ),
              ),
            ),
          ),
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
          Icon(Icons.person, color: Colors.white, size: 28.sp),
          SizedBox(width: 12.w),
          Text(
            'アカウント',
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

  Widget _buildLoggedInContent(BuildContext context, WidgetRef ref, User user) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          SizedBox(height: 8.h),
          _buildUserCard(user),
          SizedBox(height: 24.h),
          _buildActionButtons(context, ref),
        ],
      ),
    );
  }

  Widget _buildUserCard(User user) {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: const Color(0xFF00C853).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(50.r),
            ),
            child: Icon(
              Icons.person,
              color: const Color(0xFF00C853),
              size: 32.sp,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ログイン中',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: const Color(0xFF718096),
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  user.email ?? 'メールアドレス未設定',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2D3748),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildActionButton(
            icon: Icons.sync,
            iconColor: const Color(0xFF42A5F5),
            title: 'データを同期する',
            onTap: () => _syncDialog(context, ref),
          ),
          _buildDivider(),
          _buildActionButton(
            icon: Icons.logout,
            iconColor: const Color(0xFFFFB300),
            title: 'サインアウト',
            onTap: () async {
              await ref.watch(authRepositoryImplProvider).signOut();
            },
          ),
          _buildDivider(),
          _buildActionButton(
            icon: Icons.delete_forever,
            iconColor: const Color(0xFFFF5252),
            title: '退会',
            titleColor: const Color(0xFFFF5252),
            onTap: () => _unsubscribeDialog(context, ref),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color iconColor,
    required String title,
    Color? titleColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(icon, color: iconColor, size: 22.sp),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: titleColor ?? const Color(0xFF2D3748),
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: const Color(0xFFA0AEC0),
                size: 24.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: EdgeInsets.only(left: 64.w),
      child: const Divider(height: 1, color: Color(0xFFE2E8F0)),
    );
  }

  Widget _buildSignInContent(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          SizedBox(height: 32.h),
          Container(
            padding: EdgeInsets.all(24.w),
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
                  padding: EdgeInsets.all(24.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00C853).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(50.r),
                  ),
                  child: Icon(
                    Icons.cloud,
                    color: const Color(0xFF00C853),
                    size: 64.sp,
                  ),
                ),
                SizedBox(height: 24.h),
                Text(
                  'データをバックアップ',
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF2D3748),
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'アカウントを作成してデータを安全に保存しましょう',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: const Color(0xFF718096),
                  ),
                ),
                SizedBox(height: 32.h),
                SizedBox(
                  width: double.infinity,
                  height: 56.h,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00C853),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AccountCreatePage()),
                      );
                    },
                    child: Text(
                      'アカウント作成',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                SizedBox(
                  width: double.infinity,
                  height: 56.h,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF00C853),
                      side: const BorderSide(color: Color(0xFF00C853), width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AccountLoginPage()),
                      );
                    },
                    child: Text(
                      'ログイン',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future _syncDialog(BuildContext context, WidgetRef ref) async {
    final rewardNotifier = ref.watch(rewardAdProvider.notifier)..loadRewardAd();
    final isLoaded = ref.read(rewardAdProvider).isLoaded;
    try {
      await LoadingWidget.easyDataSyncLoadingShow();
      if (!isLoaded) {
        await AccountRepository().dateSync(ref);
      } else {
        await rewardNotifier.showRewardAd(() async {
          await AccountRepository().dateSync(ref);
        });
      }
      await LoadingWidget.easyLoadingDismiss();
      if (context.mounted) {
        await _showSuccessDialog(context);
      }
    } on Exception catch (e) {
      await LoadingWidget.easyLoadingDismiss();
      if (context.mounted) {
        await _showErrorDialog(e.toString(), context);
      }
    } catch (e) {
      await LoadingWidget.easyLoadingDismiss();
      if (context.mounted) {
        await _showErrorDialog(e.toString(), context);
      }
    }
  }

  Future _showSuccessDialog(BuildContext context) async {
    await showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
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
            child: const Text('データを同期しました。'),
          ),
          actions: [
            TextButton(
              child: const Text('OK', style: TextStyle(color: Color(0xFF00C853))),
              onPressed: () async {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  Future _showErrorDialog(String error, BuildContext context) async {
    await showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, color: Colors.red, size: 24.sp),
              SizedBox(width: 8.w),
              const Text('エラー'),
            ],
          ),
          content: Padding(
            padding: EdgeInsets.only(top: 12.h),
            child: Text(error),
          ),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        );
      },
    );
  }

  Future _unsubscribeDialog(BuildContext context, WidgetRef ref) async {
    await showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.warning_amber_rounded, color: const Color(0xFFFFB300), size: 24.sp),
              SizedBox(width: 8.w),
              const Text('確認'),
            ],
          ),
          content: Padding(
            padding: EdgeInsets.only(top: 12.h),
            child: const Text(
              '退会するとアカウントはクラウドから削除され、使用できなくなります。',
              textAlign: TextAlign.center,
            ),
          ),
          actions: [
            TextButton(
              child: const Text('キャンセル'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('退会する', style: TextStyle(color: Colors.red)),
              onPressed: () async {
                await LoadingWidget.easyDataSyncLoadingShow();
                await AccountRepository.dateAllDelete(ref);
                await ref.watch(authRepositoryImplProvider).deleteUser();
                await LoadingWidget.easyLoadingDismiss();
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }
}
