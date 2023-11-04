// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tiers.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Tiers _$TiersFromJson(Map<String, dynamic> json) => Tiers()
  ..tiers = (json['tiers'] as List<dynamic>)
      .map((e) => Tier.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$TiersToJson(Tiers instance) => <String, dynamic>{
      'tiers': instance.tiers,
    };
