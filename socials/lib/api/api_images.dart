import 'dart:convert';

import 'package:socials/models/images.dart';
import 'package:http/http.dart' as http;
import 'package:socials/utils/constant.dart';
class APIImages {
  static Future<List<Images>> getByUserid(String userid) async {
    try {
      final response = await http.get(
        Uri.parse("${Utils.baseURL}/images/get-by-userid/$userid")
      );
      if(response.statusCode == 200) {
        List<Images> images = [];
        List<dynamic> data = json.decode(response.body);
        data.forEach((element) {
          images.add(Images.fromJson(element));
        });
        return images;
      }
      else {
        return [];
      }
    }
    catch(e) {
      rethrow;
    }
  }
}