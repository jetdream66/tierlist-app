import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tierlistapp/components/edit_categories.dart';
import 'package:tierlistapp/components/items_categories.dart';
import 'package:tierlistapp/models/categories.dart';
import 'package:tierlistapp/models/index.dart';
import 'package:tierlistapp/pages/editCategories_page.dart';
import 'package:tierlistapp/pages/tierlist_page.dart';
import 'package:tierlistapp/service/service_categories.dart';

class ListCategories extends StatefulWidget {
  final User user;

  const ListCategories({Key? key, required this.user}) : super(key: key);
  @override
  _ListCategoriesState createState() => _ListCategoriesState(user);
}

class _ListCategoriesState extends State<ListCategories> {
  late Categories categories;
  final User user;
  _ListCategoriesState(this.user);
  @override
  void initState() {
    categories = Categories();
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    final categoriesFromServer = await service_categories.getCategories();
    setState(() {
      categories = categoriesFromServer;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: (categories.categories.isEmpty)
          ? Center(
              child: CircularProgressIndicator(),
            )
          : list(),
    );
  }

  Widget list() {
    return ListView.builder(
      itemCount:
          categories.categories == null ? 0 : categories.categories.length,
      itemBuilder: (BuildContext context, int index) {
        return row(index);
      },
    );
  }

  Widget row(int index) {
    final imageData = base64.decode(categories.categories[index].image);

    return Card(
      child: InkWell(
        onTap: () {
          final categoryId = categories.categories[index].id.toInt();
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => TierlistPage(
              categoryId: categoryId,
              user: user,
            ),
          ));
        },
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            // ให้แท็กอยู่ตรงกลาง
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                ClipRRect(
                  
                  child: Container(
                    decoration: BoxDecoration(
                     
                    ),
                    child: Image.memory(
                      imageData,
                      width: 100,
                      height: 100,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Text(
                  categories.categories[index].name,
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
      ),
    );
  }
}
