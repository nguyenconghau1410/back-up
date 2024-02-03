import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social/api/api_posts.dart';
import 'package:social/models/post.dart';
import 'package:social/services/upload_file.dart';
import 'package:social/utils/constant.dart';
import 'package:social/utils/video_app.dart';
import 'package:video_player/video_player.dart';

import 'creating_posts.dart';
import 'menu/dashboard.dart';

class CreatingShortCut extends StatefulWidget {
  const CreatingShortCut({super.key});

  @override
  State<CreatingShortCut> createState() => _CreatingShortCutState();
}

class _CreatingShortCutState extends State<CreatingShortCut> {
  VideoUtils? _videoUtils;
  File? _file;
  final _controller = TextEditingController();
  Future<void> _pickVideos() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if(result != null) {
      if(_videoUtils != null) {
        _videoUtils!.dispose();
      }
      setState(() {
        _file = File(result.files.single.path!);
        _videoUtils = VideoUtils(File(result.files.single.path!));
      });
    }
  }

  Future<VideoUtils> _loadVideo() async {
    return _videoUtils!;
  }

  Future<void> _createShortcut() async {
    Fluttertoast.showToast(
        msg: "Đang lưu thướt phim của bạn",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 16
    );
    Future.delayed(const Duration(seconds: 2)).then((_) => Get.offAll(() => const DashBoard()));
    String? src = await FileUpload.uploadImage(_file!, "videos");
    Post post = Post(null, Utils.user!.id!, _controller.text.trim(),
        "Public", src, DateTime.now().toString(), null, "SHORTCUT", null);
    await APIPosts.createPost(post, "Thướt phim");
  }

  @override
  void dispose() {
    super.dispose();
    _videoUtils!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _appBar("Tạo thướt phim"),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _component1(),
            _itemInput(_controller),
            const SizedBox(height: 10,),
            _videoUtils != null ? FutureBuilder(
              future: _loadVideo(),
              builder: (context, snapshot) {
                if(snapshot.connectionState == ConnectionState.done) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    height: 500,
                    child: Obx(
                            () => Stack(
                          children: [
                            Positioned.fill(
                              child: AspectRatio(
                                aspectRatio: _videoUtils!.controller.value.aspectRatio,
                                child: VideoPlayer(_videoUtils!.controller),
                              ),
                            ),
                            Center(
                              child: GestureDetector(
                                onTap: () {
                                  _videoUtils!.onChanged();
                                },
                                child: _videoUtils!.isPlay.value ? const Icon(Icons.pause, size: 50, color: Colors.grey,) : const Icon(Icons.play_arrow, size: 50, color: Colors.grey),
                              ),
                            )
                          ],
                        )
                    ),
                  );
                }
                else {
                  return const Center(child: CircularProgressIndicator(),);
                }
              },
            ) : Container(),
            const SizedBox(height: 20,),
            Center(child: ElevatedButton(
              onPressed: () {
                if(_videoUtils == null) {
                  Fluttertoast.showToast(
                      msg: "Hãy thêm video để tạo thướt phim !",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.TOP,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.grey,
                      textColor: Colors.white,
                      fontSize: 16
                  );
                }
                else {
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        actions: [
                          TextButton(
                            onPressed: () {
                             _createShortcut();
                            },
                            child: const Text("Xác nhận"),
                          ),
                          TextButton(
                            onPressed: () {
                              Get.back();
                            },
                            child: const Text("Đóng"),
                          )
                        ],
                        title: const Text("Thông báo"),
                        content: const Text("Bạn muốn tạo một thướt phim ?"),
                        contentPadding: const EdgeInsets.all(20),
                      )
                  );
                }
              },
              child: const Text("Tạo"),
            ),),
          ],
        ),
      ),
    );
  }
  PreferredSizeWidget _appBar(String text) {
    return AppBar(
      backgroundColor: Colors.black,
      automaticallyImplyLeading: false,
      elevation: 0,
      title: Row(
        children: [
          InkWell(
            onTap: () {
              Get.back();
            },
            child: const Icon(Icons.close, weight: 10,),
          ),
          Expanded(child: Container()),
          Text(text, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 20),),
          Expanded(child: Container()),
          const Text("Tiếp", style: TextStyle(color: Colors.black,fontWeight: FontWeight.w700, fontSize: 20))
        ],
      ),
    );
  }
  Widget _component1() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 14),
      child: Row(
        children: [
          const Text("Chọn video", style: TextStyle(color: Colors.white, fontSize: 18),),
          Expanded(child: Container()),
          ElevatedButton(
            onPressed: () {
              _pickVideos();
            },
            child: const Text("Thêm"),
          )
        ],
      ),
    );
  }
  Widget _itemInput(TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 10),
          child: TextFormField(
            controller: controller,
            style: const TextStyle(fontSize: 18, color: Colors.white),
            decoration: const InputDecoration(
              hintText: "Nhập caption cho thướt phim ...",
              hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey)
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
