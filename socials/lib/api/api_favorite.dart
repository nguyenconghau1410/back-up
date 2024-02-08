import 'dart:convert';

import 'package:socials/models/comment.dart';
import 'package:socials/models/favorite.dart';
import 'package:http/http.dart' as http;
import 'package:socials/utils/constant.dart';
class APIFavorite {
  static Future<void> addLike(Favorite favorite) async {
    try {
      final response = await http.post(
        Uri.parse("${Utils.baseURL}/favorites/add"),
        headers: {
          'Content-Type': 'application/json'
        },
        body: json.encode(favorite)
      );
      if(response.statusCode == 200) {

      }
      else {
        print(response.statusCode);
      }
    }
    catch(e) {
      rethrow;
    }
  }
  static Future<void> unLike(String userid, String postid) async {
    try {
      final response = await http.delete(
        Uri.parse("${Utils.baseURL}/favorites/delete").replace(queryParameters: {
          'userid': userid,
          'postid': postid
        })
      );
      if(response.statusCode == 200) {

      }
      else {
        print(response.statusCode);
      }
    }
    catch(e) {
      rethrow;
    }
  }
  static Future<Comment?> addComment(Comment comment) async {
    try {
      final response = await http.post(
        Uri.parse("${Utils.baseURL}/comments/add-node-0"),
        headers: {
          'Content-Type': "application/json"
        },
        body: json.encode(comment.toJson())
      );
      if(response.statusCode == 200) {
        return Comment.fromJson(json.decode(response.body));
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
  static Future<List<Comment>> getComments(String postid) async {
    try {
      final response = await http.get(
          Uri.parse("${Utils.baseURL}/comments/get-comments").replace(queryParameters: {"postid": postid})
      );
      if(response.statusCode == 200) {
        List<Comment> comments = [];
        List<dynamic> data = json.decode(response.body);
        data.forEach((element) {
          comments.add(Comment.fromJson(element));
        });
        return comments;
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
  static Future<void> addCommentNode1(Comment comment, String postid, String commentId) async {
    try {
      final response = await http.post(
          Uri.parse("${Utils.baseURL}/comments/add-node-1").replace(queryParameters: {
            'postid': postid,
            'commentid': commentId
          }),
          headers: {
            'Content-Type': "application/json"
          },
          body: json.encode(comment.toJson())
      );
      if(response.statusCode == 200) {

      }
      else {
        print(response.statusCode);
      }
    }
    catch(e) {
      rethrow;
    }
  }
}