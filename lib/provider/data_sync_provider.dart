import 'package:budget/provider/firebase_provider.dart';
import 'package:budget/viewModels/balance_with_saving_model.dart';
import 'package:budget/viewModels/expense_model.dart';
import 'package:budget/viewModels/fixed_expense_model.dart';
import 'package:budget/viewModels/income_model.dart';
import 'package:budget/viewModels/recurringI_income_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountRepositor {
  AccountRepositor(this._ref);
  late final Ref _ref;

  get expenses => _ref.watch(expenseViewModelProvider).expenses;
  get incomes => _ref.watch(incomeViewModelProvider).incomes;
  get fixedExpenses => _ref.watch(fixedExpenseViewModelProvider).fixedExpenses;
  get recurringIncomes =>
      _ref.watch(recurringIncomeViewModelProvider).recurringIncomes;
  get balanceWithSaving => _ref.watch(balanceWithSavingModelProvider).saving;
  get userId => _ref.watch(userProvider);
  get instance => _ref.watch(firebaseProvider);

  Future dateSync() async {
    await Future.forEach(expenses, (expense) async {
      await instance.ref("user").update({
        '$userId/expenses': expense,
      });
    });
    await Future.forEach(incomes, (income) async {
      await instance.ref("user").update({
        '$userId/incomes': income,
      });
    });
    await Future.forEach(fixedExpenses, (fixedExpense) async {
      await instance.ref("user").update({
        '$userId/fixedExpense': fixedExpense,
      });
    });
    await Future.forEach(recurringIncomes, (recurringIncome) async {
      await instance.ref("user").update({
        '$userId/recurringIncome': recurringIncome,
      });
    });
  }
}
