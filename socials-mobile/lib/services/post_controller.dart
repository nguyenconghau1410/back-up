import 'package:get/get.dart';
import 'package:socials/api/api_favorite.dart';
import 'package:socials/models/favorite.dart';
import 'package:socials/models/post_relation.dart';

class PostController extends GetxController {
  PostRelation? postRelation;
  var quantityLike = 0.obs;
  var quantityComment = 0.obs;
  var clicked = false.obs;

  void init(PostRelation postRelation, String userid) {
    this.postRelation = postRelation;
    quantityLike.value = postRelation.favorites!.length;
    postRelation.favorites!.forEach((element) {
      if(element.userid == userid) {
        clicked.value = true;
      }
    });
  }

  Future<void> onChanged(Favorite favorite) async {
    if(clicked.value) {
      await APIFavorite.unLike(favorite.userid!, favorite.postid!);
      --quantityLike.value;
    }
    else {
      await APIFavorite.addLike(favorite);
      ++quantityLike.value;
    }
    clicked.value = !clicked.value;
  }
}