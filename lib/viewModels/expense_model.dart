import 'package:budget/datebases/expense_database.dart';
import 'package:budget/model/expense.dart';
import 'package:budget/repositorys/expense_repository.dart';
import 'package:budget/states/expense_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final expenseViewModelProvider =
    StateNotifierProvider<ExpenseViewModel, ExpenseState>(
  (ref) => ExpenseViewModel(
    ref,
    ExpenseRepository(ExpenseDatabase()),
  ),
);

class ExpenseViewModel extends StateNotifier<ExpenseState> {
  ExpenseViewModel(this._ref, this._ExpenseRepository)
      : super(const ExpenseState()) {
    getExpenses();
  }
  final Ref _ref;
  final ExpenseRepository _ExpenseRepository;

  Future<void> addExpense(Expense expense) async {
    final expenseData = await _ExpenseRepository.addExpense(expense);
    state = state.copyWith(expenses: [expenseData, ...state.expenses]);
  }

  Future<void> getExpenses() async {
    final expenses = await _ExpenseRepository.getExpenses();
    state = state.copyWith(
      expenses: expenses,
    );
  }

  Future<void> updateExpense(Expense todo) async {
    await _ExpenseRepository.updateExpense(todo);

    final expenses = await _ExpenseRepository.getExpenses();
    state = state.copyWith(
      expenses: expenses,
    );
  }

  Future<void> deleteExpense(int expenseId) async {
    await _ExpenseRepository.deleteExpense(expenseId);
    final expenses =
        state.expenses.where((exspense) => exspense.id != expenseId).toList();
    state = state.copyWith(
      expenses: expenses,
    );
  }
}
