import 'package:budget/model/transfer/transfer.dart';
import 'package:budget/model/wallet/wallet.dart';
import 'package:budget/viewModels/transfer_model.dart';
import 'package:budget/viewModels/wallet_model.dart';
import 'package:budget/widgets/dateBar_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

final transferAmountProvider = StateProvider.autoDispose((ref) => "");
final transferMemoProvider = StateProvider.autoDispose((ref) => "");
final fromWalletIndexProvider = StateProvider.autoDispose((ref) => 0);
final toWalletIndexProvider = StateProvider.autoDispose((ref) => 1);

class TransferPage extends ConsumerWidget {
  TransferPage({super.key});

  String amount = "";
  String memo = "";
  int fromWalletIndex = 0;
  int toWalletIndex = 1;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final walletState = ref.watch(walletViewModelProvider);

    if (walletState.wallets.length < 2) {
      return Center(
        child: Container(
          padding: EdgeInsets.all(32.w),
          margin: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.info_outline, size: 48.sp, color: const Color(0xFFA0AEC0)),
              SizedBox(height: 16.h),
              Text(
                "振替には2つ以上の\nウォレットが必要です",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16.sp, color: const Color(0xFF718096)),
              ),
            ],
          ),
        ),
      );
    }

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            dateBarWidget(),
            SizedBox(height: 16.h),
            _buildTransferCard(context, ref, walletState.wallets),
          ],
        ),
      ),
    );
  }

  Widget _buildTransferCard(
      BuildContext context, WidgetRef ref, List<Wallet> wallets) {
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
                colors: [Color(0xFF5C6BC0), Color(0xFF7986CB)],
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
                Icon(Icons.swap_horiz, color: Colors.white, size: 28.sp),
                SizedBox(width: 12.w),
                Text(
                  '振替',
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
                _buildAmountField(ref),
                SizedBox(height: 16.h),
                _buildWalletSelector(context, ref, "送金元", wallets, true),
                SizedBox(height: 8.h),
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7FAFC),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.arrow_downward,
                      color: const Color(0xFF5C6BC0), size: 24.sp),
                ),
                SizedBox(height: 8.h),
                _buildWalletSelector(context, ref, "送金先", wallets, false),
                SizedBox(height: 16.h),
                _buildMemoField(ref),
                SizedBox(height: 24.h),
                _buildTransferButton(ref, context, wallets),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmountField(WidgetRef ref) {
    amount = ref.watch(transferAmountProvider);
    final amountController = ref.read(transferAmountProvider.notifier);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 4.w, bottom: 8.h),
          child: Text(
            '振替金額',
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
                child: Icon(Icons.currency_yen,
                    size: 24.sp, color: const Color(0xFF5C6BC0)),
              ),
              Expanded(
                child: TextField(
                  style:
                      TextStyle(fontSize: 16.sp, color: const Color(0xFF2D3748)),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: '金額を入力',
                    hintStyle:
                        TextStyle(color: const Color(0xFFA0AEC0), fontSize: 16.sp),
                    contentPadding: EdgeInsets.symmetric(vertical: 14.h),
                  ),
                  onChanged: (amountText) {
                    amountController.state = amountText;
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWalletSelector(BuildContext context, WidgetRef ref,
      String label, List<Wallet> wallets, bool isFrom) {
    final indexProvider =
        isFrom ? fromWalletIndexProvider : toWalletIndexProvider;
    final currentIndex = ref.watch(indexProvider);

    if (isFrom) {
      fromWalletIndex = currentIndex;
    } else {
      toWalletIndex = currentIndex;
    }

    final wallet = wallets[currentIndex];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 4.w, bottom: 8.h),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF4A5568),
            ),
          ),
        ),
        GestureDetector(
          onTap: () async {
            await showWalletPicker(context, ref, wallets, indexProvider);
          },
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF7FAFC),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(14.w),
                  child: Icon(
                    IconData(
                      wallet.icon ?? Icons.account_balance_wallet.codePoint,
                      fontFamily: 'MaterialIcons',
                    ),
                    size: 24.sp,
                    color: Color(wallet.color ?? Colors.green.toARGB32()),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    child: Text(
                      wallet.name,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF2D3748),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 14.w),
                  child: Icon(Icons.expand_more,
                      size: 24.sp, color: const Color(0xFF718096)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> showWalletPicker(BuildContext context, WidgetRef ref,
      List<Wallet> wallets, AutoDisposeStateProvider<int> indexProvider) async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(16.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 60),
                    Text(
                      'ウォレットを選択',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF2D3748),
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        '閉じる',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: const Color(0xFF5C6BC0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 200.h,
                child: CupertinoPicker(
                  itemExtent: 50.sp,
                  onSelectedItemChanged: (index) {
                    ref.read(indexProvider.notifier).state = index;
                  },
                  children: wallets
                      .map(
                        (wallet) => Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                IconData(
                                  wallet.icon ??
                                      Icons.account_balance_wallet.codePoint,
                                  fontFamily: 'MaterialIcons',
                                ),
                                color: Color(
                                    wallet.color ?? Colors.green.toARGB32()),
                                size: 28.sp,
                              ),
                              SizedBox(width: 12.w),
                              Text(
                                wallet.name,
                                style: TextStyle(fontSize: 18.sp),
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              SizedBox(height: 20.h),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMemoField(WidgetRef ref) {
    memo = ref.watch(transferMemoProvider);
    final memoController = ref.read(transferMemoProvider.notifier);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 4.w, bottom: 8.h),
          child: Text(
            'メモ',
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
                child: Icon(Icons.edit_note,
                    size: 24.sp, color: const Color(0xFF718096)),
              ),
              Expanded(
                child: TextField(
                  style:
                      TextStyle(fontSize: 16.sp, color: const Color(0xFF2D3748)),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'メモを入力',
                    hintStyle:
                        TextStyle(color: const Color(0xFFA0AEC0), fontSize: 16.sp),
                    contentPadding: EdgeInsets.symmetric(vertical: 14.h),
                  ),
                  onChanged: (memoText) {
                    memoController.state = memoText;
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTransferButton(
      WidgetRef ref, BuildContext context, List<Wallet> wallets) {
    return SizedBox(
      width: double.infinity,
      height: 56.h,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF5C6BC0),
          foregroundColor: Colors.white,
          elevation: 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        ),
        onPressed: () async => await executeTransfer(context, ref, wallets),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.swap_horiz, size: 24.sp),
            SizedBox(width: 8.w),
            Text('振替実行',
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Future<void> executeTransfer(
      BuildContext context, WidgetRef ref, List<Wallet> wallets) async {
    final transferViewModel = ref.read(transferViewModelProvider.notifier);
    final date = ref.watch(dateProvider);

    if (fromWalletIndex == toWalletIndex) {
      await showErrorDialog(context, "送金元と送金先が同じです");
      return;
    }

    if (amount.isEmpty) {
      await showErrorDialog(context, "金額を入力してください");
      return;
    }

    final fromWallet = wallets[fromWalletIndex];
    final toWallet = wallets[toWalletIndex];

    final transferData = Transfer(
      fromWalletId: fromWallet.id ?? 0,
      toWalletId: toWallet.id ?? 0,
      amount: amount,
      date: date,
      memo: memo,
    );

    try {
      await transferViewModel.addTransfer(transferData);
      if (context.mounted) {
        await showSuccessDialog(context);
      }
    } on Exception catch (e) {
      if (context.mounted) {
        await showErrorDialog(context, e.toString());
      }
    }
  }

  Future<void> showSuccessDialog(BuildContext context) async {
    await showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle,
                  color: const Color(0xFF00C853), size: 24.sp),
              SizedBox(width: 8.w),
              const Text('完了'),
            ],
          ),
          content: Padding(
            padding: EdgeInsets.only(top: 12.h),
            child: const Text('振替が完了しました'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK', style: TextStyle(color: Color(0xFF00C853))),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        );
      },
    );
  }

  Future<void> showErrorDialog(BuildContext context, String error) async {
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
          content:
              Padding(padding: EdgeInsets.only(top: 12.h), child: Text(error)),
          actions: <Widget>[
            TextButton(
                child: const Text('OK'),
                onPressed: () => Navigator.of(context).pop())
          ],
        );
      },
    );
  }
}
