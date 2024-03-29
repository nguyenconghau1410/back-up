import 'dart:convert';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:socials/models/chat_relation.dart';
import 'package:http/http.dart' as http;
import 'package:socials/utils/constant.dart';
class MessagingService {
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  static Future<String?> getTokenDevice() async {
    final settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );
    final fCMToken = await _firebaseMessaging.getToken();
    return fCMToken;
  }


  static Future<void> pushNotification(ChatRelation chatRelation) async {
    try {
      Map<String, dynamic> mp = {
        "notification": {
          "title": Utils.user!.title,
          "body": chatRelation.chatMessage!.content
        },
        "to": chatRelation.user!.tokenDevice
      };
      final response = await http.post(
        Uri.parse("https://fcm.googleapis.com/fcm/send"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "key=AAAAQ-b0rxg:APA91bGxCrsE_ZZ5P9vtybi2UPsLUKN6jpaOaFgDHShUd6g6gReOLYxBmwlNzOfPEfGGsinih5ORxx3RWC-LX4xvjf2E3LvDMO9bTAcHk6RZRiEbtwUeTXqkyNeHOanm9E6m_7Gix-6g"
        },
        body: json.encode(mp)
      );
      if(response.statusCode == 200) {
        print("Successfully");
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