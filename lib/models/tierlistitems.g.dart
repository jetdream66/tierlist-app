// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tierlistitems.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Tierlistitems _$TierlistitemsFromJson(Map<String, dynamic> json) =>
    Tierlistitems()
      ..tierlistitems = (json['tierlistitems'] as List<dynamic>)
          .map((e) => Tierlistitem.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$TierlistitemsToJson(Tierlistitems instance) =>
    <String, dynamic>{
      'tierlistitems': instance.tierlistitems,
    };
