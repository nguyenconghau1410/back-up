import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lindi_sticker_widget/lindi_controller.dart';
import 'package:lindi_sticker_widget/lindi_sticker_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:socials/api/api_posts.dart';
import 'package:socials/models/story.dart';
import 'package:socials/services/upload_file.dart';
import 'package:socials/utils/constant.dart';
import 'package:text_editor/text_editor.dart';
import 'menu/dashboard.dart';


class StoryDesign extends StatefulWidget {
  const StoryDesign({super.key});

  @override
  State<StoryDesign> createState() => _StoryDesignState();
}

class _StoryDesignState extends State<StoryDesign> {
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
  var _currentColor = Rx<Color>(const Color(0xFFFFFFFF));
  Color _pickerColor = const Color(0xFFFFFFFF);
  File? _file;
  var showTextEditor = false.obs;
  @override
  void initState() {
    super.initState();
  }
  void changeColor() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Hãy chọn màu phù hợp"),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: _pickerColor,
              onColorChanged: (newColor) {
                _pickerColor = newColor;
              },
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('Got it'),
              onPressed: () {
                _currentColor.value = _pickerColor;
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      }
    );
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
      _file = File(pickFile!.path);
    }
  }

  Future<void> _saveChanged() async {
    Fluttertoast.showToast(
        msg: "Đang lưu tin của bạn",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 16
    );
    Uint8List? saveImage = await _controller.saveAsUint8List();
    final tempDir = await getTemporaryDirectory();
    File tempFile = File("${tempDir.path}/${DateTime.now().toString()}.jpg");
    tempFile.writeAsBytesSync(saveImage!);
    Future.delayed(const Duration(seconds: 2)).then((_) => Get.offAll(() => const DashBoard()));
    String filename = "${Utils.user!.name}-${DateTime.now().toString()}-design";
    String? src = await FileUpload.uploadImage(tempFile, "stories", filename);
    Story story = Story(null, Utils.user!.id!, "Public", src, null,
        "stories/$filename" ,DateTime.now().toString(), null);
    await APIPosts.createStory(story);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _appBar("Thiết kế tin"),
      body: Stack(
        children: [
          LindiStickerWidget(
            controller: _controller,
            child: Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color.fromRGBO(138, 35, 135, 1),
                            Color.fromRGBO(233, 64, 87, 1),
                            Color.fromRGBO(242, 113, 33, 1),
                          ]
                      )
                  ),
                ),
                Center(
                    child: Obx(
                          () => Container(
                        width: MediaQuery.of(context).size.width - 20,
                        height: MediaQuery.of(context).size.height * 0.79,
                        decoration: BoxDecoration(
                            color: _currentColor.value,
                            borderRadius: BorderRadius.circular(25)
                        ),
                      ),
                    )
                ),
              ],
            ),
          ),
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
                    showTextEditor.value = false;
                    _controller.addWidget(Text(text, style: style, textAlign: align,));
                  },
                ),
              )
                  : Container()
          )
        ]
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if(_file != null) {
            _controller.addWidget(
              Image.file(_file!)
            );
          }
          else {
            Fluttertoast.showToast(
                msg: "Hãy chọn hình ảnh",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.TOP,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.grey,
                textColor: Colors.white,
                fontSize: 16
            );
          }
        },
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
                          _saveChanged();
                          Get.back();
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
            child: const Text("Tạo", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),),
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
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.color_lens_outlined, color: Colors.white,),
                onPressed: () {
                  changeColor();
                },
              ),
              const Text('Choose Color', style: TextStyle(color: Colors.white),),
            ],
          ),
        ],
      ),
    );
  }
  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
