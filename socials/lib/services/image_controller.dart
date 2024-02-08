import 'package:get/get.dart';

class ImageController extends GetxController {
  RxString imageUrl = "".obs;

  void loadImage(String src) {
    imageUrl.value = src;
  }
}