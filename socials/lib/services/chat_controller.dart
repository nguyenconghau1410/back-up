import 'dart:convert';

import 'package:get/get.dart';
import 'package:socials/api/api_chat.dart';
import 'package:socials/connect/connecting_websocket.dart';
import 'package:socials/models/chat_message.dart';
import 'package:socials/utils/constant.dart';

class ChatController extends GetxController {
  static var messages = <ChatMessage>[].obs;
  static bool isCreated = false;
  static Future<void> init(String senderId, String recipientId) async {
    isCreated = true;
    messages.value = await APIChat.findChatMessages(senderId, recipientId);
  }

  static void addMessage(ChatMessage chatMessage) {
    messages.add(chatMessage);
  }

  static void destroy() {
    isCreated = false;
    messages = <ChatMessage>[].obs;
  }
}