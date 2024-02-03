import 'dart:convert';

import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
class ConnectWebSocket {
  static String base_uri = "ws://192.168.2.10:8080";
  static late StompClient stompClient;
  static void connectWS(String? email) async {
    String url = '$base_uri/ws/websocket';
    stompClient = StompClient(
      config: StompConfig(
        url: url,
        onConnect: (StompFrame stompFrame) => onConnected(stompFrame, email),
        onWebSocketError: (dynamic error) => print(error)
      )
    );

    stompClient.activate();
  }
  static void onConnected(StompFrame stompFrame,String? email) {
    stompClient.send(
      destination: '/app/user.addUser',
      body: json.encode({
        'email': email
      })
    );
  }

  static void onDisconnect(String? email) {
    stompClient.send(
      destination: '/app/user.disconnectUser',
      body: json.encode({
        'email': email
      })
    );
  }

}