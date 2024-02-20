import 'package:flutter/material.dart';

import '../api/api_posts.dart';
import '../models/post_relation.dart';
import '../models/user.dart';
import '../utils/constant.dart';
import '../utils/video_app.dart';

class AllShortCut extends StatefulWidget {
  User user;
  AllShortCut({super.key, required this.user});

  @override
  State<AllShortCut> createState() => _AllShortCutState();
}

class _AllShortCutState extends State<AllShortCut> {
  List<VideoUtils> videos = [];

  Future<void> _getShortCut() async {
    List<PostRelation> posts = await APIPosts.getAllShortCut(Utils.user!.id!);
    posts.forEach((element) {
      videos.add(VideoUtils.src(element.post!.src!));
    });
  }
  @override
  void dispose() {
    super.dispose();
    if(videos.isNotEmpty) {
      videos.forEach((element) {
        element.dispose();
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
    );
  }

  PreferredSizeWidget _appBar() {
    return AppBar(
      backgroundColor: Colors.black,
      title: Row(
        children: [
          Text(widget.user.name!, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
        ],
      ),
    );
  }
}
