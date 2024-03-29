class ChatRooms {
  String? id;
  String? chatId;
  String? senderId;
  String? recipientId;
  String? lastOut;

  ChatRooms(this.id, this.chatId, this.senderId, this.recipientId, this.lastOut);

  factory ChatRooms.fromJson(Map<String, dynamic> json) {
    return ChatRooms(json['id'], json['chatId'], json['senderId'], json['recipientId'], json['lastOut']);
  }
}