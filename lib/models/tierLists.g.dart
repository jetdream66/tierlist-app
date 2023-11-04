// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tierLists.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Tierlists _$TierListsFromJson(Map<String, dynamic> json) => Tierlists()
  ..tierlists = (json['tierlists'] as List<dynamic>)
      .map((e) => Tierlist.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$TierListsToJson(Tierlists instance) => <String, dynamic>{
      'tierlists': instance.tierlists,
    };
