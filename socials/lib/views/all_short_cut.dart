import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:socials/models/favorite.dart';
import 'package:socials/services/post_controller.dart';
import 'package:video_player/video_player.dart';

import '../api/api_posts.dart';
import '../models/post.dart';
import '../models/post_relation.dart';
import '../models/user.dart';
import '../utils/constant.dart';
import '../utils/video_app.dart';
import 'comment_screen.dart';

class AllShortCut extends StatefulWidget {
  User user;
  PostRelation post;
  AllShortCut({super.key, required this.user, required this.post});

  @override
  State<AllShortCut> createState() => _AllShortCutState();
}

class _AllShortCutState extends State<AllShortCut> {
  VideoUtils? videoUtils;
  PostController postController = PostController();

  @override
  void initState() {
    super.initState();
    postController.init(widget.post, widget.user!.id!);
    videoUtils = VideoUtils.src(widget.post.post!.src!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _appBar(),
      body: Center(
        child: Obx(
            () => Stack(
              children: [
                Positioned.fill(
                  child: AspectRatio(
                    aspectRatio: videoUtils!.controller.value.aspectRatio,
                    child: VideoPlayer(videoUtils!.controller),
                  ),
                ),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      videoUtils!.onChanged();
                    },
                    child: videoUtils!.isPlay.value ? const Icon(Icons.pause, size: 50, color: Colors.grey,) : const Icon(Icons.play_arrow, size: 50, color: Colors.grey),
                  ),
                ),
                Positioned(
                  bottom: 80,
                  left: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: widget.user!.image == null
                                ? Image.asset("images/user,jpg", width: 40, height: 40, fit: BoxFit.fill,)
                                : Image.network(widget.user!.image!, width: 40, height: 40, fit: BoxFit.fill,),
                          ),
                          const SizedBox(width: 14,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.user!.name!, style: const TextStyle(color: Colors.white, fontSize: 16),),
                              Text(Utils.formatDateToddmmyy(widget.post.post!.createdAt!), style: const TextStyle(color: Colors.white, fontSize: 16),)
                            ],
                          )
                        ],
                      ),
                      const SizedBox(height: 16,),
                      Text(postController.postRelation!.post!.content == ""
                          ? "" : postController.postRelation!.post!.content!,
                        style: const TextStyle(fontSize: 16, color: Colors.white),
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      )
                    ],
                  ),
                ),
                Positioned(
                  right: 14,
                  bottom: 80,
                  child: Column(
                    children: [
                      Column(
                        children: [
                          Obx(
                                  () => InkWell(
                                onTap: () {
                                  postController.onChanged(Favorite(null, widget.user!.id, postController.postRelation!.post!.id));
                                },
                                child: postController.clicked.value
                                    ? const Icon(Icons.favorite, color: Colors.red, size: 30,)
                                    : const Icon(Icons.favorite_outline_rounded, color: Colors.white, size: 30,),
                              )
                          ),
                          Obx(
                                  () => Text(
                                postController.quantityLike == 0 ? "0" : "${postController.quantityLike}",
                                style: const TextStyle(color: Colors.white, fontSize: 16),
                              )
                          )
                        ],
                      ),
                      const SizedBox(height: 10,),
                      InkWell(
                        onTap: () {
                          Get.to(() => CommentScreen(post: widget.post!.post!,));
                        },
                        child: const Icon(FontAwesomeIcons.commentDots, color: Colors.white, size: 26,),
                      ),

                    ],
                  ),
                )
              ],
            )
        ),
      ),
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

  @override
  void dispose() {
    super.dispose();
    videoUtils!.dispose();
  }
}
