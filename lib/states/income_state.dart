import 'package:budget/model/expense/expense.dart';
import 'package:budget/model/income/income.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'income_state.freezed.dart';

@freezed
abstract class IncomeState with _$IncomeState {
  const factory IncomeState({@Default([]) List<Income> incomes}) = _IncomeState;
}
