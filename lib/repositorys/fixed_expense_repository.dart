import 'package:budget/datebases/fixed_expense_database.dart';
import 'package:budget/model/fixed_expense/fixed_expense.dart';

class FixedExpenseRepository {
  final FixedExpenseDatabase _fixedExpenseDatabase;

  FixedExpenseRepository(this._fixedExpenseDatabase);

  Future<List<FixedExpense>> getFixedExpenses() async {
    return _fixedExpenseDatabase.getFixedExpenses();
  }

  Future<FixedExpense> addFixedExpense(FixedExpense fixedExpense) async {
    return _fixedExpenseDatabase.insert(fixedExpense);
  }

  Future<void> updateFixedExpense(FixedExpense fixedExpense) async {
    return _fixedExpenseDatabase.update(fixedExpense);
  }

  Future<void> deleteFixedExpense(int id) async {
    return _fixedExpenseDatabase.delete(id);
  }
}
