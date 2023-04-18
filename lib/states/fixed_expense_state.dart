import 'package:budget/model/fixed_expense/fixed_expense.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'fixed_expense_state.freezed.dart';

@freezed
abstract class fixedExpenseState with _$fixedExpenseState {
  const factory fixedExpenseState(
      {@Default([]) List<FixedExpense> fixedExpenses}) = _fixedExpenseState;
}
