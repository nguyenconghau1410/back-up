import 'package:get/get.dart';
import 'package:social/api/api_following.dart';
import 'package:social/utils/constant.dart';

import '../models/following.dart';

class FollowingController extends GetxController {
  RxList<Following> isFollowing = <Following>[].obs;
  RxList<Following> beingFollowed = <Following>[].obs;

  Future<void> getData() async {
    try {
      isFollowing.value = (await APIFollowing.getFollowingId(Utils.user!.id))!;
      beingFollowed.value = (await APIFollowing.getIsFollowed(Utils.user!.id))!;
    }
    catch(e) {
      print(e);
    }
  }
}