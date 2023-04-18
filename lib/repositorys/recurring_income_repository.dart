import 'package:budget/datebases/recurring_income_database.dart';
import 'package:budget/model/recurring_income/recurring_income.dart';

class RecurringIncomeRepository {
  final RecurringIncomeDatabase _recurringIncomeDatabase;

  RecurringIncomeRepository(this._recurringIncomeDatabase);

  Future<List<RecurringIncome>> getRecurringIncomes() async {
    return _recurringIncomeDatabase.getRecurringIncomes();
  }

  Future<RecurringIncome> addRecurringIncome(
      RecurringIncome recurringIncome) async {
    return _recurringIncomeDatabase.insert(recurringIncome);
  }

  Future<void> updateRecurringIncome(RecurringIncome recurringIncome) async {
    return _recurringIncomeDatabase.update(recurringIncome);
  }

  Future<void> deleteRecurringIncome(int id) async {
    return _recurringIncomeDatabase.delete(id);
  }
}
