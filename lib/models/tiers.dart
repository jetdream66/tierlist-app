import 'package:json_annotation/json_annotation.dart';
import 'package:tierlistapp/models/tier.dart';
import "tierlistems.dart";
part 'tiers.g.dart';

@JsonSerializable()
class Tiers {
  Tiers();

  late List<Tier> tiers=[];
  
  factory Tiers.fromJson(Map<String,dynamic> json) => _$TiersFromJson(json);
  Map<String, dynamic> toJson() => _$TiersToJson(this);
}
