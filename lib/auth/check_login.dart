import 'package:flutter/material.dart';
import 'package:tierlistapp/auth/user_preferences.dart';


class CheckLogin extends StatefulWidget {
  const CheckLogin({super.key});

  @override
  State<CheckLogin> createState() => _CheckLoginState();
}

class _CheckLoginState extends State<CheckLogin> {
  Future checkLogin() async {
    bool? login = await UserPreferences.getLoginStatus();
    if (login == false) {
      Navigator.pushNamed(context, 'login_or_register');
    } else {
      Navigator.pushNamed(context, 'home');
    }
  }

  @override
  void initState() {
    checkLogin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
