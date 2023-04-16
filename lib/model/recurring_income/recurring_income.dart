import 'package:freezed_annotation/freezed_annotation.dart';
part 'recurring_income.freezed.dart';
part 'recurring_income.g.dart';

@freezed
abstract class RecurringIncome with _$RecurringIncome {
  const factory RecurringIncome({
    int? id,
    @Default("") String amount,
    @Default("") String autoMaticInputDate,
    @Default(1) int autoMaticInputDay,
    @Default(1) int autoMaticInputIndex,
    @Default("") String memo,
    String? category,
    int? icon,
    int? color,
    int? categoryIndex,
  }) = _RecurringIncome;
  factory RecurringIncome.fromJson(Map<String, dynamic> json) =>
      _$RecurringIncomeFromJson(json);
}
