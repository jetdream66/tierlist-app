import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tierlistapp/auth/login_or_register.dart';
import 'package:tierlistapp/components/my_button.dart';
import 'package:tierlistapp/components/my_textfield.dart';
import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;

  RegisterPage({super.key, required this.onTap});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  Future<String> _convertImageToBase64(String imagePath) async {
    File imageFile = File(imagePath);
    Uint8List imageBytes = await imageFile.readAsBytes();
    return base64Encode(imageBytes);
  }

  ImagePicker picker = ImagePicker();
  File? mainImage;
  late String base64MainImage = "";

  // register method
  void register(BuildContext context) async {
    Uri url = Uri.parse("http://10.160.63.2:8080/api/register");
    String username = usernameController.text;
    String email = emailController.text;
    String password = passwordController.text;
    String confirmPassword = confirmPasswordController.text;
    if (username.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty ||
        base64MainImage.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter complete information.')),
      );
    } else {
      if (password == confirmPassword) {
        var res = await http.post(url,
            headers: {'Content-Type': 'application/json'},
            body: json.encode({
              'username': username,
              'email': email,
              'password': password,
              'imageUrl': base64MainImage, // ส่งรูปภาพในรูปแบบ Base64
            }));

        if (res.statusCode == 201) {
          // Registration successful
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Registration success.')),
          );
          print("Registration success.");
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => LoginOrRegister(),
            ),
          );
        } else if (res.statusCode == 409) {
          // HTTP status code 409 typically indicates a conflict, meaning a user with the same email already exists.
          print('Registration failed. User with this email already exists.');
        } else {
          // Handle other error cases
          print('Registration failed. An error occurred.');
        }
      } else {
        print(
            'Registration failed. Please check Password and Confirm Password.');
      }
    }
  }

  void pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        mainImage = File(pickedFile.path);
      });
      base64MainImage = await _convertImageToBase64(pickedFile.path);
    } else {
      print('No image selected.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // logo
                GestureDetector(
                  onTap: pickImage,
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
                  ),
                ),

                const SizedBox(height: 25),

                Text("R E G I S T E R", style: TextStyle(fontSize: 20)),

                const SizedBox(height: 50),
                // email textfield
                MyTextField(
                  hintText: "Username",
                  obscureText: false,
                  controller: usernameController,
                ),

                const SizedBox(height: 10),

                MyTextField(
                  hintText: "Email",
                  obscureText: false,
                  controller: emailController,
                ),

                const SizedBox(height: 10),

                MyTextField(
                  hintText: "Password",
                  obscureText: true,
                  controller: passwordController,
                ),

                const SizedBox(height: 10),

                MyTextField(
                  hintText: "Confirm Password",
                  obscureText: true,
                  controller: confirmPasswordController,
                ),

                const SizedBox(height: 25),

                MyBotton(text: "Register", onTap: () => register(context)),

                const SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account?",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary),
                    ),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        " Login Here",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
