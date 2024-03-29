import 'package:socials/models/images.dart';

class Post {
  String? id;
  String? userid;
  String? content;
  String? status;
  String? src;
  String? createdAt;
  String? modifiedAt;
  String? type;
  String? location;
  List<Images>? images;
  List<String>? ids;

  Post(this.id, this.userid, this.content, this.status, this.src, this.createdAt,
      this.modifiedAt, this.type, this.location, this.images, this.ids);
  factory Post.fromJson(Map<String, dynamic> json) {
    List<Images> images = [];
    if(json['images'] != null) {
      for(int i = 0; i < json['images'].length; i++) {
        images.add(Images.fromJson(json['images'][i]));
      }
    }
    List<String> ids = [];
    if(json['ids'] != null) {
      for(int i = 0; i < json['ids'].length; i++) {
        ids.add(json['ids'][i]);
      }
    }
    return Post(json['id'], json['userid'], json['content'], json['status'],
        json['src'], json['createdAt'], json['modifiedAt'], json['type'], json['location'], json['images'] != null ? images : null,
        json['ids'] != null ? ids : null);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userid'] = this.userid;
    data['content'] = this.content;
    data['status'] = this.status;
    data['src'] = this.src;
    data['createdAt'] = this.createdAt;
    data['modifiedAt'] = this.modifiedAt;
    data['type'] = this.type;
    data['location'] = this.location;
    if(this.images != null) {
      List<Map<String, dynamic>> images = [];
      this.images!.forEach((element) {
        images.add(element.toJson());
      });
      data['images'] = images;
    }
    return data;
  }
}