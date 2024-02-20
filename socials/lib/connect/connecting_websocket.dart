import 'dart:convert';
import 'package:get/get.dart';
import 'package:socials/models/chat_message.dart';
import 'package:socials/models/chat_relation.dart';
import 'package:socials/services/chat_controller.dart';
import 'package:socials/services/chat_room_controller.dart';
import 'package:socials/utils/constant.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';
class ConnectWebSocket {
  static String base_uri = "ws://192.168.2.10:8080";
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
  static void onMessageReceived(StompFrame frame) {
    ChatRelation relation = ChatRelation.fromJson(json.decode(frame.body!));
    if(ChatController.isCreated) {
      if(relation.chatMessage!.chatId == ChatController.messages.first.chatId) {
        ChatController.addMessage(relation.chatMessage!);
      }
    }
    ChatRoomController chatRoomController = Get.put(ChatRoomController());
    chatRoomController.changePosition(relation);
  }
}