// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recurring_income.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_RecurringIncome _$$_RecurringIncomeFromJson(Map<String, dynamic> json) =>
    _$_RecurringIncome(
      id: json['id'] as int?,
      amount: json['amount'] as String? ?? "",
      autoMaticInputDate: json['autoMaticInputDate'] as String? ?? "",
      autoMaticInputDay: json['autoMaticInputDay'] as int? ?? 1,
      autoMaticInuputDateIndex: json['autoMaticInuputDateIndex'] as int? ?? 1,
      memo: json['memo'] as String? ?? "",
      category: json['category'] as String?,
      icon: json['icon'] as int?,
      color: json['color'] as int?,
      categoryIndex: json['categoryIndex'] as int?,
    );

Map<String, dynamic> _$$_RecurringIncomeToJson(_$_RecurringIncome instance) =>
    <String, dynamic>{
      'id': instance.id,
      'amount': instance.amount,
      'autoMaticInputDate': instance.autoMaticInputDate,
      'autoMaticInputDay': instance.autoMaticInputDay,
      'autoMaticInuputDateIndex': instance.autoMaticInuputDateIndex,
      'memo': instance.memo,
      'category': instance.category,
      'icon': instance.icon,
      'color': instance.color,
      'categoryIndex': instance.categoryIndex,
    };
