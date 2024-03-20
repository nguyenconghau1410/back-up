import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:socials/models/favorite.dart';
import 'package:socials/models/post.dart';
import 'package:socials/models/post_relation.dart';
import 'package:socials/models/story.dart';
import 'package:socials/models/story_relation.dart';
import 'package:socials/utils/constant.dart';
import '../models/user.dart';
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
        List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
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
        Uri.parse("${Utils.baseURL}/posts/get-all/post").replace(queryParameters: {"userid": userid})
      );
      if(response.statusCode == 200) {
        List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
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
  static Future<int> countByUserid(String userid) async {
    try {
      final response = await http.get(
        Uri.parse("${Utils.baseURL}/posts/count").replace(queryParameters: {"userid": userid})
      );
      if(response.statusCode == 200) {
        return json.decode(response.body)['count'];
      }
      else {
        print(response.statusCode);
        return 0;
      }
    }
    catch(e) {
      rethrow;
    }
  }
  static Future<void> deleteStoryById(String id) async {
    try {
      final response = await http.delete(
        Uri.parse("${Utils.baseURL}/stories/delete").replace(queryParameters: {"id": id})
      );
      if(response.statusCode == 200) {
        Fluttertoast.showToast(
            msg: "Xóa thành công",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 16
        );
      }
      else {
        Fluttertoast.showToast(
            msg: "Đã có lỗi xảy ra ${response.statusCode}",
            toastLength: Toast.LENGTH_LONG,
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
  static Future<List<PostRelation>> getAllShortCut(String userid) async {
    try {
      final response = await http.get(
          Uri.parse("${Utils.baseURL}/posts/get-all/short-cut").replace(queryParameters: {"userid": userid})
      );
      if(response.statusCode == 200) {
        List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
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
  static Future<List<PostRelation>> getOtherPost(String userid) async {
    try {
      final response = await http.get(
          Uri.parse("${Utils.baseURL}/posts/get-other-post").replace(queryParameters: {"userid": userid})
      );
      if(response.statusCode == 200) {
        List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        List<PostRelation> posts = [];
        data.forEach((element) {
          List<dynamic> dataF = element['favorites'];
          List<Favorite> favorites = [];
          dataF.forEach((e) {
            favorites.add(Favorite.fromJson(e));
          });
          posts.add(PostRelation(User.fromJson(element['user']), Post.fromJson(element['post']), favorites));
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
  static Future<List<StoryRelation>> getStoryOfFriends(String userid) async {
    try {
      final response = await http.get(
        Uri.parse("${Utils.baseURL}/stories/get-story-of-friends").replace(queryParameters: {"userid": userid})
      );
      if(response.statusCode == 200) {
        List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        List<StoryRelation> stories = [];
        data.forEach((element) {
          StoryRelation story = StoryRelation(User.fromJson(element['user']), Story.fromJson(element['story']));
          stories.add(story);
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
  static Future<bool> editingPost(Post post) async {
    try {
      final response = await http.put(
        Uri.parse("${Utils.baseURL}/posts/editing-post"),
        headers: {
          "Content-Type": "application/json"
        },
        body: json.encode(post.toJson())
      );
      if(response.statusCode == 200) {
        return true;
      }
      else {
        print(response.statusCode);
        return false;
      }
    }
    catch(e) {
      rethrow;
    }
  }
  static Future<bool> deletePost(String postId) async {
    try {
      final response = await http.delete(
        Uri.parse("${Utils.baseURL}/posts/delete-post").replace(queryParameters: {"postId": postId})
      );
      if(response.statusCode == 200) {
        return true;
      }
      else {
        print(response.statusCode);
        return false;
      }
    }
    catch(e) {
      rethrow;
    }
  }
  static Future<List<PostRelation>> getReels(String userid) async {
    try {
      final response = await http.get(
        Uri.parse("${Utils.baseURL}/posts/reels").replace(queryParameters: {"userid": userid})
      );
      if(response.statusCode == 200) {
        List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        List<PostRelation> posts = [];
        data.forEach((element) {
          List<dynamic> dataF = element['favorites'];
          List<Favorite> favorites = [];
          dataF.forEach((e) {
            favorites.add(Favorite.fromJson(e));
          });
          PostRelation postRelation = PostRelation(
            User.fromJson(element['user']),
            Post.fromJson(element['post']),
            favorites
          );
          posts.add(postRelation);
        });
        return posts;
      }
      else {
        return [];
      }
    }
    catch(e) {
      rethrow;
    }
  }
  static Future<void> report(String postid, String userid) async {
    try {
      final response = await http.put(
        Uri.parse("${Utils.baseURL}/posts/report").replace(queryParameters: {
          "postid": postid,
          "userid": userid
        })
      );
      if(response.statusCode == 200) {
        Fluttertoast.showToast(
            msg: "Đã báo xấu bài viết thành công !",
            toastLength: Toast.LENGTH_SHORT,
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
            msg: "Đã có lỗi xảy ra, hãy thử lại !",
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
}