import 'package:budget/model/expense/expense.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'expense_state.freezed.dart';

@freezed
abstract class ExpenseState with _$ExpenseState {
  const factory ExpenseState({@Default([]) List<Expense> expenses}) =
      _ExpenseState;
}
