import 'package:socials/models/user.dart';

class NotificationBE {
  String? id;
  String? userid;
  User? user;
  String? content;
  String? timestamp;
  bool? read;

  NotificationBE(
      this.id, this.userid, this.user, this.content, this.timestamp, this.read);

  factory NotificationBE.fromJson(Map<String, dynamic> json) {
    return NotificationBE(json['id'], json['userid'], json['user'] != null ? User.fromJson(json['user']) : null, json['content'], json['timestamp'], json['read']);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = <String, dynamic>{};
    data['userid'] = this.userid;
    data['user'] = this.user;
    data['content'] = this.content;
    data['timestamp'] = this.timestamp;
    data['read'] = this.read;
    return data;
  }
}