import 'package:budget/datebases/fixed_expense_database.dart';
import 'package:budget/model/fixed_expense/fixed_expense.dart';
import 'package:budget/repositorys/fixed_expense_repository.dart';
import 'package:budget/states/fixed_expense_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final fixedExpenseViewModelProvider =
    StateNotifierProvider<FixedExpenseModel, fixedExpenseState>(
  (ref) => FixedExpenseModel(
    FixedExpenseRepository(FixedExpenseDatabase()),
  ),
);

class FixedExpenseModel extends StateNotifier<fixedExpenseState> {
  FixedExpenseModel(this._fixedExpenseRepository)
      : super(const fixedExpenseState()) {
    getExpenses();
  }
  final FixedExpenseRepository _fixedExpenseRepository;

  Future<void> addExpense(FixedExpense fixedExpense) async {
    final fixedExpenseData =
        await _fixedExpenseRepository.addFixedExpense(fixedExpense);
    state = state
        .copyWith(fixedExpenses: [fixedExpenseData, ...state.fixedExpenses]);
  }

  Future<void> getExpenses() async {
    final fixedExpenses = await _fixedExpenseRepository.getFixedExpenses();
    state = state.copyWith(
      fixedExpenses: fixedExpenses,
    );
  }

  Future<void> updateExpense(FixedExpense fixedExpense) async {
    await _fixedExpenseRepository.updateFixedExpense(fixedExpense);
    final fixedExpenses = await _fixedExpenseRepository.getFixedExpenses();
    state = state.copyWith(
      fixedExpenses: fixedExpenses,
    );
  }

  Future<void> deleteExpense(int expenseId) async {
    await _fixedExpenseRepository.deleteFixedExpense(expenseId);
    final fixedExpenses = state.fixedExpenses
        .where((exspense) => exspense.id != expenseId)
        .toList();
    state = state.copyWith(
      fixedExpenses: fixedExpenses,
    );
  }
}
