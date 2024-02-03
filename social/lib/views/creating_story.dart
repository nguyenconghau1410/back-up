import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class CreatingStory extends StatefulWidget {
  const CreatingStory({super.key});

  @override
  State<CreatingStory> createState() => _CreatingStoryState();
}

class _CreatingStoryState extends State<CreatingStory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _appBar("Tạo tin"),
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
}
