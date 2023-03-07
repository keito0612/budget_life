import 'package:budget/model.dart';
import 'package:budget/model/balance_with_saving.dart';
import 'package:budget/model/expense.dart';
import 'package:budget/model/income.dart';
import 'package:budget/states/expense_state.dart';
import 'package:budget/states/income_state.dart';
import 'package:budget/utils/util.dart';
import 'package:budget/viewModels/expense_model.dart';
import 'package:budget/viewModels/income_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final balanceWithSavingModelProvider =
    StateNotifierProvider<BalanceWithSavingModel, BalanceWithSaving>((ref) {
  final expenseModel = ref.watch(expenseViewModelProvider);
  final incomeModel = ref.watch(incomeViewModelProvider);
  return BalanceWithSavingModel(ref, expenseModel, incomeModel);
});

class BalanceWithSavingModel extends StateNotifier<BalanceWithSaving> {
  BalanceWithSavingModel(this._ref, this.expenseModel, this.incomeModel)
      : super(const BalanceWithSaving()) {
    getBalanseWithSaving();
  }
  final Ref _ref;

  ExpenseState expenseModel;
  IncomeState incomeModel;

  Future<void> setBalanseWithSaving(BalanceWithSaving balanseWithSaving) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt("balanse", balanseWithSaving.balance);
    await prefs.setInt("saving", balanseWithSaving.saving);
  }

  Future<void> getBalanseWithSaving() async {
    final today = DateTime.now();
    final expenses = expenseModel.expenses;
    final incomes = incomeModel.incomes;
    //月の合計支出金額
    final monthExpenseTotal = <String, int>{};
    //月の合計収入金顔
    final monthIncomeTotal = <String, int>{};
    //今月
    final currentMonth = "${today.year}年${today.month}月";
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //残高
    int balanse = prefs.getInt("balanse") ?? 0;
    //貯金額
    int? saving = prefs.getInt("saving") ?? 0;

    ///残りの残高
    int remainingBalanse = balanse;
    //残りの貯金額
    int remainingSaving = saving;

    print("初期金額$balanse");
    //支出リストから日付ごとの支出合計金額を取り出す。
    expenses.forEach((expense) {
      final month = expense.date.substring(0, 7);
      if (monthExpenseTotal.containsKey(currentMonth) == true) {
        monthExpenseTotal[currentMonth] =
            monthExpenseTotal[currentMonth]! + int.parse(expense.amount);
        print(monthExpenseTotal[month]);
      } else {
        monthExpenseTotal[month] = int.parse(expense.amount);
      }
    });
    print(monthExpenseTotal[currentMonth]);
    //収入リストから日付ごとの収入合計金額を取り出す。
    incomes.forEach((income) {
      final month = income.date.substring(0, 7);
      //同じ日付があったらそれ同士を足してまとめる。；
      if (monthIncomeTotal.containsKey(month)) {
        monthIncomeTotal[month] =
            monthIncomeTotal[month]! + int.parse(income.amount);
      } else {
        monthIncomeTotal[month] = int.parse(income.amount);
      }
    });
    //今月の残高を求めるために合計の収入から月の合計支出を引く
    if (monthIncomeTotal.isNotEmpty && monthExpenseTotal.isNotEmpty) {
      remainingBalanse = remainingBalanse +
          deductExpenses(monthIncomeTotal[currentMonth]!,
              monthExpenseTotal[currentMonth]!);
      balanse += monthIncomeTotal[currentMonth]!;
      print(remainingBalanse);
    } else if (monthIncomeTotal[currentMonth] == null &&
        monthExpenseTotal[currentMonth] != null) {
      // 今月の収入がなければそのまま支出を引く
      remainingBalanse += -(monthExpenseTotal[currentMonth]!);
    } else if (monthIncomeTotal[currentMonth] != null &&
        monthExpenseTotal[currentMonth] == null) {
      // 今月の支出がなければそのまま収入分を足す
      remainingBalanse += monthIncomeTotal[currentMonth]!;
      balanse += monthIncomeTotal[currentMonth]!;
      print(remainingBalanse);
    }
    //設定した残高を超えたらその分を貯金額に引く
    if (remainingBalanse < 0) {
      print(remainingBalanse);
      remainingSaving = remainingSaving + remainingBalanse;
      remainingBalanse = 0;
    }
    //設定した所金額を超えたらゼロにする。
    if (remainingSaving <= 0) {
      remainingSaving = 0;
    }
    print("残高:$remainingBalanse");
    print("貯金額 :$saving");

    state = state.copyWith(
        date: "${today.year}年${today.month}月",
        balance: balanse,
        saving: saving,
        remainingBalance: remainingBalanse,
        remainingSaving: remainingSaving);
  }

  int deductExpenses(int income, int expense) {
    if (income < expense) {
      final overAmonth = income - expense;
      return overAmonth;
    }
    return income - expense;
  }
}
