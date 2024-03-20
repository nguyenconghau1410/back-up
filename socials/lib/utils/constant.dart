import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:socials/views/creating_posts.dart';

import '../models/chat_message.dart';
import '../models/following.dart';
import '../models/user.dart';

class Utils {
  static String baseURL = "http://192.168.9.7:8080/api/v1";
  static User? user;
  static List<String> list() {
    return [
      'Billabong',
      'AlexBrush-Regular',
      'Allura-Regular',
      'Arizonia-Regular',
      'ChunkFive-Regular',
      'GrandHotel-Regular',
      'GreatVibes-Regular',
      'Lobster_1.3',
      'OpenSans-Regular',
      'Oswald-Regular',
      'Pacifico',
      'Roboto-Regular'
    ];
  }
  static Future<FileUtils?> loadImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if(result != null) {
      if(result.files.single.extension == "mp4") {
        return FileUtils(File(result.files.single.path!), "VIDEO");
      }
      else if(result.files.single.extension != "mp3") {
        return FileUtils(File(result.files.single.path!), "IMAGE");
      }
    }
    return null;
  }
  static String formatDateToddmmyy(String date) {
    List<String> text = date.split(" ");
    return text.first;
  }
  static String formatDateTohhss(String date) {
    List<String> text = date.split(" ");
    return text[1].substring(0, 5);
  }
}