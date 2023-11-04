import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static Future<bool?> getLoginStatus() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool("login");
  }

  static Future setLoginStatus(bool login) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.setBool("login", login);
  }

  static Future<int?> getUserId() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getInt("userId");
  }

  static Future setUserId(int userId) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.setInt("userId", userId);
  }

  static Future<String?> getUserEmail() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString("username");
  }

  static Future setUserEmail(String login) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.setString("username", login);
  }

  static Future<String?> getUsername() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString("username");
  }

  static Future setUsername(String login) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.setString("username", login);
  }

  static Future<String?> getUserImage() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString("userImage");
  }

  static Future setUserImage(String login) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.setString("userImage", login);
  }
}
