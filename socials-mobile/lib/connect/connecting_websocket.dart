import 'dart:convert';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:socials/models/chat_message.dart';
import 'package:socials/models/chat_relation.dart';
import 'package:socials/services/chat_controller.dart';
import 'package:socials/services/chat_room_controller.dart';
import 'package:socials/utils/constant.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

import '../models/user.dart';
import '../utils/notification_service.dart';
class ConnectWebSocket {
  static String base_uri = "ws://racingboy560-26219.portmap.host:26219";
  static late StompClient stompClient;
  static void connectWS(String? email) async {
    String url = '$base_uri/ws/websocket';
    stompClient = StompClient(
      config: StompConfig(
        url: url,
        onConnect: (StompFrame stompFrame) => onConnected(stompClient, stompFrame, email),
        onWebSocketError: (dynamic error) => print(error)
      )
    );
    stompClient.activate();
  }
  static void onConnected(StompClient stomp,StompFrame stompFrame,String? email) {
    stomp.subscribe(
      destination: "/user/${Utils.user!.id}/queue/messages",
      callback: onMessageReceived
    );
    stomp.subscribe(
        destination: "/user/${Utils.user!.id}/queue/call",
        callback: onHandleCalled
    );
    stomp.send(
      destination: '/app/addUser',
      body: json.encode({
        'email': email
      })
    );
  }
  static void onDisconnect(String? email) {
    stompClient.send(
      destination: '/app/disconnectUser',
      body: json.encode({
        'email': email
      })
    );
  }
  static void chatMessage(ChatMessage message) {
    stompClient.send(
        destination: '/app/chat',
        body: json.encode(message)
    );
  }

  static void requestCall(User sender, User recipient, String type) {
    Map<String, dynamic> mp = {
      "sender": sender,
      "recipient": recipient,
      "type": type
    };
    stompClient.send(
        destination: '/app/call',
        body: json.encode(mp)
    );
  }
  static void onMessageReceived(StompFrame frame) {
    ChatRelation relation = ChatRelation.fromJson(json.decode(frame.body!));
    if(Utils.user!.id == relation.chatMessage!.recipientId) {
      if(ChatController.isCreated) {
        if(relation.chatMessage!.chatId == ChatController.messages.first.chatId) {
          ChatController.addMessage(relation.chatMessage!);
        }
        else {
          NotificationService.showNotification(relation);
        }
      }
      else {
        NotificationService.showNotification(relation);
      }
      ChatRoomController chatRoomController = Get.put(ChatRoomController());
      chatRoomController.changePosition(relation);
    }
  }

  static void onHandleCalled(StompFrame frame) {
    Map<String, dynamic> mp = json.decode(frame.body!);
    User sender = User.fromJson(mp['sender']);
    User recipient = User.fromJson(mp['recipient']);
    String type = mp['type'];
    NotificationService.initializeNotification();
    NotificationService.showNotificationCall(sender, recipient, sender.id! + recipient.id!, type);
  }
}