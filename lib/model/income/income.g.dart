// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'income.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$IncomeImpl _$$IncomeImplFromJson(Map<String, dynamic> json) => _$IncomeImpl(
      id: json['id'] as int?,
      amount: json['amount'] as String? ?? "",
      date: json['date'] as String? ?? "",
      memo: json['memo'] as String? ?? "",
      category: json['category'] as String?,
      icon: json['icon'] as int?,
      color: json['color'] as int?,
      categoryIndex: json['categoryIndex'] as int?,
      walletId: json['walletId'] as int? ?? 1,
      savingsAmount: json['savingsAmount'] as String? ?? "",
      walletCashAmount: json['walletCashAmount'] as String? ?? "",
    );

Map<String, dynamic> _$$IncomeImplToJson(_$IncomeImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'amount': instance.amount,
      'date': instance.date,
      'memo': instance.memo,
      'category': instance.category,
      'icon': instance.icon,
      'color': instance.color,
      'categoryIndex': instance.categoryIndex,
      'walletId': instance.walletId,
      'savingsAmount': instance.savingsAmount,
      'walletCashAmount': instance.walletCashAmount,
    };
