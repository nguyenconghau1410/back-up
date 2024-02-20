
import 'dart:convert';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
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
  static Future<void> deleteFile(String pathFile) async {
    try {
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref = storage.ref().child(pathFile);
      await ref.delete();
    }
    catch(e) {
      rethrow;
    }
  }
  static Future<Map<String, dynamic>> authorizeAccount() async {
    try {
      String apiUrl = 'https://api.backblazeb2.com/b2api/v3/b2_authorize_account';
      String applicationKeyId = '005fff7761462010000000001';
      String applicationKey = 'K0051PNGdx1iO5kenEk4ba3IcdhozRU';

      String credentials = 'Basic ${base64.encode(utf8.encode('$applicationKeyId:$applicationKey'))}';
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': '$credentials',
          'Content-Type': 'application/json'
        }
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to authorize account. Status code: ${response.statusCode}');
      }
    }
    catch(e) {
      print(e.toString());
      rethrow;
    }
  }
  static Future<Map<String, dynamic>> b2GetUrlUpload() async {
    try {
      Map<String, dynamic> mp = await authorizeAccount();
      String apiUrl = mp['apiInfo']['storageApi']['apiUrl'];
      String bucketId = "bf5fefa70776a13486d20011";
      String authorizeToken = mp['authorizationToken'];
      final response = await http.get(
          Uri.parse("$apiUrl/b2api/v3/b2_get_upload_url").replace(queryParameters: {"bucketId": bucketId}),
          headers: {
            'Authorization': authorizeToken,
            'Content-Type': 'application/json'
          }
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to authorize account. Status code: ${response.statusCode}');
      }
    }
    catch(e) {
      print(e.toString());
      rethrow;
    }
  }
  static Future<void> uploadVideoToB2Storage(File file) async {
    Map<String, dynamic> mp = await b2GetUrlUpload();
    String url = mp['uploadUrl'];
    String token = mp['authorizationToken'];
    String bucketId = 'bf5fefa70776a13486d20011';
    String fileName = file.path.split('/').last;
    List<int> fileBytes = await file.readAsBytes();
    final response = await http.post(
      Uri.parse(url),
        headers: {
          'Authorization': token,
          'Content-Type': 'b2/x-auto',
          'X-Bz-File-Name': fileName,
          'Content-Length': '${fileBytes.length}',
          'X-Bz-Content-Sha1': sha1.convert(fileBytes).toString()
        },
      body: fileBytes
    );
    if (response.statusCode == 200) {
      print(json.decode(response.body));
      print('Upload successful!');
    } else {
      print('Failed to upload file. Status code: ${response.statusCode}');
    }

  }
}