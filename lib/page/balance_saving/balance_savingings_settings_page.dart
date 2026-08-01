import 'package:budget/provider/shared_preferences_provider.dart';
import 'package:budget/viewModels/balance_with_saving_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BalanceSavingSettingsPage extends ConsumerStatefulWidget {
  const BalanceSavingSettingsPage({super.key});

  @override
  ConsumerState<BalanceSavingSettingsPage> createState() =>
      _BalanceSavingSettingsPageState();
}

class _BalanceSavingSettingsPageState
    extends ConsumerState<BalanceSavingSettingsPage> {
  final TextEditingController _balanceController = TextEditingController();
  final TextEditingController _savingController = TextEditingController();
  final TextEditingController _walletCashController = TextEditingController();
  int _balance = 0;
  int _saving = 0;
  int _walletCash = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialValues();
    });
  }

  void _loadInitialValues() {
    final prefs = ref.read(sharedPreferencesProvider);
    _balance = prefs.getInt("balanse") ?? 0;
    _saving = prefs.getInt("total_savings") ?? 0;
    _walletCash = prefs.getInt("wallet_cash") ?? 0;
    _balanceController.text = _balance == 0 ? "" : _balance.toString();
    _savingController.text = _saving == 0 ? "" : _saving.toString();
    _walletCashController.text = _walletCash == 0 ? "" : _walletCash.toString();
  }

  @override
  void dispose() {
    _balanceController.dispose();
    _savingController.dispose();
    _walletCashController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F7FA),
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: _buildHeader(context),
            ),
            SliverToBoxAdapter(
              child: _buildContent(context),
            ),
          ],
        ),
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
              child:
                  Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20.sp),
            ),
          ),
          SizedBox(width: 16.w),
          Icon(Icons.tune, color: Colors.white, size: 28.sp),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              '金額設定',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          SizedBox(height: 8.h),
          _buildSettingsCard(context),
        ],
      ),
    );
  }

  Widget _buildSettingsCard(BuildContext context) {
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
                Icon(Icons.settings, color: Colors.white, size: 28.sp),
                SizedBox(width: 12.w),
                Text(
                  '初期設定',
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
                _buildBalanceField(),
                SizedBox(height: 20.h),
                _buildSavingField(),
                SizedBox(height: 20.h),
                _buildWalletCashField(),
                SizedBox(height: 28.h),
                _buildSubmitButton(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputContainer({
    required String label,
    required String description,
    required Widget child,
    required IconData icon,
    required Color iconColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 4.w, bottom: 4.h),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF2D3748),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 4.w, bottom: 10.h),
          child: Text(
            description,
            style: TextStyle(
              fontSize: 12.sp,
              color: const Color(0xFF718096),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF7FAFC),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: const Color(0xFFE2E8F0),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(14.w),
                child: Icon(
                  icon,
                  size: 24.sp,
                  color: iconColor,
                ),
              ),
              Expanded(child: child),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBalanceField() {
    return _buildInputContainer(
      label: '月の手取り',
      description: '毎月の収入額（残高ゲージの最大値になります）',
      icon: Icons.account_balance,
      iconColor: const Color(0xFF00C853),
      child: TextField(
        controller: _balanceController,
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF2D3748),
        ),
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        onChanged: (text) {
          _balance = int.tryParse(text) ?? 0;
        },
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: '例: 250000',
          hintStyle: TextStyle(
            color: const Color(0xFFA0AEC0),
            fontSize: 16.sp,
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 14.h),
          suffixText: '円',
          suffixStyle: TextStyle(
            fontSize: 16.sp,
            color: const Color(0xFF718096),
          ),
        ),
      ),
    );
  }

  Widget _buildSavingField() {
    return _buildInputContainer(
      label: '現在の貯金額',
      description: 'アプリ開始時点での貯金残高',
      icon: Icons.savings,
      iconColor: const Color(0xFFFFB300),
      child: TextField(
        controller: _savingController,
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF2D3748),
        ),
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        onChanged: (text) {
          _saving = int.tryParse(text) ?? 0;
        },
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: '例: 500000',
          hintStyle: TextStyle(
            color: const Color(0xFFA0AEC0),
            fontSize: 16.sp,
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 14.h),
          suffixText: '円',
          suffixStyle: TextStyle(
            fontSize: 16.sp,
            color: const Color(0xFF718096),
          ),
        ),
      ),
    );
  }

  Widget _buildWalletCashField() {
    return _buildInputContainer(
      label: '現在の財布残高',
      description: '今、財布に入っている現金',
      icon: Icons.account_balance_wallet,
      iconColor: const Color(0xFF5C6BC0),
      child: TextField(
        controller: _walletCashController,
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF2D3748),
        ),
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        onChanged: (text) {
          _walletCash = int.tryParse(text) ?? 0;
        },
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: '例: 10000',
          hintStyle: TextStyle(
            color: const Color(0xFFA0AEC0),
            fontSize: 16.sp,
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 14.h),
          suffixText: '円',
          suffixStyle: TextStyle(
            fontSize: 16.sp,
            color: const Color(0xFF718096),
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return SizedBox(
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
        onPressed: () async {
          await _saveSettings();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle_outline, size: 24.sp),
            SizedBox(width: 8.w),
            Text(
              '保存',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveSettings() async {
    final prefs = ref.read(sharedPreferencesProvider);
    final model = ref.read(balanceWithSavingModelProvider.notifier);
    try {
      await prefs.setInt("balanse", _balance);
      await prefs.setInt("total_savings", _saving);
      await prefs.setInt("wallet_cash", _walletCash);
      await model.getBalanseWithSaving();
      if (mounted) {
        await _showSuccessDialog();
      }
    } catch (e) {
      if (mounted) {
        await _showErrorDialog(e.toString());
      }
    }
  }

  Future<void> _showSuccessDialog() async {
    await showCupertinoDialog(
      context: context,
      builder: (dialogContext) {
        return CupertinoAlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle, color: const Color(0xFF00C853), size: 24.sp),
              SizedBox(width: 8.w),
              const Text('設定完了'),
            ],
          ),
          content: Padding(
            padding: EdgeInsets.only(top: 12.h),
            child: const Text('金額を設定しました。'),
          ),
          actions: [
            TextButton(
              child: const Text('OK', style: TextStyle(color: Color(0xFF00C853))),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            )
          ],
        );
      },
    );
  }

  Future<void> _showErrorDialog(String error) async {
    await showCupertinoDialog(
      context: context,
      builder: (dialogContext) {
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
              onPressed: () => Navigator.of(dialogContext).pop(),
            )
          ],
        );
      },
    );
  }
}
