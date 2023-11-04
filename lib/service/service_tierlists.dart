import 'dart:convert';

import 'package:http/http.dart';
import 'package:tierlistapp/models/index.dart';
import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';
import 'package:tierlistapp/models/tierList.dart';
import 'package:tierlistapp/models/tierlistems.dart';
class service_Tierlists{

  static const String url ="http://10.160.63.2:8080/api/tierLists";

  static Future<Tierlists> getTierlists() async{
      try{
        final respone = await http.get(Uri.parse(url));
        if(200==respone.statusCode){
          return parseTierlists(respone.body);
        
        } else{
          return Tierlists();
        }
      }
      catch(e){
        print('error ${e.toString()}');
        return Tierlists();
      }
  }
  static Tierlists parseTierlists(String responeBody){
    final parsed = json.decode(responeBody).cast<Map<String,dynamic>>();
    List<Tierlist> tierlists = parsed.map<Tierlist>((json)=>Tierlist.fromJson(json)).toList();
    Tierlists tl= Tierlists();
    tl.tierlists=tierlists;
    return tl;
  }

}