import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:socials/services/checkbox_controller.dart';
import 'package:socials/utils/video_app.dart';
import 'package:socials/views/next_creating_post.dart';
import 'package:video_player/video_player.dart';

class CreatingPosts extends StatefulWidget {
  const CreatingPosts({super.key});

  @override
  State<CreatingPosts> createState() => _CreatingPostsState();
}

class _CreatingPostsState extends State<CreatingPosts> {
  var onClick = true.obs;
  final List<CheckBoxController> _lists = [];
  final List<FileUtils>? selectedFile = [];
  Future<List<FileUtils>> _loadImages() async {
    List<AssetPathEntity> albums = await PhotoManager.getAssetPathList();
    if(albums.isNotEmpty) {
      List<AssetEntity> assets = await albums.first.getAssetListRange(start: 0, end: 30);
      List<FileUtils> files = [];
      for(var x in assets) {
        if(x.type == AssetType.image) {
          files.add(FileUtils(await x.file, "IMAGE"));
        }
        _lists.add(CheckBoxController(false.obs));
      }
      return files;
    }
    return [];
  }

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _appBar("Tạo bài viết"),
      body: Column(
        children: [
          _component1(),
          const SizedBox(height: 20,),
          FutureBuilder(
            future: _loadImages(),
            builder: (context, snapshot) {
              if(snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              else if(snapshot.hasError) {
                return const Center();
              }
              else {
                final data = snapshot.data;
                return Expanded(child: GridView.count(
                  crossAxisCount: 3,
                  mainAxisSpacing: 3,
                  crossAxisSpacing: 3,
                  children: List.generate(data!.length, (index)  {
                    return Obx(
                          () =>  onClick.value == true
                          ? InkWell(
                        onTap: () {
                          Get.to(() => NextCreatingPost(file: data[index]!, files: null,));
                        },
                        child: Image.file(
                          data[index]!.file!,
                          width: MediaQuery.of(context).size.width / 3,
                          height: 100,
                          fit: BoxFit.fill,
                        ),
                      )
                          : Stack(
                        children: [
                          Positioned.fill(
                            child: Image.file(
                              data[index]!.file!,
                              width: MediaQuery.of(context).size.width / 3,
                              height: 100,
                              fit: BoxFit.fill,
                            ),
                          ),
                          Positioned(
                              top: 0,
                              left: 0,
                              child: Theme(
                                data: ThemeData(
                                    checkboxTheme: CheckboxThemeData(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10)
                                        )
                                    )
                                ),
                                child: Obx(
                                      () => Checkbox(
                                    checkColor: Colors.grey,
                                    focusColor: Colors.grey,
                                    value: _lists[index].isCheck.value,
                                    onChanged: (value) {
                                      _lists[index].onChanged();
                                      selectedFile!.add(data[index]!);
                                    },
                                  ),
                                ),
                              )
                          )
                        ],
                      ),
                    );
                  }),
                ));
              }
            },
          )
        ],
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
          Obx(
              () => onClick.value == false
                  ? InkWell(
                      onTap: () {
                        Get.to(() => NextCreatingPost(file: null, files: selectedFile));
                      },
                      child: const Text("Tiếp", style: TextStyle(color: Colors.blue,fontWeight: FontWeight.w400, fontSize: 16),),
                    )
                  : const Text("Tiếp", style: TextStyle(color: Colors.black,fontWeight: FontWeight.w400, fontSize: 16),)
          )
        ],
      ),
    );
  }
  Widget _component1() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 14),
      child: Row(
        children: [
          const Text("Thư viện", style: TextStyle(color: Colors.white, fontSize: 18),),
          Expanded(child: Container()),
          Obx(() => InkWell(
            onTap: () {
              onClick.value = !onClick.value;
            },
            child: onClick.value ? Container(
              height: 24,
              decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(5)
              ),
              child: const Padding(
                padding: EdgeInsets.only(left: 2, right: 3, top: 3, bottom: 3),
                child: Row(
                  children: [
                    Icon(Icons.check_circle_outline, size: 20, color: Colors.white,),
                    SizedBox(width: 3,),
                    Text("Chọn nhiều file", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),)
                  ],
                ),
              ),
            ) : Container(
              height: 24,
              decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(5)
              ),
              child: const Padding(
                padding: EdgeInsets.only(left: 2, right: 3, top: 3, bottom: 3),
                child: Row(
                  children: [
                    Icon(Icons.check_circle_outline, size: 20, color: Colors.white,),
                    SizedBox(width: 3,),
                    Text("Chọn nhiều file", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),)
                  ],
                ),
              ),
            ),
          ))
        ],
      ),
    );
  }
}

class FileUtils {
  File? file;
  String? type;

  FileUtils(this.file, this.type);
}



