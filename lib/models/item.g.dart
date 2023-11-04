// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Item _$ItemFromJson(Map<String, dynamic> json) => Item()
  ..id = json['id'] as num
  ..name = json['name'] as String
  ..category = Category.fromJson(json['category'] as Map<String, dynamic>)
  ..description = json['description'] as String
  ..imageUrl = json['imageUrl'] as String;

Map<String, dynamic> _$ItemToJson(Item instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'category': instance.category,
      'description': instance.description,
      'imageUrl': instance.imageUrl,
    };
