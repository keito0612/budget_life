import 'package:budget/datebases/income_database.dart';
import 'package:budget/model/income.dart';
import 'package:budget/repositorys/income_repository.dart';
import 'package:budget/states/income_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final incomeViewModelProvider =
    StateNotifierProvider<IncomeViewModel, IncomeState>(
  (ref) => IncomeViewModel(
    ref,
    IncomeRepository(IncomeDatabase()),
  ),
);

class IncomeViewModel extends StateNotifier<IncomeState> {
  IncomeViewModel(this._ref, this._IncomeRepository)
      : super(const IncomeState()) {
    getIncomes();
  }
  final Ref _ref;
  final IncomeRepository _IncomeRepository;

  Future<void> addIncomes(Income income) async {
    final incomeData = await _IncomeRepository.addIncomes(income);
    state = state.copyWith(incomes: [incomeData, ...state.incomes]);
  }

  Future<void> getIncomes() async {
    final incomes = await _IncomeRepository.getIncomes();
    state = state.copyWith(
      incomes: incomes,
    );
  }

  Future<void> updateIncome(Income income) async {
    await _IncomeRepository.updateIncome(income);
    final incomes = await _IncomeRepository.getIncomes();
    state = state.copyWith(
      incomes: incomes,
    );
  }

  Future<void> deleteIncome(int incomeId) async {
    await _IncomeRepository.deleteIncome(incomeId);
    final incomes =
        state.incomes.where((income) => income.id != incomeId).toList();
    state = state.copyWith(
      incomes: incomes,
    );
  }
}
