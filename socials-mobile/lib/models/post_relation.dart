import 'package:socials/models/post.dart';
import 'package:socials/models/user.dart';

import 'favorite.dart';

class PostRelation {
  User? user;
  Post? post;
  List<Favorite>? favorites;

  PostRelation(this.user, this.post, this.favorites);
}