import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:tierlistapp/components/items_categories.dart';
import 'package:tierlistapp/components/tier_category.dart';
import 'package:http/http.dart' as http;
import 'package:tierlistapp/models/index.dart';

class TierlistPage extends StatefulWidget {
  final int categoryId;
  final User user;
  const TierlistPage({Key? key, required this.categoryId,required this.user}) : super(key: key);

  @override
  _TierlistPageState createState() => _TierlistPageState(categoryId,user);
}

class _TierlistPageState extends State<TierlistPage> {
  final int categoryId;
final User user;
  _TierlistPageState(this.categoryId,this.user);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text("T I E R L I S T"),
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.add), // Use the add icon
            onPressed: () {
              _showAddLevelPopup(context);
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black, // สีขอบ
                      width: 2, // ความหนาขอบ
                    ),
                    borderRadius: BorderRadius.circular(8), // กำหนดขอบเป็นวงกลม
                    color: Color.fromARGB(
                        255, 255, 255, 255), // เปลี่ยนสีพื้นหลังตรงนี้
                  ),
                  child: ItemsCategories(categoryId: categoryId),
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black, // สีขอบ
                      width: 2, // ความหนาขอบ
                    ),
                    borderRadius: BorderRadius.circular(8), // กำหนดขอบเป็นวงกลม
                    color: Color.fromARGB(
                        255, 255, 255, 255), // เปลี่ยนสีพื้นหลังตรงนี้
                  ),
                  child: TiersCategory(categoryId: categoryId,user: user,),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddLevelPopup(BuildContext context) {
    TextEditingController nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Please Add Tier",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  decoration: InputDecoration(
                    labelText: "Level Name",
                  ),
                  obscureText: false,
                  controller: nameController,
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        await createTier(nameController.text);
                        Navigator.of(context).pop();
                        _refreshPage(); // เมื่อ Tier สร้างสำเร็จแล้ว
                      },
                      child: Text("Add"),
                    ),
                    SizedBox(width: 8),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("Cancel"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _refreshPage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => TierlistPage(categoryId: categoryId,user: user,),
      ),
    );
  }

  Future<void> createTier(String levelName) async {
    Uri urlTier = Uri.parse("http://10.160.63.2:8080/api/tiers");

    Map<String, dynamic> itemsData = {
      "name": levelName,
      "category": {"id": categoryId},
    };

    var response = await http.post(
      urlTier,
      headers: {
        "Content-Type": "application/json",
      },
      body: json.encode(itemsData),
    );

    if (response.statusCode == 201) {
      print("Tier created successfully.");
    } else {
      print("Failed to create Tiers. Status code: ${response.statusCode}");
    }
  }
}
