import 'package:freezed_annotation/freezed_annotation.dart';
part 'income_chart_state.freezed.dart';

@freezed
class IncomeChartState with _$IncomeChartState {
  const factory IncomeChartState({
    @Default({}) Map<String, Map<String, double>> income,
    @Default({}) Map<String, List<int>> colorList,
    @Default({}) Map<String, List<int>> iconList,
    @Default({}) Map<String, int> totalAmount, 
  }) = _IncomeChartState;
}
