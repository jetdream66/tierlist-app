import 'dart:convert';

import 'package:http/http.dart';
import 'package:tierlistapp/models/index.dart';
import 'package:http/http.dart' as http;

class service_categories{

  static const String url ="http://10.160.63.2:8080/api/categories";

  static Future<Categories> getCategories() async{
      try{
        
        final respone = await http.get(Uri.parse(url));
        if(200==respone.statusCode){
          return parseCategories(respone.body);
        
        } else{
          return Categories();
        }
      }
      catch(e){
        print('error ${e.toString()}');
        return Categories();
      }
  }
  static Categories parseCategories(String responeBody){
    
    final parsed = json.decode(responeBody).cast<Map<String,dynamic>>();
    List<Category> categories = parsed.map<Category>((json)=>Category.fromJson(json)).toList();
    Categories c= Categories();
    c.categories=categories;
    return c;
  }

}