
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FileUpload {
  static Future<String?> uploadImage(File file, String type) async {
    try {
      FirebaseStorage storage = FirebaseStorage.instance;

      Reference ref = storage.ref().child(type);

      UploadTask uploadTask = ref.putFile(file);

      TaskSnapshot snapshot = await uploadTask.whenComplete(() {
      });

      String imageUrl = await snapshot.ref.getDownloadURL();

      return imageUrl;
    }
    catch(e) {
      print(e);
    }
  }
}