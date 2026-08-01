/// 残高計算のための純粋関数を提供するヘルパークラス
/// テストしやすさのために計算ロジックを分離
class BalanceCalculator {
  /// 残高調整の結果を保持するクラス
  static BalanceResult adjustBalances({
    required int balance,
    required int remainingBalance,
    required int saving,
    required int remainingSaving,
    required int walletCash,
    required int remainingWalletCash,
  }) {
    int adjustedBalance = balance;
    int adjustedRemainingBalance = remainingBalance;
    int adjustedSaving = saving;
    int adjustedRemainingSaving = remainingSaving;
    int adjustedWalletCash = walletCash;
    int adjustedRemainingWalletCash = remainingWalletCash;

    // walletCashが負の場合は0にする
    if (adjustedWalletCash < 0) {
      adjustedWalletCash = 0;
    }

    // 財布の金額がマイナスになったら、そのマイナス分を残高が払う
    if (adjustedRemainingWalletCash < 0) {
      adjustedRemainingBalance += adjustedRemainingWalletCash; // マイナス値を足す = 引く
      adjustedRemainingWalletCash = 0;
    }

    // 残高がマイナスになったら貯金から払う
    if (adjustedRemainingBalance < 0) {
      adjustedRemainingSaving += adjustedRemainingBalance;
      adjustedRemainingBalance = 0;
    }

    // 貯金がマイナスになったらゼロにする
    if (adjustedRemainingSaving < 0) {
      adjustedRemainingSaving = 0;
    }

    // 残高が最大残高より増えたら、その残高が最大残高になる
    if (adjustedRemainingBalance > adjustedBalance) {
      adjustedBalance = adjustedRemainingBalance;
    }

    // 財布も同様：残高が設定額より増えたら、その残高が設定額になる
    if (adjustedRemainingWalletCash > adjustedWalletCash) {
      adjustedWalletCash = adjustedRemainingWalletCash;
    }

    return BalanceResult(
      balance: adjustedBalance,
      remainingBalance: adjustedRemainingBalance,
      saving: adjustedSaving,
      remainingSaving: adjustedRemainingSaving,
      walletCash: adjustedWalletCash,
      remainingWalletCash: adjustedRemainingWalletCash,
    );
  }
}

/// 残高計算結果を保持するクラス
class BalanceResult {
  final int balance;
  final int remainingBalance;
  final int saving;
  final int remainingSaving;
  final int walletCash;
  final int remainingWalletCash;

  const BalanceResult({
    required this.balance,
    required this.remainingBalance,
    required this.saving,
    required this.remainingSaving,
    required this.walletCash,
    required this.remainingWalletCash,
  });
}
