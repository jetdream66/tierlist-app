import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tierlistapp/components/my_textfield.dart';
import 'package:tierlistapp/models/index.dart';
import 'package:tierlistapp/pages/categories_page.dart';
import 'dart:convert';

import 'package:tierlistapp/pages/home_page.dart';

class ItemSet extends StatefulWidget {
  final User user;

  ItemSet({Key? key, required this.user});

  @override
  _ItemSetState createState() => _ItemSetState(user);
}

class _ItemSetState extends State<ItemSet> {
  final User user;
  _ItemSetState(this.user);

  ImagePicker picker = ImagePicker();
  TextEditingController controller = TextEditingController();
  List<File?> imageList = [];
  List<String> imageList_url = [];
  late String base64MainImage = "";
  File? mainImage;

  TextEditingController nameController = TextEditingController();

  Future<String> _convertImageToBase64(String imagePath) async {
    File imageFile = File(imagePath);
    Uint8List imageBytes = await imageFile.readAsBytes();
    return base64Encode(imageBytes);
  }

  Future<void> createCategory() async {
    Uri url_Catergories = Uri.parse("http://10.160.63.2:8080/api/categories");
    late bool check_Create = false;
    Uri url_items = Uri.parse("http://10.160.63.2:8080/api/items");

    String enteredText = nameController.text;
    if (base64MainImage.isEmpty ||
        imageList_url.isEmpty ||
        enteredText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter complete information.')),
      );
    } else {
      Map<String, dynamic> categoryData = {
        "name": "$enteredText",
        "image": "$base64MainImage",
      };

      var response = await http.post(
        url_Catergories,
        headers: {
          "Content-Type": "application/json",
        },
        body: json.encode(categoryData),
      );

      if (response.statusCode == 201) {
        print("Category created successfully.");

        Map<String, dynamic> responseData;
        try {
          int categoryId = int.parse(response.body);

          for (int i = 0; i < imageList_url.length; i++) {
            Map<String, dynamic> itemsData = {
              "name": "$enteredText$i",
              "description": "This is an example item $i",
              "category": {"id": categoryId},
              "imageUrl": imageList_url[i]
            };
            var response_items = await http.post(
              url_items,
              headers: {
                "Content-Type": "application/json",
              },
              body: json.encode(itemsData),
            );

            if (response_items.statusCode == 201) {
            } else {
              print(
                  "Failed to create items. Status code: ${response_items.statusCode}");
            }
            setState(() {
              check_Create = true;
            });
          }
        } catch (e) {
          print('Failed to decode JSON response: $e');
        }
      } else {
        print("Failed to create category. Status code: ${response.statusCode}");
      }
      if (check_Create == true) {
        setState(() {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Create Category Success')),
          );
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => CategoriesPage(user: user)));
        });
      } else {}
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text("A D D  S E T"),
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: () async {
                createCategory();
              },
              child: Icon(
                Icons.save,
                size: 30,
              ),
            ),
          )
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                  onTap: () async {
                    final pickedFile = await picker.pickImage(
                      source: ImageSource.gallery,
                    );
                    if (pickedFile != null) {
                      setState(() {
                        mainImage = File(pickedFile.path);
                      });
                      base64MainImage =
                          await _convertImageToBase64(pickedFile.path);
                    } else {
                      print('No image selected.');
                    }
                  },
                  child: Stack(
                    children: [
                      Container(
                        height: 150,
                        width: 150,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: mainImage != null
                              ? Image.file(mainImage!, fit: BoxFit.cover)
                              : Icon(
                                  Icons.add_a_photo,
                                  size: 80,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .inversePrimary,
                                ),
                        ),
                      ),
                      if (mainImage != null)
                        Positioned(
                          top: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () {
                              // ทำสิ่งที่คุณต้องการเมื่อคลิกที่ไอคอนสลับ
                              // ในกรณีนี้คุณอาจต้องเขียนโค้ดเพิ่มเพื่อดำเนินการในส่วนนี้
                              print('Swapping mainImage');
                            },
                            child: Container(
                              width: 25,
                              height: 25,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.blue, // สีที่คุณต้องการ
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.swap_horiz,
                                  size: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  )),

              const SizedBox(height: 25),

              MyTextField(
                hintText: "Name",
                obscureText: false,
                controller: nameController,
              ),

              Expanded(
                child: Card(
                    color: Theme.of(context).colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide.none,
                    ),
                    elevation: 0,
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        mainAxisSpacing: 4,
                      ),
                      itemCount: imageList.length + 1,
                      itemBuilder: (BuildContext context, int index) {
                        if (index == 0) {
                          return Center(
                            child: GestureDetector(
                              onTap: () async {
                                final pickedFile = await picker.pickImage(
                                  source: ImageSource.gallery,
                                );
                                if (pickedFile != null) {
                                  setState(() {
                                    imageList.add(File(pickedFile.path));
                                  });
                                  String base64Image =
                                      await _convertImageToBase64(
                                    pickedFile.path,
                                  );
                                  imageList_url.add(base64Image);
                                } else {
                                  print('No image selected.');
                                }
                              },
                              child: Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .background,
                                    width: 2,
                                  ),
                                ),
                                child: Icon(
                                  Icons.add_a_photo,
                                  size: 30,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .inversePrimary,
                                ),
                              ),
                            ),
                          );
                        } else if (index <= imageList.length) {
                          final File? image = imageList[index - 1];
                          if (image != null) {
                            return Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(3),
                                  child: Center(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.file(
                                        image,
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        imageList.removeAt(index - 1);
                                        imageList_url.removeAt(index - 1);
                                      });
                                    },
                                    child: Container(
                                      width: 25,
                                      height: 25,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.red,
                                      ),
                                      child: Center(
                                        child: Icon(
                                          Icons.close,
                                          size: 20,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }
                        }
                        return Container();
                      },
                    )),
              ),

              // Save Button
            ],
          ),
        ),
      ),
    );
  }
}
