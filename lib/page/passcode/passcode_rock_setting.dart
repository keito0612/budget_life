import 'package:budget/provider/shared_preferences_provider.dart';
import 'package:budget/widgets/cupertino_switch_tile.dart';
import 'package:budget/widgets/passcode/passcode_lock_setting_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

final passcodeProvider =
    StateNotifierProvider.autoDispose<PasscodeNotifier, bool>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return PasscodeNotifier(prefs);
});
final faceProvider =
    StateNotifierProvider.autoDispose<FaceIdNotifier, bool>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return FaceIdNotifier(prefs);
});

class PasscodeNotifier extends StateNotifier<bool> {
  PasscodeNotifier(
    this._prefs,
  ) : super(false) {
    getPasscode();
  }

  final SharedPreferences _prefs;

  void setPasscode(bool isOn) {
    state = isOn;
    _prefs.setBool("passcode", state);
  }

  void getPasscode() {
    state = _prefs.getBool("passcode") ?? false;
  }
}

class FaceIdNotifier extends StateNotifier<bool> {
  FaceIdNotifier(this._prefs) : super(false) {
    getFaceId();
  }

  final SharedPreferences _prefs;

  void setFaceId(bool isOn) {
    state = isOn;
    _prefs.setBool("faceId", state);
  }

  void getFaceId() {
    state = _prefs.getBool("faceId") ?? false;
  }
}

class PassCodeRockSetting extends ConsumerWidget {
  const PassCodeRockSetting({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final passcode = ref.watch(passcodeProvider);
    final passcodeController = ref.read(passcodeProvider.notifier);
    final faceId = ref.watch(faceProvider);
    final faceIdController = ref.read(faceProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: _buildHeader(context),
          ),
          SliverToBoxAdapter(
            child: _buildContent(
              context,
              ref,
              passcode,
              passcodeController,
              faceId,
              faceIdController,
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
          Icon(Icons.lock, color: Colors.white, size: 28.sp),
          SizedBox(width: 12.w),
          Text(
            'パスコードロック',
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

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    bool passcode,
    PasscodeNotifier passcodeController,
    bool faceId,
    FaceIdNotifier faceIdController,
  ) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          SizedBox(height: 8.h),
          _buildSettingsCard(
            context,
            ref,
            passcode,
            passcodeController,
            faceId,
            faceIdController,
          ),
          SizedBox(height: 24.h),
          _buildInfoCard(),
        ],
      ),
    );
  }

  Widget _buildSettingsCard(
    BuildContext context,
    WidgetRef ref,
    bool passcode,
    PasscodeNotifier passcodeController,
    bool faceId,
    FaceIdNotifier faceIdController,
  ) {
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
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFF7E57C2).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(
                    Icons.lock_outline,
                    color: const Color(0xFF7E57C2),
                    size: 22.sp,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'パスコードロック',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF2D3748),
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        passcode ? '有効' : '無効',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: const Color(0xFF718096),
                        ),
                      ),
                    ],
                  ),
                ),
                CupertinoSwitchTile(
                  title: "",
                  value: passcode,
                  onChanged: (bool value) {
                    passcodeController.setPasscode(value);
                    if (value == true) {
                      PasscodeLockSettingScreen.passcodeLockSettingScreen(context, ref);
                    }
                  },
                ),
              ],
            ),
          ),
          if (passcode) ...[
            Padding(
              padding: EdgeInsets.only(left: 64.w),
              child: const Divider(height: 1, color: Color(0xFFE2E8F0)),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(10.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFF42A5F5).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Icon(
                      Icons.face,
                      color: const Color(0xFF42A5F5),
                      size: 22.sp,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '顔認証 / Touch ID',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF2D3748),
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          faceId ? '有効' : '無効',
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: const Color(0xFF718096),
                          ),
                        ),
                      ],
                    ),
                  ),
                  CupertinoSwitchTile(
                    title: "",
                    value: faceId,
                    onChanged: (bool value) {
                      faceIdController.setFaceId(value);
                    },
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: const Color(0xFF00C853).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(
              Icons.security,
              color: const Color(0xFF00C853),
              size: 22.sp,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'セキュリティについて',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2D3748),
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'パスコードを設定すると、アプリ起動時にロックがかかります。顔認証を有効にすると、より便利にご利用いただけます。',
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: const Color(0xFF718096),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
