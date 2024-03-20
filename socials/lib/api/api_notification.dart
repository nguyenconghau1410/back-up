import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:socials/models/notification_be.dart';
import 'package:socials/utils/constant.dart';

class APINotification {
  static Future<void> addNotification(NotificationBE notificationBE) async {
    try {
      final response = await http.post(
        Uri.parse("${Utils.baseURL}/notifications/add-notification"),
        headers: {
          "Content-Type": "application/json"
        },
        body: json.encode(notificationBE.toJson())
      );
      if(response.statusCode == 200) {

      }
      else {
        print("Đã có lỗi");
      }
    }
    catch(e) {
      rethrow;
    }
  }
  static Future<List<NotificationBE>> getListNotification(String userid) async {
    try {
      final response = await http.get(
        Uri.parse("${Utils.baseURL}/notifications/get-notifications-of-user").replace(queryParameters: {"userid": userid})
      );
      if(response.statusCode == 200) {
        List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        List<NotificationBE> notifications = [];
        data.forEach((element) {
          notifications.add(NotificationBE.fromJson(element));
        });
        return notifications;
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