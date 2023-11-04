import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:tierlistapp/components/items_categories.dart';
import 'package:tierlistapp/components/tier_category.dart';
import 'package:http/http.dart' as http;
import 'package:tierlistapp/models/index.dart';
import 'package:tierlistapp/models/item.dart';
import 'package:tierlistapp/models/tier.dart';
import 'package:tierlistapp/models/tierlistitem.dart';
import 'package:tierlistapp/service/service_itemsThisTierList.dart';
import 'package:tierlistapp/service/service_tiers.dart';
import 'package:screenshot/screenshot.dart';

class UpdateTierlistPage extends StatefulWidget {
  final int tierlistId;
  final int categoryId;
  const UpdateTierlistPage(
      {Key? key, required this.tierlistId, required this.categoryId})
      : super(key: key);

  @override
  _UpdateTierlistPageState createState() =>
      _UpdateTierlistPageState(tierlistId, categoryId);
}

class _UpdateTierlistPageState extends State<UpdateTierlistPage> {
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
  final int tierlistId;
  final int categoryId;
  late Tierlistitems itemThisTierList;
  late Tiers tiers;
  _UpdateTierlistPageState(this.tierlistId, this.categoryId);
  late List<int> iterlistIds = [];
  Map<int, List<Item>> itemsInTiers = {};
  Map<int, List<Tierlistitem>> everyitemsInTiers = {};
  final ScreenshotController screenShotController = ScreenshotController();

  @override
  void initState() {
    tiers = Tiers();
    itemThisTierList = Tierlistitems();

    super.initState();
    fetchTiers();
  }

  Future<void> fetchTiers() async {
    print(tierlistId);
    final tiersThisTierListFromServer =
        await service_itemsThisTierList.getItemsThisTierLsit(tierlistId);
    final tiersFromServer = await service_tiers.getTiers(categoryId);

    setState(() {
      tiers = tiersFromServer;
      itemThisTierList = tiersThisTierListFromServer;
    });

    for (final tier in tiers.tiers) {
      itemsInTiers[tier.id.toInt()] = [];
      everyitemsInTiers[tier.id.toInt()] = [];
    }

    for (final item in itemThisTierList.tierlistitems) {
      for (final tier in tiers.tiers) {
        if (item.tier.id == tier.id) {
          everyitemsInTiers[tier.id.toInt()]!.add(item);
          itemsInTiers[tier.id.toInt()]!.add(item.item);
          iterlistIds.add(item.id.toInt());
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text("T I E R L I S T"),
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Container(
                height: 200.0,
                child: Screenshot(
                  controller: screenShotController,
                  child: (tiers.tiers.isEmpty)
                      ? Center(
                          child: Text(
                            "",
                            style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      : list(),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                updateTierlist(
                    iterlistIds.length, everyitemsInTiers, iterlistIds);
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: Icon(Icons.save),
            ),
          ],
        ),
      ),
    );
  }

  Widget list() {
    return ListView.builder(
      itemCount: tiers.tiers == null ? 0 : tiers.tiers.length,
      itemBuilder: (BuildContext context, int index) {
        return row(index);
      },
    );
  }

  Widget row(int index) {
    return Center(
      child: Container(
        width: double.infinity,
        child: InkWell(
          onTap: () {
            // Handle what you want to do when clicking on the tiers that add items
          },
          child: Card(
            child: DragTarget<Tierlistitem>(
              // เปลี่ยนเป็น Tierlistitem
              builder: (context, candidateData, rejectedData) {
                return Container(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: <Widget>[
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
                          width: 10.0,
                        ),
                        if (everyitemsInTiers
                            .containsKey(tiers.tiers[index].id))
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children:
                                  everyitemsInTiers[tiers.tiers[index].id]!
                                      .map((item) {
                                return Draggable<Tierlistitem>(
                                  // เปลี่ยนเป็น Tierlistitem
                                  data: item,
                                  child: Container(
                                    width: 50,
                                    height: 50,
                                    child: Image.memory(
                                      base64.decode(item.item.imageUrl),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  feedback: Container(
                                    width: 50,
                                    height: 50,
                                    child: Image.memory(
                                      base64.decode(item.item.imageUrl),
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
              onWillAccept: (data) {
                // ตรวจสอบว่า Item ยังไม่อยู่ใน Tier นี้
                final tierId = tiers.tiers[index].id;
                return !everyitemsInTiers[tierId]!.contains(data);
              },
              onAccept: (data) {
                // เพิ่ม Item ใน everyitemsInTiers และ itemsInTiers
                setState(() {
                  final tierId = tiers.tiers[index].id;
                  everyitemsInTiers[tierId]!.add(data);
                  itemsInTiers[tierId]!.add(data.item);
                });
              },
            ),
          ),
        ),
      ),
    );
  }

  void captureAndSaveScreenshot() {
    screenShotController.capture().then((image) {
      ImageGallerySaver.saveImage(Uint8List.fromList(image!));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Screenshot saved to gallery')),
      );
    });
  }

  void addToTier(int tierId, Tierlistitem data) {
    setState(() {
      if (itemsInTiers[tierId] == null) {
        itemsInTiers[tierId] = [];
      }
      for (final tierKey in itemsInTiers.keys) {
        if (tierKey != tierId) {
          itemsInTiers[tierKey]!.remove(data.item);
        }
      }
      itemsInTiers[tierId]!.add(data.item);

      if (everyitemsInTiers[tierId] == null) {
        everyitemsInTiers[tierId] = [];
      }
      everyitemsInTiers[tierId]!.add(data);
    });
  }

  void removeFromTier(int tierId, Tierlistitem data) {
    if (itemsInTiers[tierId] != null) {
      setState(() {
        itemsInTiers[tierId]!.remove(data.item);
        everyitemsInTiers[tierId]!.remove(data);
      });
    }
  }

  Future<void> updateTierlist(
    int tierlistlength,
    Map<int, List<Tierlistitem>> everyitemsInTiers,
    List<int> iterlistId,
  ) async {
    final baseUrl = 'http://10.160.63.2:8080/api';
    bool allItemsUpdated = false;

    for (final tier in tiers.tiers) {
      final tierId = tier.id;

      if (everyitemsInTiers.containsKey(tierId) &&
          everyitemsInTiers[tierId]!.isNotEmpty) {
        for (final item in everyitemsInTiers[tierId]!) {
          final apiUrl = Uri.parse('$baseUrl/tierListItems/${item.id.toInt()}');
          print(apiUrl);
          print(item.tierlist.id.toInt());
          print(item.item.id.toInt());
          print(tierId.toInt());
          Map<String, dynamic> itemsTierlistData = {
            "tierList": {"id": item.tierlist.id.toInt()},
            "item": {"id": item.item.id.toInt()},
            "tier": {"id": tierId.toInt()},
          };
          var response_tierlist = await http.put(
            apiUrl,
            headers: {
              "Content-Type": "application/json",
            },
            body: json.encode(itemsTierlistData),
          );
          if (response_tierlist.statusCode == 200) {
            setState(() {
                allItemsUpdated = true;
            });
          
          } else {
            print(
                "Failed to create tierlist. Status code: ${response_tierlist.statusCode}");
          }
        }
      }
    }
    if (allItemsUpdated == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Updated Tierlist success')),
      );
    }
  }
}
