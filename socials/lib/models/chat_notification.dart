class ChatNotification {
  String? id;
  String? senderId;
  String? recipientId;
  String? content;
  String? src;

  ChatNotification(
      this.id, this.senderId, this.recipientId, this.content, this.src);

  factory ChatNotification.fromJson(Map<String, dynamic> json) {
    return ChatNotification(json['id'], json['senderId'], json['recipientId'], json['content'], json['src']);
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['senderId'] = this.senderId;
    data['recipientId'] = this.recipientId;
    data['content'] = this.content;
    data['src'] = this.src;
    return data;
  }
}