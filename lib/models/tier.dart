import 'package:json_annotation/json_annotation.dart';
import "category.dart";
part 'tier.g.dart';

@JsonSerializable()
class Tier {
  Tier();

  late num id;
  late String name;
  late Category category;
  
  factory Tier.fromJson(Map<String,dynamic> json) => _$TierFromJson(json);
  Map<String, dynamic> toJson() => _$TierToJson(this);
}
