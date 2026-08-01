import 'package:budget/utils/balance_calculator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BalanceCalculator.adjustBalances', () {
    test('財布がマイナスになったら、残高から払う', () {
      // 財布: 10,000円、財布残高: -5,000円（支出15,000円後）
      // → 財布: 0円、残高から5,000円引く
      final result = BalanceCalculator.adjustBalances(
        balance: 100000,
        remainingBalance: 100000,
        saving: 50000,
        remainingSaving: 50000,
        walletCash: 10000,
        remainingWalletCash: -5000, // 財布からの支出で-5000になった
      );

      expect(result.remainingWalletCash, equals(0),
          reason: '財布残高が0になるべき');
      expect(result.remainingBalance, equals(95000),
          reason: '残高から5000引かれるべき（100000 - 5000 = 95000）');
    });

    test('残高がマイナスになったら、貯金から払う', () {
      // 残高: -10,000円 → 貯金から10,000円引く
      final result = BalanceCalculator.adjustBalances(
        balance: 50000,
        remainingBalance: -10000, // 支出で-10000になった
        saving: 100000,
        remainingSaving: 100000,
        walletCash: 10000,
        remainingWalletCash: 10000,
      );

      expect(result.remainingBalance, equals(0),
          reason: '残高が0になるべき');
      expect(result.remainingSaving, equals(90000),
          reason: '貯金から10000引かれるべき（100000 - 10000 = 90000）');
    });

    test('貯金がマイナスになったら0にする', () {
      // 残高: -20,000円、貯金: 5,000円
      // → 貯金: 5,000 - 20,000 = -15,000 → 0
      final result = BalanceCalculator.adjustBalances(
        balance: 50000,
        remainingBalance: -20000,
        saving: 50000,
        remainingSaving: 5000, // 少ない貯金
        walletCash: 10000,
        remainingWalletCash: 10000,
      );

      expect(result.remainingBalance, equals(0),
          reason: '残高が0になるべき');
      expect(result.remainingSaving, equals(0),
          reason: '貯金がマイナスにならず0になるべき');
    });

    test('残高が最大残高より増えたら、最大残高を更新', () {
      // 残高: 250,000円、最大残高: 100,000円
      // → 最大残高も250,000円に更新
      final result = BalanceCalculator.adjustBalances(
        balance: 100000, // 最大残高
        remainingBalance: 250000, // 収入で増えた残高
        saving: 50000,
        remainingSaving: 50000,
        walletCash: 10000,
        remainingWalletCash: 10000,
      );

      expect(result.remainingBalance, equals(250000),
          reason: '残高が250000のまま');
      expect(result.balance, equals(250000),
          reason: '最大残高が残高に更新されるべき');
    });

    test('財布残高が設定額より増えたら、設定額を更新', () {
      // 財布残高: 30,000円、設定額: 10,000円
      // → 設定額も30,000円に更新
      final result = BalanceCalculator.adjustBalances(
        balance: 100000,
        remainingBalance: 100000,
        saving: 50000,
        remainingSaving: 50000,
        walletCash: 10000, // 設定額
        remainingWalletCash: 30000, // 入金で増えた
      );

      expect(result.remainingWalletCash, equals(30000),
          reason: '財布残高が30000のまま');
      expect(result.walletCash, equals(30000),
          reason: '設定額が財布残高に更新されるべき');
    });

    test('複合テスト: 財布マイナス → 残高マイナス → 貯金から払う', () {
      // 財布: 10,000円、財布残高: -40,000円（支出50,000円後）
      // 残高: 20,000円 - 40,000円 = -20,000円
      // 貯金: 100,000円 - 20,000円 = 80,000円
      final result = BalanceCalculator.adjustBalances(
        balance: 20000,
        remainingBalance: 20000,
        saving: 100000,
        remainingSaving: 100000,
        walletCash: 10000,
        remainingWalletCash: -40000, // 財布から50,000円使った
      );

      expect(result.remainingWalletCash, equals(0),
          reason: '財布残高が0になるべき');
      expect(result.remainingBalance, equals(0),
          reason: '残高が0になるべき');
      expect(result.remainingSaving, equals(80000),
          reason: '貯金が80000になるべき（100000 - 20000 = 80000）');
    });

    test('複合テスト: 財布マイナス → 残高マイナス → 貯金マイナス → 全て0', () {
      // 財布: 10,000円、財布残高: -100,000円
      // 残高: 20,000円 - 100,000円 = -80,000円
      // 貯金: 50,000円 - 80,000円 = -30,000円 → 0
      final result = BalanceCalculator.adjustBalances(
        balance: 20000,
        remainingBalance: 20000,
        saving: 50000,
        remainingSaving: 50000, // 少ない貯金
        walletCash: 10000,
        remainingWalletCash: -100000, // 大きな支出
      );

      expect(result.remainingWalletCash, equals(0),
          reason: '財布残高が0になるべき');
      expect(result.remainingBalance, equals(0),
          reason: '残高が0になるべき');
      expect(result.remainingSaving, equals(0),
          reason: '貯金が0になるべき（マイナスにならない）');
    });

    test('全てプラスの場合は変更なし', () {
      final result = BalanceCalculator.adjustBalances(
        balance: 100000,
        remainingBalance: 80000,
        saving: 50000,
        remainingSaving: 50000,
        walletCash: 30000,
        remainingWalletCash: 20000,
      );

      expect(result.balance, equals(100000));
      expect(result.remainingBalance, equals(80000));
      expect(result.saving, equals(50000));
      expect(result.remainingSaving, equals(50000));
      expect(result.walletCash, equals(30000));
      expect(result.remainingWalletCash, equals(20000));
    });

    test('walletCashがマイナスの場合は0にする', () {
      final result = BalanceCalculator.adjustBalances(
        balance: 100000,
        remainingBalance: 100000,
        saving: 50000,
        remainingSaving: 50000,
        walletCash: -5000, // マイナスの設定額（異常値）
        remainingWalletCash: 10000,
      );

      expect(result.walletCash, equals(10000),
          reason: 'walletCashが0になり、remainingWalletCashが大きいので更新される');
    });
  });
}
