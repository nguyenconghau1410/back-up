class Story {
  String? id;
  String? userid;
  String? status;
  String? src_image;
  String? src_video;
  String? createdAt;
  String? modifiedAt;

  Story(this.id, this.userid, this.status, this.src_image, this.src_video, this.createdAt,
      this.modifiedAt);

  factory Story.fromJson(Map<String, dynamic> json) {
    return Story(json['id'], json['userid'], json['status'], json['src_image'], json['src_video'],json['createdAt'], json['modifiedAt']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['userid'] = this.userid;
    data['status'] = this.status;
    data['src_image'] = this.src_image;
    data['src_video'] = this.src_video;
    data['createdAt'] = this.createdAt;
    data['modifiedAt'] = this.modifiedAt;
    return data;
  }
}