import 'dart:io';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
class VideoUtils extends GetxController {
  var isPlay = false.obs;
  late VideoPlayerController controller;

  VideoUtils(File file) {
    controller = VideoPlayerController.file(file)..initialize()..setLooping(true);
    if(isPlay.value == true) {
      isPlayVideo();
    }
    else {
      isPauseVideo();
    }
  }

  void onChanged() {
    if(isPlay.value == false) {
      isPlayVideo();
    }
    else {
      isPauseVideo();
    }
    isPlay.value = !isPlay.value;
  }

  void isPlayVideo() {
    if(controller != null) controller.play();
  }

  void isPauseVideo() {
    if(controller != null) controller.pause();
  }

  void dispose() {
    controller.dispose();
  }
}