import 'package:socials/models/chat_message.dart';
import 'package:socials/models/chat_rooms.dart';
import 'package:socials/models/user.dart';

class ChatRelation {
  User? user;
  ChatRooms? chatRoom;
  ChatMessage? chatMessage;

  ChatRelation(this.user, this.chatRoom, this.chatMessage);

  factory ChatRelation.fromJson(Map<String, dynamic> json) {
    return ChatRelation(User.fromJson(json['user']),
        ChatRooms.fromJson(json['chatRoom']), ChatMessage.fromJson(json['chatMessage']));
  }
}