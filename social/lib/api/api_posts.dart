import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:social/models/post.dart';
import 'package:social/utils/constant.dart';
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
}