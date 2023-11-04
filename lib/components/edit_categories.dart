import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tierlistapp/models/index.dart';
import 'package:tierlistapp/pages/categories_page.dart';
import 'package:tierlistapp/service/service_items.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tierlistapp/service/service_tiers.dart';

class EditCategories extends StatefulWidget {
  final int categoryId;

  const EditCategories({Key? key, required this.categoryId}) : super(key: key);

  @override
  _EditCategoriesState createState() => _EditCategoriesState(categoryId);
}

class _EditCategoriesState extends State<EditCategories> {
  final int categoryId;
  late Items items;
  ImagePicker picker = ImagePicker();
  _EditCategoriesState(this.categoryId);

  List<String> imgInCategories = [];

  @override
  void initState() {
    items = Items();
    super.initState();
    fetchItems();
  }

  Future<void> fetchItems() async {
    final itemsFromServer = await service_items.getItems(categoryId);
    setState(() {
      items = itemsFromServer;
      imgInCategories = items.items.map((item) => item.imageUrl).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    double itemWidth = (MediaQuery.of(context).size.width - 16) / 5;

    return Container(
      height: 200.0,
      child: (items.items.isEmpty)
          ? Center(
              child: Text(
                "No items available.",
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : list(itemWidth),
    );
  }

  Widget list(double itemWidth) {
    return Column(
      children: [
        Expanded(
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, // แสดง 3 รายการต่อแถว
              crossAxisSpacing: 8, // เพิ่มระยะห่างระหว่างรายการ
              mainAxisSpacing: 8,
              childAspectRatio: 1.2, // ปรับขนาดรูปใหญ่ขึ้น
            ),
            itemCount:
                imgInCategories.length, // ใช้จำนวนรูปภาพใน imgInCategories
            itemBuilder: (BuildContext context, int itemIndex) {
              return Stack(
                children: [
                  Container(
                    width: itemWidth - 10,
                    height: itemWidth - 10,
                    margin: EdgeInsets.all(8),
                    child: Transform.scale(
                      scale: 0.8,
                      child: Image.memory(
                        base64.decode(imgInCategories[itemIndex]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 5,
                    right: 5,
                    child: IconButton(
                      icon: Icon(Icons.swap_horiz), // รูปไอคอน Swap
                      onPressed: () async {
                        final pickedFile = await picker.pickImage(
                          source: ImageSource.gallery,
                        );
                        if (pickedFile != null) {
                          final newImage =
                              await _convertImageToBase64(pickedFile.path);
                          setState(() {
                            imgInCategories[itemIndex] = newImage;
                          });
                        } else {
                          print('No image selected.');
                        }
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        ElevatedButton(
          onPressed: () async {
            await updateItems(imgInCategories);
            setState(() {
              // อัพเดตสถานะหลังจากที่ updateItems เสร็จสิ้น
            });
          },
          child: Text('Update'),
        ),
      ],
    );
  }

  Future<String> _convertImageToBase64(String imagePath) async {
    File imageFile = File(imagePath);
    Uint8List imageBytes = await imageFile.readAsBytes();
    return base64Encode(imageBytes);
  }

  Future<void> updateItems(List<String> imgInCategories) async {
    print(imgInCategories.length);
    Uri url_update_items = Uri.parse("http://10.160.63.2:8080/api/items/");

    for (int i = 1; i <= imgInCategories.length; i++) {
      Uri apiUrl = Uri.parse('$url_update_items$i'); 

      Map<String, dynamic> itemsData = {
        "name": "Item Name $i",
        "description": "Item Description $i",
        "category": {"id": categoryId},
        "imageUrl": imgInCategories[i-1]
      };
      var response = await http.put(
      apiUrl,
      headers: {
        "Content-Type": "application/json",
      },
      body: json.encode(itemsData),
    );

      if (response.statusCode == 200) {
        showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text("Success"),
                  content: Text("Item updated successfully."),
                  actions: [
                    Container(
                      padding: EdgeInsets.all(16.0), // ความรู้สึกเป็นมิติ
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pop(); // ปิด AlertDialog
                          
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black, // ตั้งสีเป็นดำ
                            borderRadius:
                                BorderRadius.circular(8.0), // ขอบมนมิติ
                          ),
                          padding: EdgeInsets.all(12.0),
                          child: Center(
                            child: Text(
                              "OK",
                              style: TextStyle(
                                color: Colors.white, // ตั้งสีข้อความเป็นขาว
                                fontWeight: FontWeight.bold, // ตั้งตัวหนา
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
      } else {
        print('Failed to update Item $i. Error: ${response.statusCode}');
      }
    }
  }
}
