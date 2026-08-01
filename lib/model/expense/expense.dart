import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
part 'expense.freezed.dart';
part 'expense.g.dart';

@freezed
abstract class Expense with _$Expense {
  const factory Expense({
    int? id,
    @Default("") String amount,
    @Default("") String date,
    @Default("") String memo,
    String? category,
    int? icon,
    int? color,
    int? categoryIndex,
    @Default(1) int walletId,
  }) = _Expense;
  factory Expense.fromJson(Map<String, dynamic> json) =>
      _$ExpenseFromJson(json);
}
