import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:socials/models/favorite.dart';
import 'package:socials/models/post.dart';
import 'package:socials/models/post_relation.dart';
import 'package:socials/models/story.dart';
import 'package:socials/utils/constant.dart';
class APIPosts {
  static Future<void> createPost(Post post, String type) async {
    try {
      final response = await http.post(
        Uri.parse("${Utils.baseURL}/posts/create"),
        headers: {
          "Content-Type": "application/json"
        },
        body: json.encode(post.toJson())
      );
      if(response.statusCode == 200) {
        Fluttertoast.showToast(
          msg: "$type của bạn đã tạo thành công",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16
        );
      }
      else {
        print(response.statusCode);
        Fluttertoast.showToast(
            msg: "Đã có lỗi xảy ra: ${response.statusCode}",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 16
        );
      }
    }
    catch(e) {
      rethrow;
    }
  }
  static Future<void> createStory(Story story) async {
    try {
      final response = await http.post(
          Uri.parse("${Utils.baseURL}/stories/create"),
          headers: {
            "Content-Type": "application/json"
          },
          body: json.encode(story.toJson())
      );
      if(response.statusCode == 200) {
        Fluttertoast.showToast(
            msg: "Tin của bạn đã tạo thành công",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 16
        );
      }
      else {
        print(response.statusCode);
        Fluttertoast.showToast(
            msg: "Đã có lỗi xảy ra: ${response.statusCode}",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 16
        );
      }
    }
    catch(e) {
      rethrow;
    }
  }
  static Future<List<Story>> getStoryByUserid(String userid) async {
    try {
      final response = await http.get(
        Uri.parse("${Utils.baseURL}/stories/get-all").replace(queryParameters: {"userid": userid})
      );
      if(response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<Story> stories = [];
        data.forEach((element) {
          stories.add(Story.fromJson(element));
        });
        return stories;
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
  static Future<List<PostRelation>> getAllPosts(String userid) async {
    try {
      final response = await http.get(
        Uri.parse("${Utils.baseURL}/posts/get-all").replace(queryParameters: {"userid": userid})
      );
      if(response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<PostRelation> posts = [];
        data.forEach((element) {
          List<dynamic> dataF = element['favorites'];
          List<Favorite> favorites = [];
          dataF.forEach((e) {
            favorites.add(Favorite.fromJson(e));
          });
          posts.add(PostRelation(null, Post.fromJson(element['post']), favorites));
        });
        return posts;
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