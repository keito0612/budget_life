// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'balance_with_saving.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BalanceWithSavingImpl _$$BalanceWithSavingImplFromJson(
        Map<String, dynamic> json) =>
    _$BalanceWithSavingImpl(
      date: json['date'] as String? ?? "",
      balance: json['balance'] as int? ?? 0,
      saving: json['saving'] as int? ?? 0,
      remainingBalance: json['remainingBalance'] as int? ?? 0,
      remainingSaving: json['remainingSaving'] as int? ?? 0,
    );

Map<String, dynamic> _$$BalanceWithSavingImplToJson(
        _$BalanceWithSavingImpl instance) =>
    <String, dynamic>{
      'date': instance.date,
      'balance': instance.balance,
      'saving': instance.saving,
      'remainingBalance': instance.remainingBalance,
      'remainingSaving': instance.remainingSaving,
    };
