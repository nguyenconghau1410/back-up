import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lindi_sticker_widget/lindi_controller.dart';
import 'package:lindi_sticker_widget/lindi_sticker_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:socials/models/story.dart';
import 'package:text_editor/text_editor.dart';
import 'package:video_player/video_player.dart';

import '../api/api_posts.dart';
import '../models/images.dart';
import '../models/post.dart';
import '../services/upload_file.dart';
import '../utils/constant.dart';
import '../utils/video_app.dart';
import 'creating_posts.dart';
import 'menu/dashboard.dart';

class StoryGallary extends StatefulWidget {
  const StoryGallary({super.key});

  @override
  State<StoryGallary> createState() => _StoryGallaryState();
}

class _StoryGallaryState extends State<StoryGallary> {
  final LindiController _controller = LindiController(
    borderColor: Colors.white,
    iconColor: Colors.black,
    showDone: true,
    showClose: true,
    showFlip: true,
    showStack: true,
    showLock: true,
    showAllBorders: true,
    shouldScale: true,
    shouldRotate: true,
    shouldMove: true,
    minScale: 0.5,
    maxScale: 4,
  );
  VideoUtils? _videoUtils;
  FileUtils? _fileUtils;
  File? _file;
  var showTextEditor = false.obs;
  Future<void> _chooseImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if(result != null) {
      if(result.files.single.extension == "mp4") {
        setState(() {
          _fileUtils =  FileUtils(File(result.files.single.path!), "VIDEO");
          _videoUtils = VideoUtils(File(result.files.single.path!));
        });
      }
      else if(result.files.single.extension != "mp3") {
        setState(() {
          _fileUtils = FileUtils(File(result.files.single.path!), "IMAGE");
        });
      }
    }
  }
  Future<void> _pickImageGallery() async {
    XFile? pickFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if(pickFile != null) {
      _file = File(pickFile!.path);
    }
  }
  Future<void> _pickImageCamera() async {
    XFile? pickFile = await ImagePicker().pickImage(source: ImageSource.camera);
    if(pickFile != null) {
      setState(() {
        _file = File(pickFile!.path);
      });
    }
  }
  Future<FileUtils> _loadImage() async {
    return _fileUtils!;
  }
  Future<void> _saveStory() async {
    Fluttertoast.showToast(
        msg: "Đang lưu tin của bạn",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 16
    );
    if(_videoUtils == null) {
      Uint8List? saveImage = await _controller.saveAsUint8List();
      final tempDir = await getTemporaryDirectory();
      File tempFile = File("${tempDir.path}/${DateTime.now().toString()}.jpg");
      tempFile.writeAsBytesSync(saveImage!);
      Future.delayed(const Duration(seconds: 2)).then((_) => Get.offAll(() => const DashBoard()));
      String? src = await FileUpload.uploadImage(tempFile, "stories", "${Utils.user!.name}-${DateTime.now().toString()}-gallery");
      Story story = Story(null, Utils.user!.id, "Public", src,
          null, DateTime.now().toString(), null);
      await APIPosts.createStory(story);
    }
    else {
      Future.delayed(const Duration(seconds: 2)).then((_) => Get.offAll(() => const DashBoard()));
      String? src = await FileUpload.uploadImage(_fileUtils!.file!, "stories", "${Utils.user!.name}-${DateTime.now().toString()}-gallery");
      Story story = Story(null, Utils.user!.id, "Public", null,
          src, DateTime.now().toString(), null);
      await APIPosts.createStory(story);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _appBar("Tạo tin"),
      body: Stack(
        children: [
          _fileUtils != null
              ? FutureBuilder(
            future: _loadImage(),
            builder: (context, snapshot) {
              if(snapshot.connectionState == ConnectionState.done) {
                if(_fileUtils!.type == "IMAGE") {
                  return LindiStickerWidget(
                      controller: _controller,
                      child: Container(
                        constraints: const BoxConstraints(
                            maxHeight: 640
                        ),
                        child: Image.file(
                          snapshot.data!.file!,
                          width: MediaQuery.of(context).size.width,
                          fit: BoxFit.fill,
                        ),
                      )
                  );
                }
                else {
                  return LindiStickerWidget(
                    controller: _controller,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: Obx(
                              () => Stack(
                            children: [
                              Positioned.fill(child: AspectRatio(
                                aspectRatio: _videoUtils!.controller.value.aspectRatio,
                                child: VideoPlayer(_videoUtils!.controller),
                              )),
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
                    ),
                  );
                }
              }
              else {
                return const CircularProgressIndicator();
              }
            },
          )
              : Center(child: InkWell(
            onTap: () {
              _chooseImage();
            },
            child: const Icon(Icons.camera_alt, size: 100, color: Colors.grey,),
          ),),
          Obx(
                  () => showTextEditor.value == true
                  ? Scaffold(
                backgroundColor: Colors.black87,
                body: TextEditor(
                  fonts: Utils.list(),
                  textStyle: const TextStyle(),
                  minFontSize: 10,
                  maxFontSize: 40,
                  onEditCompleted: (style, align, text) {
                    _controller.addWidget(Text(text, style: style, textAlign: align,));
                    showTextEditor.value = false;
                  },
                ),
              )
                  : Container()
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _controller.addWidget(
              Image.file(_file!)
          );
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: _bottomAppBar(),
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
          InkWell(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    actions: [
                      TextButton(
                        onPressed: () {
                          _saveStory();
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
                    content: const Text("Bạn muốn tạo một tin ?"),
                    contentPadding: const EdgeInsets.all(20),
                  )
              );
            },
            child: const Text("Tạo", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w500, fontSize: 16),),
          )
        ],
      ),
    );
  }
  Widget _bottomAppBar() {
    return BottomAppBar(
      color: Colors.black,
      shape: const CircularNotchedRectangle(),
      notchMargin: 8.0,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.text_fields, color: Colors.white,),
                onPressed: () {
                  showTextEditor.value = true;
                },
              ),
              const Text('Add Text', style: TextStyle(color: Colors.white),),
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.image_outlined, color: Colors.white,),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: Colors.black,
                          shape: Border.all(
                              color: Colors.grey.withOpacity(0.5)
                          ),
                          title: const Center(child: Text('Chọn', style: TextStyle(color: Colors.white),)),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                title: const Row(
                                  children: [
                                    Icon(Icons.camera_alt_outlined, color: Colors.white,),
                                    SizedBox(width: 20,),
                                    Text("Camera", style: TextStyle(color: Colors.white),)
                                  ],
                                ),
                                onTap: () {
                                  _pickImageCamera();
                                },
                              ),
                              ListTile(
                                title: const Row(
                                  children: [
                                    Icon(Icons.image_rounded, color: Colors.white,),
                                    SizedBox(width: 20,),
                                    Text("Gallery", style: TextStyle(color: Colors.white),)
                                  ],
                                ),
                                onTap: () {
                                  _pickImageGallery();
                                },
                              ),
                            ],
                          ),
                        );
                      }
                  );
                },
              ),
              const Text('Add Images', style: TextStyle(color: Colors.white),),
            ],
          ),
        ],
      ),
    );
  }
  @override
  void dispose() {
    super.dispose();
    if(_videoUtils != null) {
      _videoUtils!.dispose();
    }
  }
}
