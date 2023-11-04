import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:tierlistapp/auth/login_or_register.dart';
import 'package:tierlistapp/components/my_button.dart';
import 'package:tierlistapp/components/my_textfield.dart';
import 'package:http/http.dart' as http;
import 'package:tierlistapp/models/index.dart';
import 'package:tierlistapp/pages/home_page.dart';
import 'package:tierlistapp/pages/register_page.dart';

class LoginPage extends StatelessWidget {
  final void Function()? onTap;

  LoginPage({super.key, required this.onTap});

  // text controllers
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  // login method
  void login(BuildContext context) async {
    Uri url = Uri.parse("http://10.160.63.2:8080/api/login");

    String email = emailController.text;
    String password = passwordController.text;

    var res = await http.post(url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}));
    if (res.statusCode == 200) {
      // การล็อกอินสำเร็จ
      print("Login success.");
      User user = User.fromJson(json.decode(res.body));
      // คุณสามารถใช้ user ในการเข้าถึงข้อมูลของผู้ใช้ที่ล็อกอินสำเร็จ
      // เช่น user.id, user.username, user.email, user.imageUrl, เป็นต้น

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => HomepPage(user),
        ),
      );
    } else {
      // Handle unsuccessful login, e.g., show an error message
      print('Login failed. Check your email and password.');
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
                Icon(
                  Icons.person,
                  size: 80,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),

                const SizedBox(
                  height: 25,
                ),

                Text(
                  "L O G I N",
                  style: TextStyle(fontSize: 20),
                ),

                const SizedBox(
                  height: 50,
                ),
                // email textfield
                MyTextField(
                    hintText: "Email",
                    obscureText: false,
                    controller: emailController),

                const SizedBox(
                  height: 10,
                ),

                MyTextField(
                    hintText: "Password",
                    obscureText: true,
                    controller: passwordController),

                const SizedBox(
                  height: 10,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "Forgot Password?",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary),
                    )
                  ],
                ),

                const SizedBox(
                  height: 25,
                ),

                MyBotton(text: "Login", onTap: () => login(context)),

                const SizedBox(
                  height: 10,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account?",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => RegisterPage(onTap: onTap,),
                          ),
                        );
                      },
                      child: const Text(
                        " Register Here",
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
