import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:tierlistapp/components/edit_categories.dart';
import 'package:tierlistapp/components/list_categories.dart';
import 'package:tierlistapp/components/list_tierlists.dart';
import 'package:tierlistapp/components/my_button.dart';
import 'package:tierlistapp/components/my_drawer.dart';
import 'package:tierlistapp/models/categories.dart';
import 'package:tierlistapp/pages/categories_page.dart';
import 'package:tierlistapp/pages/item_set_page.dart';
import 'package:tierlistapp/pages/tierlist_page.dart';
import 'package:tierlistapp/service/service_categories.dart';

class EditCategoriesPage extends StatefulWidget {
  final int categoryId;
 const EditCategoriesPage({Key? key, required this.categoryId}) : super(key: key);

  @override
  _EditCategoriespPageState createState() => _EditCategoriespPageState(categoryId);
}

class _EditCategoriespPageState extends State<EditCategoriesPage> {
  final int categoryId;

  _EditCategoriespPageState(this.categoryId);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
   

      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              
              // Wrap ListTierLists with Expanded
              Expanded(
                child: EditCategories(categoryId: categoryId,),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

