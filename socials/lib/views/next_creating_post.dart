import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:socials/api/api_posts.dart';
import 'package:socials/services/upload_file.dart';
import 'package:socials/utils/constant.dart';
import 'package:socials/utils/video_app.dart';
import 'package:socials/views/creating_posts.dart';
import 'package:socials/views/menu/dashboard.dart';
import 'package:video_player/video_player.dart';

import '../models/images.dart';
import '../models/post.dart';

class NextCreatingPost extends StatefulWidget {
  FileUtils? file;
  List<FileUtils>? files;
  NextCreatingPost({super.key, required this.file, required this.files});

  @override
  State<NextCreatingPost> createState() => _NextCreatingPostState();
}

class _NextCreatingPostState extends State<NextCreatingPost> {
  final _controller = TextEditingController();
  final _locationController = TextEditingController();
  final Map<int, VideoUtils> _videoController = {};
  VideoUtils? _videoUtils;

  Future<void> creatingPost() async {
    if(widget.file != null) {
      String type = "";
      if(widget.file!.type == "IMAGES") {
        type = "images";
      }
      String? url = await FileUpload.uploadImage(widget.file!.file!, type, "${Utils.user!.name}-${DateTime.now().toString()}-post");
      List<Images> images = [];
      if(url != null) {
        images.add(Images(null, url));
      }
      Post post = Post(null, Utils.user!.id, _controller.text,
          "Public", null, DateTime.now().toString(), null, "POST", _locationController.text, images);
      await APIPosts.createPost(post, "Bài viết");
    }
    else {
      List<Images> images = [];
      for(int i = 0; i < widget.files!.length; i++) {
        String type = "";
        if(widget.files![i].type == "IMAGE") {
          type = "images";
        }
        print(widget.files![i].file.toString());
        String? url = await FileUpload.uploadImage(widget.files![i].file!, type, "${Utils.user!.name}-${DateTime.now().toString()}-post");
        print(url);
        if(url != null) {
          images.add(Images(null, url));
        }
      }
      Post post = Post(null, Utils.user!.id, _controller.text,
          "Public", null, DateTime.now().toString(), null, "POST", _locationController.text,images);
      await APIPosts.createPost(post, "Bài viết");
    }
  }

  @override
  void initState() {
    super.initState();
    if(widget.files != null) {
      for(int i = 0; i < widget.files!.length; i++) {
        if(widget.files![i].type == "VIDEO") {
          _videoController[i] = VideoUtils(widget.files![i].file!);
        }
      }
    }
    else {
      if(widget.file!.type == "VIDEO") {
        _videoUtils = VideoUtils(widget.file!.file!);
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    if(_videoController.isNotEmpty) {
      _videoController.forEach((key, value) {
        value.dispose();
      });
    }
    else {
      _videoUtils!.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _appBar("Tạo bài viết"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 10, top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Utils.user!.image != null
                          ? Image.network(Utils.user!.image!, width: 60, height: 60, fit: BoxFit.fill,)
                          : Image.asset("images/user.jpg", width: 60, height: 60, fit: BoxFit.fill)
                  ),
                  const SizedBox(width: 20,),
                  Text(Utils.user!.title!, style: const TextStyle(fontSize: 18, color: Colors.white))
                ],
              ),
              const SizedBox(height: 20,),
              TextFormField(
                controller: _controller,
                maxLines: 6,
                minLines: 4,
                style: const TextStyle(fontSize: 16, color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Bạn đang nghĩ gì?",
                  hintStyle: const TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Colors.black,
                      )
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Colors.black,
                      )
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Colors.black,
                      )
                  ),
                  disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Colors.black,
                      )
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  fillColor: const Color(0x77777C8A),
                  filled: true,
                ),
              ),
              const SizedBox(height: 20,),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: widget.files != null
                    ? Row(
                  children: List.generate(widget.files!.length, (index) => Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: widget.files![index].type == "IMAGE"
                        ? Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(widget.files![index].file!, width: 200, height: 200, fit: BoxFit.fill,),
                        ),
                        Positioned(
                          right: 5,
                          top: 5,
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(15)
                            ),
                            child: const Center(child: Icon(Icons.delete, size: 20, color: Colors.white,),),
                          ),
                        )
                      ],
                    )
                        : Container(
                      width: 200, height: 200,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(50)),
                      child: Obx(
                            () {
                          return Stack(
                            children: [
                              Positioned.fill(
                                child: AspectRatio(
                                  aspectRatio: _videoController[index]!.controller.value.aspectRatio,
                                  child: VideoPlayer(_videoController[index]!.controller),
                                ),
                              ),
                              Center(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _videoController[index]!.onChanged();
                                    });
                                  },
                                  child: _videoController[index]!.isPlay.value ? const Icon(Icons.pause, size: 30, color: Colors.grey,) : const Icon(Icons.play_arrow, size: 30, color: Colors.grey),
                                ),
                              )
                            ],
                          );
                        },
                      ),
                    ),
                  )),
                )
                    : widget.file!.type! == "IMAGE"
                    ? Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(widget.file!.file!, width: 200, height: 200, fit: BoxFit.fill,),
                    ),
                    Positioned(
                      right: 5,
                      top: 5,
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(15)
                        ),
                        child: const Center(child: Icon(Icons.delete, size: 20, color: Colors.white,),),
                      ),
                    )
                  ],
                )
                    : Container(
                    width: 200, height: 200,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(50)),
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
                                  setState(() {
                                    _videoUtils!.onChanged();
                                  });
                                },
                                child: _videoUtils!.isPlay.value ? const Icon(Icons.pause, size: 30, color: Colors.grey,) : const Icon(Icons.play_arrow, size: 30, color: Colors.grey),
                              ),
                            )
                          ],
                        )
                    )
                ),
              ),
              const SizedBox(height: 20,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.location_on_outlined, color: Colors.white,),
                      SizedBox(width: 5,),
                      Text("Vị trí", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500, fontSize: 16),),
                    ],
                  ),
                  TextFormField(
                    controller: _locationController,
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                    decoration: const InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _appBar(String text) {
    return AppBar(
      backgroundColor: Colors.black,
      elevation: 0,
      title: Row(
        children: [
          Text(text, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 18),),
          Expanded(child: Container()),
          InkWell(
            onTap: () {
              Fluttertoast.showToast(
                  msg: "Đang lưu bài viết của bạn",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.TOP,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.grey,
                  textColor: Colors.white,
                  fontSize: 16
              );
              print(DateTime.now().toString());
              Future.delayed(const Duration(seconds: 2)).then((_) => Get.offAll(() => const DashBoard()));
              creatingPost();
            },
            child: const Text("ĐĂNG", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w700, fontSize: 18),),
          )
        ],
      ),
    );
  }
}
