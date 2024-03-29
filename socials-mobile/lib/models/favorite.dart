class Favorite {
  String? id;
  String? userid;
  String? postid;

  Favorite(this.id, this.userid, this.postid);

  factory Favorite.fromJson(Map<String, dynamic> json) {
    return Favorite(json['id'], json['userid'], json['postid']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['userid'] = this.userid;
    data['postid'] = this.postid;
    return data;
  }
}