
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FileUpload {
  static Future<String?> uploadImage(File file, String folder,String filename) async {
    try {
      FirebaseStorage storage = FirebaseStorage.instance;

      Reference ref = storage.ref().child(folder).child(filename);

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