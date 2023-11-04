import 'package:json_annotation/json_annotation.dart';
import 'package:tierlistapp/models/item.dart';
import "tierlistems.dart";
part 'items.g.dart';

@JsonSerializable()
class Items {
  Items();

  late List<Item> items = [];
  
  factory Items.fromJson(Map<String,dynamic> json) => _$ItemsFromJson(json);
  Map<String, dynamic> toJson() => _$ItemsToJson(this);
}
