import 'package:socials/models/role.dart';

class User {
  String? id;
  String? email;
  String? name;
  String? password;
  String? dob;
  bool? gender;
  String? title;
  String? image;
  String? status;
  Role? role;

  User(
      {this.id, this.email, this.name, this.password, this.dob, this.gender, this.title,
        this.image, this.status, this.role});
  User.auth(this.email, this.password);
  User.register(this.email, this.name, this.password);

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    name = json['name'];
    password = json['password'];
    dob = json['dob'];
    gender = json['gender'];
    title = json['title'];
    image = json['image'];
    status = json['status'];
    role = json['role'] != null ? Role.fromJson(json['role']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['email'] = this.email;
    data['name'] = this.name;
    data['password'] = this.password;
    data['dob'] = this.dob;
    data['gender'] = this.gender;
    data['title'] = this.title;
    data['image'] = this.image;
    data['status'] = this.status;
    if (this.role != null) {
      data['role'] = this.role!.toJson();
    }
    return data;
  }
}