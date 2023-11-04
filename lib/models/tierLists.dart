import 'package:json_annotation/json_annotation.dart';
import 'package:tierlistapp/models/tierList.dart';
import "tierlistems.dart";
part 'tierLists.g.dart';

@JsonSerializable()
class Tierlists {
  Tierlists();

  late List<Tierlist> tierlists=[];
  
  factory Tierlists.fromJson(Map<String,dynamic> json) => _$TierListsFromJson(json);
  Map<String, dynamic> toJson() => _$TierListsToJson(this);
}
