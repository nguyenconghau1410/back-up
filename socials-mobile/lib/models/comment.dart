import 'package:get/get.dart';
import 'package:socials/models/user.dart';

class Comment {
  String? id;
  User? user;
  String? postid;
  String? content;
  String? src;
  String? createdAt;
  List<Comment>? replies;
  var clicked = false.obs;

  Comment(this.id, this.user, this.postid, this.content, this.src, this.createdAt,
      this.replies);
  Comment.none();
  factory Comment.fromJson(Map<String, dynamic> json) {
    List<Comment> list = [];
    if(json['replies'] != null) {
      List<dynamic> reply = json['replies'];
      reply.forEach((element) {
        list.add(Comment.fromJson(element));
      });
    }
    return Comment(json['id'], User.fromJson(json['user']), json['postid'], json['content'], json['src'],
        json['createdAt'], json['replies'] != null ? list : null);
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['user'] = this.user;
    data['postid'] = this.postid;
    data['content'] = this.content;
    data['src'] = this.src;
    data['createdAt'] = this.createdAt;
    return data;
  }
}