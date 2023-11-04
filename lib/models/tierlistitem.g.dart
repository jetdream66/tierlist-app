// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tierlistitem.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Tierlistitem _$TierlistitemFromJson(Map<String, dynamic> json) => Tierlistitem()
  ..id = json['id'] as num
  ..tierlist = Tierlist.fromJson(json['tierlist'] as Map<String, dynamic>)
  ..item = Item.fromJson(json['item'] as Map<String, dynamic>)
  ..tier = Tier.fromJson(json['tier'] as Map<String, dynamic>);

Map<String, dynamic> _$TierlistitemToJson(Tierlistitem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tierlist': instance.tierlist,
      'item': instance.item,
      'tier': instance.tier,
    };
