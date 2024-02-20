import 'package:socials/models/story.dart';
import 'package:socials/models/user.dart';

class StoryRelation {
  User? user;
  Story? story;

  StoryRelation(this.user, this.story);
}