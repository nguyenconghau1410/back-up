import 'package:get/get.dart';
import 'package:socials/api/api_favorite.dart';
import 'package:socials/models/comment.dart';
class CommentController extends GetxController {
  var comments = <Comment>[].obs;

  Future<void> init(String postid) async {
    comments.value = await APIFavorite.getComments(postid);
  }

  Future<void> addComment(Comment comment) async {
    comments.add((await APIFavorite.addComment(comment))!);
    // comments.insert(0, (await APIFavorite.addComment(comment))!);
  }
  Future<void> addFake(Comment comment, String postid, String commentId) async {
    await APIFavorite.addCommentNode1(comment, postid, commentId);
    comments.add(Comment.none());
    comments.removeLast();
  }

  int count() {
    int cnt = 0;
    comments.forEach((element) {
      if(element.replies != null) {
        cnt += element.replies!.length;
      }
      cnt += 1;
    });
    return cnt;
  }
}