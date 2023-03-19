import 'package:budget/datebases/income_database.dart';
import 'package:budget/model/income/income.dart';

class IncomeRepository {
  final IncomeDatabase _incomeDatabase;

  IncomeRepository(this._incomeDatabase);

  Future<List<Income>> getIncomes() async {
    return _incomeDatabase.getIncomes();
  }

  Future<Income> addIncomes(Income income) async {
    return _incomeDatabase.insert(income);
  }

  Future<void> updateIncome(Income income) async {
    return _incomeDatabase.update(income);
  }

  Future<void> deleteIncome(int id) async {
    return _incomeDatabase.delete(id);
  }
}
