import 'package:budget/datebases/recurring_income_database.dart';
import 'package:budget/model/recurring_income/recurring_income.dart';
import 'package:budget/repositorys/recurring_income_repository.dart';
import 'package:budget/states/recurring_income_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final recurringIncomeViewModelProvider =
    StateNotifierProvider<RecurringIncomeModel, RecurringIncomeState>(
  (ref) => RecurringIncomeModel(
    ref,
    RecurringIncomeRepository(RecurringIncomeDatabase()),
  ),
);

class RecurringIncomeModel extends StateNotifier<RecurringIncomeState> {
  RecurringIncomeModel(this._ref, this._recurringIncomeRepository)
      : super(const RecurringIncomeState()) {
    getRecurringIncomes();
  }
  final Ref _ref;
  final RecurringIncomeRepository _recurringIncomeRepository;

  Future<void> addRecurringIncome(RecurringIncome recurringIncome) async {
    final recurringIncomeData =
        await _recurringIncomeRepository.addRecurringIncome(recurringIncome);
    state = state.copyWith(
        recurringIncomes: [recurringIncomeData, ...state.recurringIncomes]);
  }

  Future<void> getRecurringIncomes() async {
    final recurringIncomes =
        await _recurringIncomeRepository.getRecurringIncomes();
    state = state.copyWith(
      recurringIncomes: recurringIncomes,
    );
  }

  Future<void> updateRecurringIncome(RecurringIncome recurringIncome) async {
    await _recurringIncomeRepository.updateRecurringIncome(recurringIncome);
    final recurringIncomes =
        await _recurringIncomeRepository.getRecurringIncomes();
    state = state.copyWith(
      recurringIncomes: recurringIncomes,
    );
  }

  Future<void> deleteRecurringIncome(int incomeId) async {
    await _recurringIncomeRepository.deleteRecurringIncome(incomeId);
    final recurringIncomes = state.recurringIncomes
        .where((income) => income.id != incomeId)
        .toList();
    state = state.copyWith(
      recurringIncomes: recurringIncomes,
    );
  }
}
