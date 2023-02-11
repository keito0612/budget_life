import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:flutter/foundation.dart';
part 'expense.freezed.dart';

@freezed
abstract class Expense with _$Expense {
  const factory Expense(
      {@Default(0) int id,
      @Default("") String amount,
      @Default("") String date,
      @Default("") String memo,
      @Default("") @Default("衣服") String category}) = _Expense;
}
