// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'income.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Income _$$_IncomeFromJson(Map<String, dynamic> json) => _$_Income(
      id: json['id'] as int? ?? 0,
      amount: json['amount'] as String? ?? "",
      date: json['date'] as String? ?? "",
      memo: json['memo'] as String? ?? "",
      category: json['category'] as String? ?? "",
    );

Map<String, dynamic> _$$_IncomeToJson(_$_Income instance) => <String, dynamic>{
      'id': instance.id,
      'amount': instance.amount,
      'date': instance.date,
      'memo': instance.memo,
      'category': instance.category,
    };
