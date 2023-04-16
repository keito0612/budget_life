import 'package:freezed_annotation/freezed_annotation.dart';
part 'fixed_expense.freezed.dart';
part 'fixed_expense.g.dart';

@freezed
abstract class FixedExpense with _$FixedExpense {
  const factory FixedExpense({
    int? id,
    @Default("") String amount,
    @Default("") String autoMaticInputDate,
    @Default(1) int autoMaticInputDay,
    @Default(0) int autoMaticInuputDateIndex,
    @Default("") String memo,
    String? category,
    int? icon,
    int? color,
    int? categoryIndex,
  }) = _FixedExpense;
  factory FixedExpense.fromJson(Map<String, dynamic> json) =>
      _$FixedExpenseFromJson(json);
}
