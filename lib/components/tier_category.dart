import 'package:flutter/material.dart';
import 'package:tierlistapp/components/items_categories.dart';
import 'package:tierlistapp/models/index.dart';
import 'package:tierlistapp/models/item.dart';
import 'package:tierlistapp/pages/home_page.dart';
import 'package:tierlistapp/service/service_items.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tierlistapp/service/service_tiers.dart';
import 'package:tierlistapp/components/items_categories.dart';
import 'package:provider/provider.dart';

class TiersCategory extends StatefulWidget {
  final int categoryId;
  final User user;

  const TiersCategory({Key? key, required this.categoryId, required this.user})
      : super(key: key);

  @override
  _TiersCategoriesState createState() => _TiersCategoriesState(
      categoryId, user); // ส่ง disBotton ไปยัง _TiersCategoriesState
}

class _TiersCategoriesState extends State<TiersCategory> {
  late final bool disBotton = true;
  final int categoryId;
  final User user;
  late Tiers tiers;
  List<Color> tierNameColors = [
    Colors.red,
    Colors.purple,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.teal,
    Colors.yellow,
    Colors.pink,
    Colors.brown,
    Colors.indigo,
  ];

  _TiersCategoriesState(this.categoryId, this.user); // รับค่า disBotton

  Map<int, List<Item>> itemsInTiers = {};

  @override
  void initState() {
    tiers = Tiers();

    super.initState();
    final disBottonProvider =
        Provider.of<DisBottonProvider>(context, listen: false);
    disBottonProvider.setDisBotton(true);
    fetchTiers();
  }

  void removeFromTier(int tierId, data) {
    setState(() {
      itemsInTiers[tierId]!.remove(data);
    });
  }

  Future<void> fetchTiers() async {
    final tiersFromServer = await service_tiers.getTiers(categoryId);
    setState(() {
      tiers = tiersFromServer;
    });

    for (final tier in tiers.tiers) {
      itemsInTiers[tier.id.toInt()] = [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final disBottonProvider = Provider.of<DisBottonProvider>(context);
    return Column(
      children: [
        Container(
          height: 200.0,
          child: (tiers.tiers.isEmpty)
              ? Center(
                  child: Text(
                    "Please Add tier",
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : list(),
        ),
        ElevatedButton(
          onPressed:
              disBottonProvider.disBotton ? null : () => saveTiers(categoryId),
          style: ElevatedButton.styleFrom(
            primary: Colors.black,
            onPrimary: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          child: Icon(Icons.save),
        ),
      ],
    );
  }

  Widget list() {
    double itemWidth = (MediaQuery.of(context).size.width - 16) / 5;
    return ListView.builder(
      itemCount: tiers.tiers == null ? 0 : tiers.tiers.length,
      itemBuilder: (BuildContext context, int index) {
        return row(index, itemWidth);
      },
    );
  }

  Widget row(int index, double itemWidth) {
    return Center(
      child: Container(
        width: double.infinity, // Make the container take up full width
        child: InkWell(
          onTap: () {
            // ทำสิ่งที่คุณต้องการเมื่อคลิกที่ tiers ที่เพิ่ม item ลงไป
          },
          child: Card(
            child: DragTarget<Item>(
              builder: (context, candidateData, rejectedData) {
                // แสดง items ที่ถูกลากมาที่นี่ (ถ้ามี)
                return Container(
                  color: const Color.fromARGB(
                      255, 255, 255, 255), // ตั้งพื้นหลังเป็นสีดำ
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: <Widget>[
                        // แยก tiers.tiers[index].name เป็น Box ที่แสดงชิดกึ่งกลางและสีพื้นหลังสุ่ม
                        Container(
                          width: 50,
                          height: 50,
                          color: tierNameColors[index % tierNameColors.length],
                          alignment: Alignment.center,
                          child: Text(
                            tiers.tiers[index].name,
                            style: const TextStyle(
                              fontSize: 16.0,
                              color: Color.fromARGB(255, 255, 255, 255),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10.0, // เพิ่มระยะห่างระหว่าง Box และ items
                        ),
                        if (itemsInTiers.containsKey(tiers.tiers[index].id))
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: itemsInTiers[tiers.tiers[index].id]!
                                  .map((item) {
                                return Draggable<Item>(
                                  data: item,
                                  child: Container(
                                    width: 50,
                                    height: 50,
                                    child: Image.memory(
                                      base64.decode(item.imageUrl),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  feedback: Container(
                                    width: 50,
                                    height: 50,
                                    child: Image.memory(
                                      base64.decode(item.imageUrl),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  onDragCompleted: () {
                                    removeFromTier(
                                      tiers.tiers[index].id.toInt(),
                                      item,
                                    );
                                  },
                                );
                              }).toList(),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
              onAccept: (data) {
                setState(() {
                  itemsInTiers[tiers.tiers[index].id]!.add(data);
                });
                final disBottonProvider =
                    Provider.of<DisBottonProvider>(context, listen: false);
                disBottonProvider.setDisBotton(
                    false); // เมื่อมี items อยู่ใน tiers ให้เปลี่ยนเป็น clickable
              },
              onWillAccept: (data) {
                return !itemsInTiers[tiers.tiers[index].id]!.contains(data);
              },
            ),
          ),
        ),
      ),
    );
  }

  void saveTiers(categoryId) async {
    Uri url_createTierList =
        Uri.parse("http://10.160.63.2:8080/api/tierLists");
    DateTime currentDateTime = DateTime.now();
    bool allItemsUpdated = false;
    Map<String, dynamic> tierListData = {
      "name": "",
      "user": {"id": user.id.toInt()},
      "description": "",
      "category": {"id": categoryId.toInt()}
    };

    var response = await http.post(
      url_createTierList,
      headers: {
        "Content-Type": "application/json",
      },
      body: json.encode(tierListData),
    );

    if (response.statusCode == 201) {
      print("Tierlist created successfully.");

      Uri url_createTierListItems =
          Uri.parse("http://10.160.63.2:8080/api/tierListItems");

      try {
        int tierlistId = int.parse(response.body);

        for (final tier in tiers.tiers) {
          final tierId = tier.id;

          if (itemsInTiers.containsKey(tierId) &&
              itemsInTiers[tierId]!.isNotEmpty) {
            for (final item in itemsInTiers[tierId]!) {
              print(item.id);
              Map<String, dynamic> itemsTierlistData = {
                "tierList": {"id": tierlistId},
                "item": {"id": item.id.toInt()},
                "tier": {"id": tierId.toInt()},
              };
              var response_tierlist = await http.post(
                url_createTierListItems,
                headers: {
                  "Content-Type": "application/json",
                },
                body: json.encode(itemsTierlistData),
              );
              if (response_tierlist.statusCode == 201) {
                allItemsUpdated = true;
              } else {
                print(
                    "Failed to create tierlist. Status code: ${response.statusCode}");
              }
            }
          }
        }
      } catch (e) {
        print('Failed to decode JSON response: $e');
      }
    } else {
      print("Failed to create tierlist. Status code: ${response.statusCode}");
    }
    if (allItemsUpdated == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Create Tierlist success')),
      );
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => HomepPage(widget.user),
      ));
    }
  }
}

class DisBottonProvider extends ChangeNotifier {
  bool _disBotton = true;

  bool get disBotton => _disBotton;

  void setDisBotton(bool value) {
    _disBotton = value;
    notifyListeners();
  }
}
