import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class CheckBoxController extends GetxController {
  var isCheck = false.obs;


  CheckBoxController(this.isCheck);

  void onChanged() {
    isCheck.value = !isCheck.value;
  }
}
