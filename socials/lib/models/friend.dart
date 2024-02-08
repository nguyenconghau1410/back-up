import 'package:get/get.dart';
import 'package:socials/models/user.dart';

class Friend {
  User? user;
  Rx<bool> isFollowing = true.obs;

  Friend(this.user, this.isFollowing);
}