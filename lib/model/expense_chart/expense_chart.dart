import 'package:flutter/cupertino.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'expense_chart.freezed.dart';

@freezed
class ExpenseChart with _$ExpenseChart {
  const factory ExpenseChart({
    @Default({}) Map<String, double> expense,
    @Default([]) List<int> colorList,
  }) = _ExpenseChart;
}
