import 'package:json_annotation/json_annotation.dart';
import "user.dart";
import "category.dart";
part 'tierList.g.dart';

@JsonSerializable()
class Tierlist {
  Tierlist();

  late num id;
  late String name;
  late User user;
  late String description;
  late String createdAt;
  late Category category;
  
  factory Tierlist.fromJson(Map<String,dynamic> json) => _$TierListFromJson(json);
  Map<String, dynamic> toJson() => _$TierListToJson(this);
}
