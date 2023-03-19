import 'package:freezed_annotation/freezed_annotation.dart';
part 'balance_with_saving.freezed.dart';
part 'balance_with_saving.g.dart';

@freezed
abstract class BalanceWithSaving with _$BalanceWithSaving {
  const factory BalanceWithSaving({
    @Default("") String date,
    @Default(0) int balance,
    @Default(0) int saving,
    @Default(0) int remainingBalance,
    @Default(0) int remainingSaving,
  }) = _BalanceWithSaving;
  factory BalanceWithSaving.fromJson(Map<String, dynamic> json) =>
      _$BalanceWithSavingFromJson(json);
}
