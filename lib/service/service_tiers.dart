import 'package:tierlistapp/models/index.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:tierlistapp/models/tier.dart';
import 'package:tierlistapp/models/tierlistems.dart';

class service_tiers{

  static const String url = "http://10.160.63.2:8080/api/tiers_categories/";

static Future<Tiers> getTiers(categoryId) async {
  String apiUrl = '$url$categoryId';
  try {
    
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
   
      return parseTiers(response.body);

    } else {
      return Tiers();
    }
  } catch (e) {
    print('error ${e.toString()}');
    return Tiers();
  }
}

  static Tiers parseTiers(String responeBody){
    
    final parsed = json.decode(responeBody).cast<Map<String,dynamic>>();
    List<Tier> tiers = parsed.map<Tier>((json)=>Tier.fromJson(json)).toList();
    Tiers c= Tiers();
    c.tiers=tiers;
    return c;
  }

}