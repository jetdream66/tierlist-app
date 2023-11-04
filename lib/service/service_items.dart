import 'dart:convert';

import 'package:http/http.dart';
import 'package:tierlistapp/models/index.dart';
import 'package:http/http.dart' as http;
import 'package:tierlistapp/models/item.dart';

class service_items{

  static const String url = "http://10.160.63.2:8080/api/items_categories/";

static Future<Items> getItems(categoryId) async {
  String apiUrl = '$url$categoryId';
  try {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      
      return parseItems(response.body);

    } else {
      return Items();
    }
  } catch (e) {
    print('error ${e.toString()}');
    return Items();
  }
}
  static Items parseItems(String responeBody){
    final parsed = json.decode(responeBody).cast<Map<String,dynamic>>();
    List<Item> items = parsed.map<Item>((json)=>Item.fromJson(json)).toList();
    Items c= Items();
    c.items=items;
    return c;
  }

}