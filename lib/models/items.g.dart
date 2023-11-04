// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'items.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Items _$ItemsFromJson(Map<String, dynamic> json) => Items()
  ..items = (json['items'] as List<dynamic>)
      .map((e) => Item.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$ItemsToJson(Items instance) => <String, dynamic>{
      'items': instance.items,
    };
