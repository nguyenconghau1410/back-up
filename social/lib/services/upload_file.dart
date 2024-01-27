
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FileUpload {
  static Future<String?> uploadImage(File file) async {
    try {
      FirebaseStorage storage = FirebaseStorage.instance;

      Reference ref = storage.ref().child("images");

      UploadTask uploadTask = ref.putFile(file);

      TaskSnapshot snapshot = await uploadTask.whenComplete(() {
        Get.snackbar(
          "Upload file",
          "Đã upload thành công",
            duration: const Duration(seconds: 3),
            snackPosition: SnackPosition.TOP,
            colorText: Colors.white,
            backgroundColor: Colors.black
        );
      });

      String imageUrl = await snapshot.ref.getDownloadURL();

      return imageUrl;
    }
    catch(e) {
      print(e);
    }
  }
}