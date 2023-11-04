import 'package:json_annotation/json_annotation.dart';
import 'package:tierlistapp/models/tierlistitem.dart';
import "tierlistems.dart";
part 'tierlistitems.g.dart';

@JsonSerializable()
class Tierlistitems {
  Tierlistitems();

  late List<Tierlistitem> tierlistitems = [];
  
  factory Tierlistitems.fromJson(Map<String,dynamic> json) => _$TierlistitemsFromJson(json);
  Map<String, dynamic> toJson() => _$TierlistitemsToJson(this);
}
