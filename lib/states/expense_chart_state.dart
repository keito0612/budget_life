import 'package:freezed_annotation/freezed_annotation.dart';
part 'expense_chart_state.freezed.dart';

@freezed
class ExpenseChartState with _$ExpenseChartState {
  const factory ExpenseChartState({
    @Default({}) Map<String, Map<String, double>> expense,
    @Default({}) Map<String, List<int>> colorList,
    @Default({}) Map<String, List<int>> iconList,
    @Default({}) Map<String, int> totalAmount, 
  }) = _ExpenseChartState;
}
