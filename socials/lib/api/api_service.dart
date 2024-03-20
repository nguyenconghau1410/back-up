import 'dart:convert';
import 'package:socials/utils/constant.dart';

import '../models/user.dart';
import 'package:http/http.dart' as http;
class APIService {
  static Future<User?> login(User user) async {
    try {
      final response = await http.post(
          Uri.parse('${Utils.baseURL}/auth/login'),
          headers: {
            'Content-Type': 'application/json',
            'Accept-Charset': 'utf-8'
          },
          body: json.encode(user.toJson())
      );
      if(response.statusCode == 200) {
        return User.fromJson(json.decode(utf8.decode(response.bodyBytes)));
      }
      return null;
    }
    catch(e) {
      print(e.toString());
    }
  }
  static Future<User?> register(User user) async {
      try {
        final response = await http.post(
            Uri.parse('${Utils.baseURL}/auth/register'),
            headers: {
              'Content-Type': 'application/json',
              'Accept-Charset': 'utf-8'
            },
            body: json.encode(user.toJson())
        );
        if(response.statusCode == 200) {
          return User.fromJson(json.decode(utf8.decode(response.bodyBytes)));
        }
        return null;
      }
      catch(e) {
        print(e.toString());
      }
  }
  static Future<void> updateUser(User user) async {
    try {
      final response = http.put(
        Uri.parse('${Utils.baseURL}/update/user'),
        headers: {
          'Content-Type': 'application/json',
          'Accept-Charset': 'utf-8'
        },
        body: json.encode(user.toJson())
      );
    }
    catch(e) {
      print(e);
    }
  }
  static Future<List<User>> getUserByNameContaining(String keyword) async {
    try {
      final response = await http.get(
        Uri.parse("${Utils.baseURL}/users/looking-for").replace(queryParameters: {"keyword": keyword})
      );
      if(response.statusCode == 200) {
        List<User> users = [];
        List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        data.forEach((element) { 
          users.add(User.fromJson(element));
        });
        return users;
      }
      else {
        print(response.statusCode);
        return [];
      }
    }
    catch(e) {
      rethrow;
    }
  }
  static Future<List<User>> getUsersConnected(User user) async {
    try {
      final response = await http.get(
        Uri.parse("${Utils.baseURL}/online/users").replace(queryParameters: {"userid": user.id!})
      );
      if(response.statusCode == 200) {
        List<User> users = [];
        List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        data.forEach((element) {
          users.add(User.fromJson(element));
        });
        return users;
      }
      else {
        print(response.statusCode);
        return [];
      }
    }
    catch(e) {
      rethrow;
    }
  }
  static Future<User?> getUserByEmail(String email) async {
    try {
      final response = await http.get(
        Uri.parse("${Utils.baseURL}/find-email/$email")
      );
      if(response.statusCode == 200) {
        return User.fromJson(json.decode(utf8.decode(response.bodyBytes)));
      }
      else {
        print(response.statusCode);
        return null;
      }
    }
    catch(e) {
      rethrow;
    }
  }
  static Future<List<User>> getHintUser(String userid) async {
    try {
      final response = await http.get(
        Uri.parse("${Utils.baseURL}/users/hint-user").replace(queryParameters: {"userid": userid})
      );
      if(response.statusCode == 200) {
        List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        List<User> users = [];
        data.forEach((element) {
          users.add(User.fromJson(element));
        });
        return users;
      }
      else {
        print(response.statusCode);
        return [];
      }
    }
    catch(e) {
      rethrow;
    }
  }
  static Future<List<User>> getHintUser6(String userid) async {
    try {
      final response = await http.get(
          Uri.parse("${Utils.baseURL}/users/hint-user-6").replace(queryParameters: {"userid": userid})
      );
      if(response.statusCode == 200) {
        List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        List<User> users = [];
        data.forEach((element) {
          users.add(User.fromJson(element));
        });
        return users;
      }
      else {
        print(response.statusCode);
        return [];
      }
    }
    catch(e) {
      rethrow;
    }
  }
}