import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';

class LocalStorage {
  static Future<void> saveUser(String email) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("email", email);
  }

  static Future<void> deleteUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("email");
  }

  static Future<String?> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = await prefs.getString("email");
    if(email == null) {
      return null;
    }
    else {
      return email!;
    }
  }
}