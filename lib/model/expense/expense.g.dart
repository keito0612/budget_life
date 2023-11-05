// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ExpenseImpl _$$ExpenseImplFromJson(Map<String, dynamic> json) =>
    _$ExpenseImpl(
      id: json['id'] as int?,
      amount: json['amount'] as String? ?? "",
      date: json['date'] as String? ?? "",
      memo: json['memo'] as String? ?? "",
      category: json['category'] as String?,
      icon: json['icon'] as int?,
      color: json['color'] as int?,
      categoryIndex: json['categoryIndex'] as int?,
    );

Map<String, dynamic> _$$ExpenseImplToJson(_$ExpenseImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'amount': instance.amount,
      'date': instance.date,
      'memo': instance.memo,
      'category': instance.category,
      'icon': instance.icon,
      'color': instance.color,
      'categoryIndex': instance.categoryIndex,
    };
