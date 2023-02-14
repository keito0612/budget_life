import 'package:budget/datebases/expense_database.dart';
import 'package:budget/model/expense.dart';

class ExpenseRepository {
  final ExpenseDatabase _expenseDatabase;

  ExpenseRepository(this._expenseDatabase);

  Future<List<Expense>> getExpenses() async {
    return _expenseDatabase.getExpenses();
  }

  Future<Expense> addExpense(Expense expense) async {
    return _expenseDatabase.insert(expense);
  }

  Future<void> updateExpense(Expense expense) async {
    return _expenseDatabase.update(expense);
  }

  Future<void> deleteExpense(int id) async {
    return _expenseDatabase.delete(id);
  }
}
