// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transfer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TransferImpl _$$TransferImplFromJson(Map<String, dynamic> json) =>
    _$TransferImpl(
      id: json['id'] as int?,
      fromWalletId: json['fromWalletId'] as int? ?? 0,
      toWalletId: json['toWalletId'] as int? ?? 0,
      amount: json['amount'] as String? ?? "",
      date: json['date'] as String? ?? "",
      memo: json['memo'] as String? ?? "",
    );

Map<String, dynamic> _$$TransferImplToJson(_$TransferImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fromWalletId': instance.fromWalletId,
      'toWalletId': instance.toWalletId,
      'amount': instance.amount,
      'date': instance.date,
      'memo': instance.memo,
    };
