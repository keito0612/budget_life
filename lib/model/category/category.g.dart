// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CategoryImpl _$$CategoryImplFromJson(Map<String, dynamic> json) =>
    _$CategoryImpl(
      id: json['id'] as int?,
      category: json['category'] as String? ?? "",
      icon: json['icon'] as int?,
      color: json['color'] as int?,
    );

Map<String, dynamic> _$$CategoryImplToJson(_$CategoryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'category': instance.category,
      'icon': instance.icon,
      'color': instance.color,
    };
