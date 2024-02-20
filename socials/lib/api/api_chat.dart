import 'dart:convert';

import 'package:socials/models/chat_message.dart';
import 'package:socials/models/chat_relation.dart';
import 'package:http/http.dart' as http;
import 'package:socials/models/chat_rooms.dart';
import 'package:socials/models/user.dart';
import 'package:socials/utils/constant.dart';

class APIChat {
  static Future<List<ChatRelation>> findChatRoom(String senderId) async {
    try {
      final response = await http.get(
        Uri.parse("${Utils.baseURL}/rooms").replace(queryParameters: {"senderId": senderId})
      );
      if(response.statusCode == 200) {
        List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        List<ChatRelation> rooms = [];
        data.forEach((element) {
          ChatRelation chatRelation = ChatRelation(User.fromJson(element['user'])
              , ChatRooms.fromJson(element['chatRoom']), ChatMessage.fromJson(element['chatMessage']));
          rooms.add(chatRelation);
        });
        return rooms;
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
  static Future<List<ChatMessage>> findChatMessages(String senderId, String recipientId) async {
    try {
      final response = await http.get(
        Uri.parse("${Utils.baseURL}/messages/$senderId/$recipientId"),
      );
      if(response.statusCode == 200) {
        List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        List<ChatMessage> messages = [];
        data.forEach((element) {
          messages.add(ChatMessage.fromJson(element));
        });
        return messages;
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