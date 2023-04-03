import 'package:budget/model/balance_with_saving/balance_with_saving.dart';
import 'package:budget/provider/shared_preferences_provider.dart';
import 'package:budget/states/expense_state.dart';
import 'package:budget/states/income_state.dart';
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
    getBalanseWithSaving();
  }

  late final Ref _ref;
  final SharedPreferences _prefs;

  ExpenseState get _expenseState => _ref.watch(expenseViewModelProvider);
  IncomeState get _incomeState => _ref.watch(incomeViewModelProvider);

  Future<void> setBalanseWithSaving(BalanceWithSaving balanseWithSaving) async {
    await _prefs.setInt("balanse", balanseWithSaving.balance);
    await _prefs.setInt("saving", balanseWithSaving.saving);
  }

  Future<void> getBalanseWithSaving() async {
    final today = DateTime.now();
    final expenseState = _expenseState;
    final incomeState = _incomeState;
    //月の合計支出金額
    final monthExpenseTotal = <String, int>{};
    //月の合計収入金顔
    final monthIncomeTotal = <String, int>{};
    //今月
    final currentMonth = "${today.year}年${today.month}月";

    //残高
    int balanse = _prefs.getInt("balanse") ?? 0;
    //貯金額
    int saving = _prefs.getInt("saving") ?? 0;

    ///残りの残高
    int remainingBalanse = balanse;
    //残りの貯金額
    int remainingSaving = _prefs.getInt("remainingSaving") ?? saving;
    //追加した日にち
    final addedDay =
        Util.convartDate(_prefs.getString("added_day") ?? Util.toDate(today));

    if (expenseState.expenses.isNotEmpty) {
      //支出リストから日付ごとの支出合計金額を取り出す。
      expenseState.expenses.forEach((expense) {
        final month = expense.date.substring(0, 7);
        if (monthExpenseTotal.containsKey(currentMonth) == true) {
          monthExpenseTotal[currentMonth] =
              monthExpenseTotal[currentMonth]! + int.parse(expense.amount);
        } else {
          monthExpenseTotal[month] = int.parse(expense.amount);
        }
      });
    }
    if (incomeState.incomes.isNotEmpty) {
      //収入リストから日付ごとの収入合計金額を取り出す。
      incomeState.incomes.forEach((income) {
        final month = income.date.substring(0, 7);
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
      remainingBalanse += -(monthExpenseTotal[currentMonth]!);
    } else if (monthIncomeTotal[currentMonth] != null &&
        monthExpenseTotal[currentMonth] == null) {
      // 今月の支出がなければそのまま収入分を足す
      remainingBalanse += monthIncomeTotal[currentMonth]!;
      balanse += monthIncomeTotal[currentMonth]!;
    }

    //設定した残高を超えたらその分を貯金額に引く
    if (remainingBalanse < 0) {
      remainingSaving = remainingSaving + remainingBalanse;
      if (addedDay.year != today.year || addedDay.month != today.month) {
        _prefs.setInt("remainingSaving", remainingSaving);
        _prefs.setString("addedDay", Util.toDate(today));
      }
      remainingBalanse = 0;
    }
    //次の月までに,残高が余っていたら、その分を貯金額にたす。
    if (addedDay.year != today.year || addedDay.month != today.month) {
      if (remainingBalanse > 0) {
        remainingSaving = remainingSaving + remainingBalanse;
        _prefs.setInt("remainingSaving", remainingSaving);
        _prefs.setString("addedDay", Util.toDate(today));
      }
    }

    //設定した貯金額を超えたらゼロにする。
    if (remainingSaving <= 0) {
      remainingSaving = 0;
    }

    state = state.copyWith(
        date: "${today.year}年${today.month}月",
        balance: balanse,
        saving: saving,
        remainingBalance: remainingBalanse,
        remainingSaving: remainingSaving);
  }

  int _deductExpenses(int income, int expense) {
    if (income < expense) {
      final overAmonth = income - expense;
      return overAmonth;
    }
    return income - expense;
  }
}
