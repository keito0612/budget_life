import 'package:budget/model/balance_with_saving/balance_with_saving.dart';
import 'package:budget/provider/shared_preferences_provider.dart';
import 'package:budget/states/expense_state.dart';
import 'package:budget/states/income_state.dart';
import 'package:budget/utils/balance_calculator.dart';
import 'package:budget/utils/util.dart';
import 'package:budget/viewModels/expense_model.dart';
import 'package:budget/viewModels/income_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final balanceWithSavingModelProvider =
    StateNotifierProvider<BalanceWithSavingModel, BalanceWithSaving>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return BalanceWithSavingModel(ref, prefs);
});

class BalanceWithSavingModel extends StateNotifier<BalanceWithSaving> {
  BalanceWithSavingModel(this._ref, this._prefs)
      : super(const BalanceWithSaving()) {
    // 支出データの変更を監視
    _ref.listen<ExpenseState>(expenseViewModelProvider, (previous, next) {
      getBalanseWithSaving();
    });
    // 収入データの変更を監視
    _ref.listen<IncomeState>(incomeViewModelProvider, (previous, next) {
      getBalanseWithSaving();
    });
    // 月が変わったかチェックし、残高を貯金に移行
    _checkAndTransferMonthlyBalance();
    // 初期読み込み
    getBalanseWithSaving();
  }

  late final Ref _ref;
  final SharedPreferences _prefs;
  final today = DateTime.now();

  ExpenseState get _expenseState => _ref.read(expenseViewModelProvider);
  IncomeState get _incomeState => _ref.read(incomeViewModelProvider);

  /// 月が変わった場合、前月の残高を貯金に移行する
  Future<void> _checkAndTransferMonthlyBalance() async {
    final currentMonth = "${today.year}-${today.month}";
    final lastAccessedMonth = _prefs.getString("last_accessed_month");

    // 初回起動時は現在の月を保存するのみ
    if (lastAccessedMonth == null) {
      await _prefs.setString("last_accessed_month", currentMonth);
      return;
    }

    // 月が変わっていない場合は何もしない
    if (lastAccessedMonth == currentMonth) {
      return;
    }

    // 月が変わった場合、前月の残高を貯金に移行
    final previousRemainingBalance = _prefs.getInt("previous_remaining_balance") ?? 0;

    if (previousRemainingBalance > 0) {
      // 前月の残高を貯金に追加
      final currentSavings = _prefs.getInt("total_savings") ?? 0;
      await _prefs.setInt("total_savings", currentSavings + previousRemainingBalance);

      // 前月の残高をリセット
      await _prefs.setInt("previous_remaining_balance", 0);
    }

    // 財布の残高も貯金に移行（任意：財布に残っていた分も貯金に）
    final previousWalletCash = _prefs.getInt("previous_wallet_remaining") ?? 0;
    if (previousWalletCash > 0) {
      final currentSavings = _prefs.getInt("total_savings") ?? 0;
      await _prefs.setInt("total_savings", currentSavings + previousWalletCash);
      await _prefs.setInt("previous_wallet_remaining", 0);
    }

    // 財布残高をリセット（新しい月は0から開始）
    await _prefs.setInt("wallet_cash", 0);

    // 最後にアクセスした月を更新
    await _prefs.setString("last_accessed_month", currentMonth);
  }

  /// 現在の残高を保存（月末時や定期的に呼ばれる）
  Future<void> _saveCurrentBalanceForNextMonth(int remainingBalance, int remainingWalletCash) async {
    await _prefs.setInt("previous_remaining_balance", remainingBalance > 0 ? remainingBalance : 0);
    await _prefs.setInt("previous_wallet_remaining", remainingWalletCash > 0 ? remainingWalletCash : 0);
  }

  //月の合計支出金額
  final monthExpenseTotal = <String, int>{};
  //月の合計収入金顔
  final monthIncomeTotal = <String, int>{};

  Future<void> setBalanseWithSaving(BalanceWithSaving balanseWithSaving) async {
    await _prefs.setInt("balanse", balanseWithSaving.balance);
    await _prefs.setInt("saving", balanseWithSaving.saving);
  }

  Future<void> getBalanseWithSaving() async {
    // 前回のデータをクリア
    monthExpenseTotal.clear();
    monthIncomeTotal.clear();

    final expenseState = _expenseState;
    final incomeState = _incomeState;
    //今月
    final currentMonth = "${today.year}年${today.month}月";

    //残高
    int balanse = _prefs.getInt("balanse") ?? 0;
    //貯金額
    int saving = _prefs.getInt("saving") ?? 0;

    // 財布残高（設定金額 = 最大値）
    int walletCash = _prefs.getInt("wallet_cash") ?? 0;
    // 財布の残り残高（支出を引いた後）
    int remainingWalletCash = walletCash;

    ///残りの残高
    int remainingBalanse = balanse;
    //残りの貯金額（実際に貯金した額）
    int remainingSaving = _prefs.getInt("total_savings") ?? 0;

    if (expenseState.expenses.isNotEmpty) {
      //支出リストから日付ごとの支出合計金額を取り出す。
      //walletId == 0 (口座から) の支出のみ残高計算に含める
      //walletId == 1 (財布から) の支出は財布残高から引く
      for (final expense in expenseState.expenses) {
        final date = Util.convartDate(expense.date);
        final month = "${date.year}年${date.month}月";
        final amount = int.parse(expense.amount);

        // 財布からの支出は財布残高から引く
        if (expense.walletId == 1) {
          // 今月の財布からの支出のみ計算
          if (month == currentMonth) {
            remainingWalletCash -= amount;
          }
          continue;
        }

        // 口座からの支出は残高計算に含める
        if (monthExpenseTotal.containsKey(currentMonth)) {
          monthExpenseTotal[currentMonth] =
              monthExpenseTotal[currentMonth]! + amount;
          print(monthExpenseTotal[currentMonth]);
        } else if (monthExpenseTotal.containsKey(month)) {
          monthExpenseTotal[month] =
              monthExpenseTotal[month]! + amount;
        } else {
          monthExpenseTotal[month] = amount;
          print(monthExpenseTotal[month]);
        }
      }
      print(monthExpenseTotal[currentMonth]);
    }
    if (incomeState.incomes.isNotEmpty) {
      //収入リストから日付ごとの収入合計金額を取り出す。
      incomeState.incomes.forEach((income) {
        final date = Util.convartDate(income.date);
        final month = "${date.year}年${date.month}月";
        //同じ日付があったらそれ同士を足してまとめる。
        if (monthIncomeTotal.containsKey(month)) {
          monthIncomeTotal[month] =
              monthIncomeTotal[month]! + int.parse(income.amount);
        } else {
          monthIncomeTotal[month] = int.parse(income.amount);
        }
      });
    }

    //今月の残高を求めるために合計の収入から月の合計支出を引く
    if (monthIncomeTotal[currentMonth] != null &&
        monthExpenseTotal[currentMonth] != null) {
      remainingBalanse = remainingBalanse +
          _deductExpenses(monthIncomeTotal[currentMonth]!,
              monthExpenseTotal[currentMonth]!);
      balanse += monthIncomeTotal[currentMonth]!;
    } else if (monthIncomeTotal[currentMonth] == null &&
        monthExpenseTotal[currentMonth] != null) {
      // 今月の収入がなければそのまま支出を引く
      remainingBalanse = remainingBalanse - monthExpenseTotal[currentMonth]!;

      print(remainingSaving);
    } else if (monthIncomeTotal[currentMonth] != null &&
        monthExpenseTotal[currentMonth] == null) {
      // 今月の支出がなければそのまま収入分を足す
      remainingBalanse += monthIncomeTotal[currentMonth]!;
      balanse += monthIncomeTotal[currentMonth]!;
    }

    // 残高調整ロジックをヘルパー関数で実行
    final result = BalanceCalculator.adjustBalances(
      balance: balanse,
      remainingBalance: remainingBalanse,
      saving: saving,
      remainingSaving: remainingSaving,
      walletCash: walletCash,
      remainingWalletCash: remainingWalletCash,
    );

    state = state.copyWith(
        date: "${today.year}年${today.month}月",
        balance: result.balance,
        saving: result.saving,
        remainingBalance: result.remainingBalance,
        remainingSaving: result.remainingSaving,
        walletCash: result.walletCash,
        remainingWalletCash: result.remainingWalletCash);

    // 次の月のために現在の残高を保存
    await _saveCurrentBalanceForNextMonth(result.remainingBalance, result.remainingWalletCash);
  }

  int _deductExpenses(int income, int expense) {
    if (income < expense) {
      final overAmonth = income - expense;
      return overAmonth;
    }
    return income - expense;
  }
}
