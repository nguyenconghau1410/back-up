
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreatingPosts extends StatefulWidget {
  const CreatingPosts({super.key});

  @override
  State<CreatingPosts> createState() => _CreatingPostsState();
}

class _CreatingPostsState extends State<CreatingPosts> {
  var onClick = true.obs;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _appBar("Tạo bài viết"),
      body: Column(
        children: [
          _component1()
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
          const Text("Tiếp", style: TextStyle(color: Colors.blue,fontWeight: FontWeight.w400, fontSize: 16),),
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
