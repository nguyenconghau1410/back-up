import 'package:get/get.dart';
import 'package:socials/api/api_following.dart';
import 'package:socials/models/friend.dart';

import '../models/user.dart';

class FriendsController extends GetxController {
  var friends = <Friend>[].obs;

  Future<void> toggleFollow(int index, String userId, String followId) async {
    friends[index].isFollowing.value = !friends[index].isFollowing.value;
    if(friends[index].isFollowing == false) {
      await APIFollowing.unFollow(userId, followId);
    }
    else {
      await APIFollowing.addFriend(userId, followId);
    }
  }
  Future<void> getData(bool isDisplay, String id) async {
    if(isDisplay == true) {
      List<User> users = await APIFollowing.getListUserIsFollowing(id);
      List<User> users1 = await APIFollowing.getListUserIsFollowed(id);
      List<Friend> friends1 = [];
      for(User user in users) {
        bool flag = false;
        for(User user1 in users1) {
          if(user.id == user1.id) {
            friends1.add(Friend(user, true.obs));
            flag = true;
            break;
          }
        }
        if(!flag) {
          friends1.add(Friend(user, false.obs));
        }
      }
      friends.value = friends1;
    }
    else {
      List<User> users = await APIFollowing.getListUserIsFollowed(id);
      List<Friend> friends1 = [];
      users.forEach((element) {
        friends1.add(Friend(element, true.obs));
      });
      friends.value = friends1;
    }
  }
}