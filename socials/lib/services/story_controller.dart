import 'package:get/get.dart';
import 'package:socials/api/api_posts.dart';
import 'package:socials/models/story.dart';
import 'package:socials/services/upload_file.dart';
import 'package:socials/utils/constant.dart';

class StoryController extends GetxController {
  var stories = <Story>[].obs;

  Future<void> init(String userid) async {
    stories.value = await APIPosts.getStoryByUserid(userid);
  }

  Future<void> deleteStory(Story story) async {
    stories.remove(story);
    if(story.src_image != null) {
      await FileUpload.deleteFile(story.path!);
    }
    else {
      await FileUpload.deleteFile(story.path!);
    }
    await APIPosts.deleteStoryById(story.id!);
  }

}
