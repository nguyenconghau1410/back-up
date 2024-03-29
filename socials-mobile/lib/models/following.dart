class Following {
  String? id;
  String? userId;
  String? followId;

  Following(this.id, this.userId, this.followId);

  factory Following.fromJson(Map<String, dynamic> json) {
    return Following(json['id'], json['userId'], json['followId']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['followId'] = this.followId;
    return data;
  }
}