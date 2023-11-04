import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:tierlistapp/models/index.dart';
import 'package:tierlistapp/models/item.dart';
import 'package:tierlistapp/service/service_items.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
class ItemsCategories extends StatefulWidget {
  final int categoryId;

  const ItemsCategories({Key? key, required this.categoryId}) : super(key: key);

  @override
  _ItemsCategoriesState createState() => _ItemsCategoriesState(categoryId);
  
  
}

class _ItemsCategoriesState extends State<ItemsCategories> {
  final int categoryId;
  late Items items;
  late bool disBotton = false;
  _ItemsCategoriesState(this.categoryId);

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
                "",
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
  int crossAxisCount = 3; // แสดง 3 รายการต่อแถว
  double childAspectRatio = 1.2; // ปรับขนาดรูปใหญ่ขึ้น

  return GridView.count(
    crossAxisCount: crossAxisCount, // แสดง 3 รายการต่อแถว
    crossAxisSpacing: 8, // เพิ่มระยะห่างระหว่างรายการ
    mainAxisSpacing: 8,
    childAspectRatio: childAspectRatio, // ปรับขนาดรูปใหญ่ขึ้น
    children: List.generate(items.items.length, (itemIndex) {
      return Draggable<Item>(
        data: items.items[itemIndex],
        child: Container(
          width: 50,
          height: 50,
          margin: EdgeInsets.all(8),
          decoration: BoxDecoration(
            
          ),
          child: Transform.scale(
            scale: 0.8,
            child: Image.memory(
              base64.decode(items.items[itemIndex].imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        feedback: Container(
          width: 50,
          height: 50,
          margin: EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8), // กำหนดขอบเป็นวงกลม
            border: Border.all(
              color: Colors.black, // สีขอบ
              width: 2, // ความหนาขอบ
            ),
          ),
          child: Transform.scale(
            scale: 0.8,
            child: Image.memory(
              base64.decode(items.items[itemIndex].imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        childWhenDragging: Container(
          width: itemWidth - 16,
          height: itemWidth - 16,
          margin: EdgeInsets.all(8),
        ),
        onDragCompleted: () {
          setState(() {
            items.items.removeAt(itemIndex);
            if(items.items.isEmpty){
              
            }
            
          });
        },
      );
    }),
  );
}

}
