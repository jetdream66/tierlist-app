import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:tierlistapp/components/items_categories.dart';
import 'package:tierlistapp/components/update_tierlists.dart';
import 'package:tierlistapp/models/categories.dart';
import 'package:tierlistapp/models/index.dart';
import 'package:tierlistapp/pages/tierlist_page.dart';

import 'package:tierlistapp/service/service_categories.dart';
import 'package:tierlistapp/service/service_tierlists.dart';

class ListTierLists extends StatefulWidget {
  @override
  _ListTierListsState createState() => _ListTierListsState();
}

class _ListTierListsState extends State<ListTierLists> {
  late Tierlists tierlists;

  @override
  void initState() {
    tierlists = Tierlists();
    super.initState();
    fetchTierLists();
  }

  Future<void> fetchTierLists() async {
    final tierlistsFromServer = await service_Tierlists.getTierlists();
    setState(() {
      tierlists = tierlistsFromServer;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: (tierlists.tierlists.isEmpty)
          ? Center(
              child: CircularProgressIndicator(),
              
            )
          : list(),
    );
  }

  Widget list() {
    return ListView.builder(
      itemCount: tierlists.tierlists == null ? 0 : tierlists.tierlists.length,
      itemBuilder: (BuildContext context, int index) {
        return row(index);
      },
    );
  }

  Widget row(int index) {
    final imageData = base64.decode(tierlists.tierlists[index].category.image);
    return Card(
      child: InkWell(
        onTap: () {
          final tierlistId = tierlists.tierlists[index].id.toInt();
          final categoryId = tierlists.tierlists[index].category.id.toInt();
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => UpdateTierlistPage(
              tierlistId: tierlistId,
              categoryId: categoryId,
            ),
          ));
        },
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Confirm Delete Tierlist?'),
                          content: Text('คุณต้องการลบรายการนี้ใช่หรือไม่?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // ปิดกล่องสนทนา
                              },
                              child: Text('ยกเลิก'),
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  deleteTierlist(
                                      tierlists.tierlists[index].id.toInt());
                                });

                                Navigator.of(context).pop(); // ปิดกล่องสนทนา
                              },
                              child: Text('ลบ'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image.memory(
                  imageData,
                  width: 100,
                  height: 100,
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Text(
                tierlists.tierlists[index].name,
                style: const TextStyle(
                  fontSize: 16.0,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<int> deleteTierlist(int tierlistId) async {
    final baseUrl = 'http://10.160.63.2:8080/api/tierLists/';
    Uri apiUrl = Uri.parse('$baseUrl$tierlistId');
    var response_tierlist = await http.delete(
      apiUrl,
      headers: {
        "Content-Type": "application/json",
      },
    );

    if (response_tierlist.statusCode == 200) {
      // การลบสำเร็จ
      fetchTierLists();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Delete TierList Success')),
      );
      print('ลบสำเร็จ');
      return 200; // ส่งค่าสถานะการลบกลับเมื่อลบสำเร็จ
    } else {
      // การลบไม่สำเร็จ ให้ตรวจสอบสาเหตุจาก response_tierlist.body
      print('ลบไม่สำเร็จ: ${response_tierlist.body}');
      return response_tierlist.statusCode; // ส่งค่าสถานะการลบกลับในกรณีอื่น
    }
  }
}
