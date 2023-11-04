import 'package:json_annotation/json_annotation.dart';
import "tierList.dart";
import "item.dart";
import "tier.dart";
part 'tierlistitem.g.dart';

@JsonSerializable()
class Tierlistitem {
  Tierlistitem();

  late num id;
  late Tierlist tierlist;
  late Item item;
  late Tier tier;
  
  factory Tierlistitem.fromJson(Map<String,dynamic> json) => _$TierlistitemFromJson(json);
  Map<String, dynamic> toJson() => _$TierlistitemToJson(this);
}
