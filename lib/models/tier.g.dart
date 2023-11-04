// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tier.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Tier _$TierFromJson(Map<String, dynamic> json) => Tier()
  ..id = json['id'] as num
  ..name = json['name'] as String
  ..category = Category.fromJson(json['category'] as Map<String, dynamic>);

Map<String, dynamic> _$TierToJson(Tier instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'category': instance.category,
    };
