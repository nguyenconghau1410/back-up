import 'package:get/get.dart';
import 'package:socials/api/api_following.dart';
import 'package:socials/utils/constant.dart';

import '../models/following.dart';

class FollowingController extends GetxController {
  RxList<Following> isFollowing = <Following>[].obs;
  RxList<Following> beingFollowed = <Following>[].obs;

  Future<void> getData(String userid) async {
    try {
      isFollowing.value = (await APIFollowing.getFollowingId(userid))!;
      beingFollowed.value = (await APIFollowing.getIsFollowed(userid))!;
    }
    catch(e) {
      print(e);
    }
  }
}