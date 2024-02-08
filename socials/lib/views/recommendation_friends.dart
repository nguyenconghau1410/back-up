import 'package:flutter/material.dart';

class RecommendFriends extends StatefulWidget {
  const RecommendFriends({super.key});

  @override
  State<RecommendFriends> createState() => _RecommendFriendsState();
}

class _RecommendFriendsState extends State<RecommendFriends> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _appBar("Gợi ý kết bạn"),
    );
  }
  PreferredSizeWidget _appBar(String text) {
    return AppBar(
      backgroundColor: Colors.black,
      elevation: 0,
      title: Row(
        children: [
          Text(text, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 20),),
          Expanded(child: Container()),
        ],
      ),
    );
  }
}
