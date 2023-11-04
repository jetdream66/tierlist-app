import 'package:flutter/material.dart';
import 'package:tierlistapp/components/list_categories.dart';
import 'package:tierlistapp/components/my_drawer.dart';
import 'package:tierlistapp/models/index.dart';
import 'package:tierlistapp/pages/item_set_page.dart';

class CategoriesPage extends StatelessWidget {
  final User user;

  CategoriesPage({Key? key, required this.user});
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    
      appBar: AppBar(
        
        title: const Text(
          "C A T E G O R I E S",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ItemSet(user: user,),
                ));
              },
              child: Icon(
                Icons.add_to_photos_outlined,
                size: 30,
              ),
            ),
          )
        ],
      ),
      drawer: MyDrawer(user: user,),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center, 
              children: [
                Expanded(
                child: ListCategories(user: user,),
              ),
              ]),
        ),
      ),
    );
  }
}
