// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tierList.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Tierlist _$TierListFromJson(Map<String, dynamic> json) => Tierlist()
  ..id = json['id'] as num
  ..name = json['name'] as String
  ..user = User.fromJson(json['user'] as Map<String, dynamic>)
  ..description = json['description'] as String
  ..createdAt = json['createdAt'] as String
  ..category = Category.fromJson(json['category'] as Map<String, dynamic>);

Map<String, dynamic> _$TierListToJson(Tierlist instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'user': instance.user,
      'description': instance.description,
      'createdAt': instance.createdAt,
      'category': instance.category,
    };
