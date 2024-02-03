class Images {
  String? id;
  String? image;

  Images(this.id, this.image);

  factory Images.fromJson(Map<String, dynamic> json) {
    return Images(json['id'], json['image']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image'] = this.image;
    return data;
  }
}