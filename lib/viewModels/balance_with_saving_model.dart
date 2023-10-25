import 'package:budget/model/balance_with_saving/balance_with_saving.dart';
import 'package:budget/provider/shared_preferences_provider.dart';
import 'package:budget/states/expense_state.dart';
import 'package:budget/states/income_state.dart';
import 'package:budget/utils/util.dart';
import 'package:budget/viewModels/expense_model.dart';
import 'package:budget/viewModels/income_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

final balanceWithSavingModelProvider =
    StateNotifierProvider<BalanceWithSavingModel, BalanceWithSaving>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return BalanceWithSavingModel(ref, prefs);
});

class BalanceWithSavingModel extends StateNotifier<BalanceWithSaving> {
  BalanceWithSavingModel(this._ref, this._prefs)
      : super(const BalanceWithSaving()) {
    getBalanseWithSaving();
  }

  late final Ref _ref;
  final SharedPreferences _prefs;
  final today = DateTime.now();

  ExpenseState get _expenseState => _ref.watch(expenseViewModelProvider);
  IncomeState get _incomeState => _ref.watch(incomeViewModelProvider);

  //月の合計支出金額
  final monthExpenseTotal = <String, int>{};
  //月の合計収入金顔
  final monthIncomeTotal = <String, int>{};

  Future<void> setBalanseWithSaving(BalanceWithSaving balanseWithSaving) async {
    await _prefs.setInt("balanse", balanseWithSaving.balance);
    await _prefs.setInt("saving", balanseWithSaving.saving);
  }

  Future<void> getBalanseWithSaving() async {
    final currentMonthOneDate = DateTime(today.year, today.month, 1);
    final expenseState = _expenseState;
    final incomeState = _incomeState;
    //今月
    final currentMonth = "${today.year}年${today.month}月";

    //残高
    int balanse = _prefs.getInt("balanse") ?? 0;
    //貯金額
    int saving = _prefs.getInt("saving") ?? 0;

    ///残りの残高
    int remainingBalanse = balanse;
    //残りの貯金額
    int remainingSaving = saving;

    if (expenseState.expenses.isNotEmpty) {
      //支出リストから日付ごとの支出合計金額を取り出す。
      expenseState.expenses.forEach((expense) {
        final date = Util.convartDate(expense.date);
        final month = "${date.year}年${date.month}月";
        if (monthExpenseTotal.containsKey(currentMonth)) {
          monthExpenseTotal[currentMonth] =
              monthExpenseTotal[currentMonth]! + int.parse(expense.amount);
          print(monthExpenseTotal[currentMonth]);
        } else if (monthExpenseTotal.containsKey(month)) {
          monthExpenseTotal[month] =
              monthExpenseTotal[month]! + int.parse(expense.amount);
        } else {
          monthExpenseTotal[month] = int.parse(expense.amount);
          print(monthExpenseTotal[month]);
        }
      });
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

    //設定した残高を超えたらその分を貯金額に引く
    if (remainingBalanse < 0) {
      //remainingBalanseがマイナスの値になるためプラスにしてある
      remainingSaving = remainingSaving + remainingBalanse;
      if (today == currentMonthOneDate) {
        _prefs.setInt("remainingSaving", remainingSaving);
      }
      remainingBalanse = 0;
    }

    //次の月までに,残高が余っていたら、その分を貯金額にたす。余らなかったら引く
    if (today == currentMonthOneDate) {
      _saveSaving();
      saving = _prefs.getInt("saving") ?? 0;
    }

    //設定した貯金額より下回っていたらゼロにする。
    if (remainingSaving < 0) {
      remainingSaving = 0;
    }

    state = state.copyWith(
        date: "${today.year}年${today.month}月",
        balance: balanse,
        saving: saving,
        remainingBalance: remainingBalanse,
        remainingSaving: remainingSaving);
  }

  int _getPreviousMonthTotalExpense() {
    String? previousMonth;
    if (today.month == 1) {
      previousMonth = "${today.year - 1}年${12}月";
    } else {
      previousMonth = "${today.year}年${today.month - 1}月";
    }
    if (monthExpenseTotal[previousMonth] != null) {
      return monthExpenseTotal[previousMonth]!;
    } else {
      return 0;
    }
  }

  int _getPreviousMonthTotalIncome() {
    String? previousMonth;
    if (today.month == 1) {
      previousMonth = "${today.year - 1}年${12}月";
    } else {
      previousMonth = "${today.year}年${today.month - 1}月";
    }
    if (monthIncomeTotal[previousMonth] != null) {
      return monthIncomeTotal[previousMonth]!;
    } else {
      return 0;
    }
  }

  int _getPreviousMonthBalance(
      int previousMonthExpense, int previousMonthIncome) {
    return previousMonthIncome - previousMonthExpense;
  }

  void _saveSaving() {
    final previousMonthExpense = _getPreviousMonthTotalExpense();
    final previousMonthIncome = _getPreviousMonthTotalIncome();
    final previousMonthBalance =
        _getPreviousMonthBalance(previousMonthExpense, previousMonthIncome);
    int saving = _prefs.getInt("saving") ?? 0;
    _prefs.setInt("saving", saving + previousMonthBalance);
  }

  int _deductExpenses(int income, int expense) {
    if (income < expense) {
      final overAmonth = income - expense;
      return overAmonth;
    }
    return income - expense;
  }
}
