import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:social/views/creating_posts.dart';

import '../models/following.dart';
import '../models/user.dart';

class Utils {
  static String baseURL = "http://192.168.2.10:8080/api/v1";
  static User? user;

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
}