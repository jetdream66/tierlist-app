import 'dart:convert';
import 'dart:io';
import 'package:json_annotation/json_annotation.dart';
import 'package:http/http.dart';
import 'package:tierlistapp/models/index.dart';
import 'package:http/http.dart' as http;
import 'package:tierlistapp/models/tierlistems.dart';
import 'package:tierlistapp/models/tierlistitem.dart';

class service_itemsThisTierList  {
  static const String url = "http://10.160.63.2:8080/api/items_tierList/";

  static Future<Tierlistitems> getItemsThisTierLsit(tierlistId) async {
    String apiUrl = '$url$tierlistId';

    
    try {
     
      final respone = await http.get(Uri.parse(apiUrl));
      if (200 == respone.statusCode) {
        return parseItemsThisTierList(respone.body);
      } else {
        print("error");
        return Tierlistitems();
      }
    } catch (e) {
     
      print('error ${e.toString()}');

      return Tierlistitems();
    }
  }

  static Tierlistitems parseItemsThisTierList(String responseBody) {
      
      
      final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
      List<Tierlistitem> itemsTierLists = parsed.map<Tierlistitem>((json) => Tierlistitem.fromJson(json)).toList();
      Tierlistitems tl = Tierlistitems();
      tl.tierlistitems = itemsTierLists;
      
      return tl;
      
   
  }
}
