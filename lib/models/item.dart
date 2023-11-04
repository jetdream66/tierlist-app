import 'package:json_annotation/json_annotation.dart';
import "category.dart";
part 'item.g.dart';

@JsonSerializable()
class Item {
  Item();

  late num id;
  late String name;
  late Category category;
  late String description;
  late String imageUrl;
  
  factory Item.fromJson(Map<String,dynamic> json) => _$ItemFromJson(json);
  Map<String, dynamic> toJson() => _$ItemToJson(this);
}
