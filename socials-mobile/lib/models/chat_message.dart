class ChatMessage {
  String? id;
  String? chatId;
  String? senderId;
  String? recipientId;
  String? content;
  String? src_image;
  String? timestamp;

  ChatMessage(this.id, this.chatId, this.senderId, this.recipientId,
      this.content, this.src_image, this.timestamp);

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(json['id'], json['chatId'], json['senderId'],
        json['recipientId'], json['content'], json['src_image'], json['timestamp']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['chatId'] = this.chatId;
    data['senderId'] = this.senderId;
    data['recipientId'] = this.recipientId;
    data['content'] = this.content;
    data['src_image'] = this.src_image;
    data['timestamp'] = this.timestamp;
    return data;
  }
}