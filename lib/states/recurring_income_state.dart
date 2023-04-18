import 'package:budget/model/recurring_income/recurring_income.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'recurring_income_state.freezed.dart';

@freezed
abstract class RecurringIncomeState with _$RecurringIncomeState {
  const factory RecurringIncomeState(
          {@Default([]) List<RecurringIncome> recurringIncomes}) =
      _RecurringIncomeState;
}
