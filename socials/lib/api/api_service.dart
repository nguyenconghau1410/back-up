import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
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
        return User.fromJson(json.decode(response.body));
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
          return User.fromJson(json.decode(response.body));
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

}