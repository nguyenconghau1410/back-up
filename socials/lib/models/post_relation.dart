import 'package:firebase_auth/firebase_auth.dart';
import 'package:socials/models/post.dart';

import 'favorite.dart';

class PostRelation {
  User? user;
  Post? post;
  List<Favorite>? favorites;

  PostRelation(this.user, this.post, this.favorites);
}