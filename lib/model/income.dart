import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
part 'income.freezed.dart';
part 'income.g.dart';

@freezed
class Income with _$Income {
  const factory Income(
      {int? id,
      @Default("") String amount,
      @Default("") String date,
      @Default("") String memo,
      @Default("衣服") String category}) = _Income;
  factory Income.fromJson(Map<String, dynamic> json) => _$IncomeFromJson(json);
}
