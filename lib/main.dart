import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tierlistapp/auth/check_login.dart';
import 'package:tierlistapp/auth/login_or_register.dart';
import 'package:tierlistapp/auth/user_preferences.dart';
import 'package:tierlistapp/components/tier_category.dart';
import 'package:tierlistapp/models/index.dart';
import 'package:tierlistapp/pages/home_page.dart';
import 'package:tierlistapp/pages/login_page.dart';
import 'package:tierlistapp/pages/profile_page.dart';
import 'package:tierlistapp/service/user_service.dart';

import 'package:tierlistapp/theme/dark_mode.dart';
import 'package:tierlistapp/theme/light_mode.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => DisBottonProvider()),
        // ... โปรไวเดอร์อื่น ๆ
      ],
      child: MyApp(),
    ),
  );
}


class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final UserService userService = UserService();
  late User user = User();

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final userId = await UserPreferences.getUserId();

    if (userId != null) {
      final loadedUser = await userService.getUserById(userId);
      setState(() {
        user = loadedUser;
      });
    } else {
      print("userId is Null");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginOrRegister(),
      theme: lightMode,
      darkTheme: darkMode,
      routes: {
          
      },
    );
  }
}
