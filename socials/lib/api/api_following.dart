import 'dart:convert';

import 'package:socials/models/following.dart';
import 'package:http/http.dart' as http;
import 'package:socials/utils/constant.dart';

import '../models/user.dart';

class APIFollowing {
  static Future<List<Following>?> getFollowingId(String? userId) async {
    try {
      final response = await http.get(
        Uri.parse('${Utils.baseURL}/following/get-userid/$userId')
      );
      if(response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<Following> list = [];
        data.forEach((element) {
          list.add(Following.fromJson(element));
        });
        return list;
      }
      return null;
    }
    catch(e) {
      print(e);
    }
  }
  static Future<List<Following>?> getIsFollowed(String? followId) async {
    try {
      final response = await http.get(
          Uri.parse('${Utils.baseURL}/following/get-following/$followId')
      );
      if(response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<Following> list = [];
        data.forEach((element) {
          list.add(Following.fromJson(element));
        });
        return list;
      }
      return null;
    }
    catch(e) {
      print(e);
    }
  }

  static Future<List<User>> getListUserIsFollowing(String followId) async {
    try {
      final response = await http.get(
        Uri.parse("${Utils.baseURL}/following/get-listUserIsFollowing/$followId")
      );
      if(response.statusCode == 200) {
        List<dynamic> list = json.decode(response.body);
        List<User> users = [];
        list.forEach((element) {
          users.add(User.fromJson(element));
        });
        return users;
      }
      else {
        return [];
      }
    }
    catch(e) {
      rethrow;
    }
  }
  static Future<List<User>> getListUserIsFollowed(String userid) async {
    try {
      final response = await http.get(
          Uri.parse("${Utils.baseURL}/following/get-listUserIsFollowed/$userid")
      );
      if(response.statusCode == 200) {
        List<dynamic> list = json.decode(response.body);
        List<User> users = [];
        list.forEach((element) {
          users.add(User.fromJson(element));
        });
        return users;
      }
      else {
        return [];
      }
    }
    catch(e) {
      rethrow;
    }
  }

  static Future<void> unFollow(String userId, String followId) async {
    try {
      final response = await http.delete(
        Uri.parse("${Utils.baseURL}/following/unFollow/$userId/$followId")
      );
      if(response.statusCode == 200) {
      }
    }
    catch(e) {
      rethrow;
    }
  }
  static Future<void> addFriend(String userId, String followId) async {
    try {
      final response = await http.post(
          Uri.parse("${Utils.baseURL}/following/add"),
          headers: {
            'Content-Type': 'application/json'
          },
          body: json.encode({
            'userId': userId,
            'followId': followId
          })
      );
      if(response.statusCode == 200) {
      }
    }
    catch(e) {
      rethrow;
    }
  }
}