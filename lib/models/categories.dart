import 'package:json_annotation/json_annotation.dart';
import "category.dart";
part 'categories.g.dart';

@JsonSerializable()
class Categories {
  Categories();

  late List<Category> categories =[];
  
  factory Categories.fromJson(Map<String,dynamic> json) => _$CategoriesFromJson(json);
  Map<String, dynamic> toJson() => _$CategoriesToJson(this);
}
