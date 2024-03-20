
import 'package:get/get.dart';
import 'package:socials/api/api_following.dart';
import 'package:socials/models/user.dart';

class HintController {
  User? user;
  var clicked = false.obs;

  void init(User user) {
    this.user = user;
  }

  Future<void> onChanged(String userId, String followId) async {
    if(clicked.value) {
      await APIFollowing.unFollow(userId, followId);
    }
    else {
      await APIFollowing.addFriend(userId, followId);
    }
    clicked.value = !clicked.value;
  }
}