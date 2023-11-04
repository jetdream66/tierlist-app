import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:tierlistapp/auth/user_preferences.dart';
import 'package:tierlistapp/models/user.dart';

class UserService {
  Future<User> getUserById(int id) async {
    final url = Uri.parse('http://10.160.63.2:8080/api/users/$id');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return User.fromJson(data);
    } else {
      throw Exception('Failed to load user');
    }
  }

  String encryptPassword(String password) {
    final bytes = utf8.encode(password);
    final hash = sha256.convert(bytes);
    return hash.toString();
  }

  Future setUserPrefs(int id, bool status) async {
    await UserPreferences.setUserId(id);
    await UserPreferences.setLoginStatus(status);
  }

  Future<bool> login(String email, String password) async {
    Uri url = Uri.parse("http://10.160.63.2:8080/api/login");

    String encryptedPassword = encryptPassword(password);

    var res = await http.post(url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': encryptedPassword}));

    if (res.statusCode == 200) {
      Map<String, dynamic> userData = json.decode(res.body);
      setUserPrefs(userData['id'], true);
      print('Login uccess');
      return true;
    } else {
      print('Login failed. Check your email and password.');
      return false;
    }
  }

  Future<bool> register(String username, String email, String password,
      String confirmPassword) async {
    Uri url = Uri.parse("http://10.160.63.2:8080/api/register");

    if (password == confirmPassword) {
      String encryptedPassword = encryptPassword(password);
      var res = await http.post(url,
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'username': username,
            'email': email,
            'password': encryptedPassword
          }));
      if (res.statusCode == 201) {
        print("Registration success.");
        return true;
      } else if (res.statusCode == 409) {
        print('Registration failed. User with this email already exists.');
        return false;
      } else {
        print('Registration failed. An error occurred.');
        return false;
      }
    } else {
      print('Registration failed. Please check Password and Confirm Password.');
      return false;
    }
  }
}
