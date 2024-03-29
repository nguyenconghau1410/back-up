import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:socials/api/api_posts.dart';
import 'package:socials/utils/constant.dart';
import 'package:video_player/video_player.dart';

import '../../api/api_notification.dart';
import '../../models/favorite.dart';
import '../../models/notification_be.dart';
import '../../models/post_relation.dart';
import '../../services/post_controller.dart';
import '../../utils/video_app.dart';
import '../comment_screen.dart';

class ShortCut extends StatefulWidget {
  const ShortCut({super.key});

  @override
  State<ShortCut> createState() => _ShortCutState();
}

class _ShortCutState extends State<ShortCut> {
  List<PostController> postControllerList = [];
  List<VideoUtils> videoUtilsList = [];
  Future<void> getReels() async {
    List<PostRelation> postRelationList = await APIPosts.getReels(Utils.user!.id!);
    postRelationList.forEach((element) {
      videoUtilsList.add(VideoUtils.src(element.post!.src!));
      PostController postController = PostController();
      postController.init(element, Utils.user!.id!);
      postControllerList.add(postController);
    });
  }

  Future<void> pushNotificationToAdmin(String userid, String postid) async {
    NotificationBE notificationBE = NotificationBE(null, userid, null, "Bài viết có id: $postid có nhiều lượt báo cáo, hãy kiểm tra xem.",
        DateTime.now().toString(), false);
    await APINotification.addNotification(notificationBE);
  }

  Future<void> report(String postid) async {
    await APIPosts.report(postid, Utils.user!.id!);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: getReels(),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(),);
          }
          else if(snapshot.hasError) {
            return const Center(child: CircularProgressIndicator(),);
          }
          else {
            return PageView(
              scrollDirection: Axis.vertical,
              children: List.generate(videoUtilsList.length, (index) => displayVideo(videoUtilsList[index], postControllerList[index])),
            );
          }
        },
      ),
    );
  }

  Widget displayVideo(VideoUtils videoUtils, PostController postController) {
    return Center(
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
                bottom: 40,
                left: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: postController.postRelation!.user!.image == null
                                ? Image.asset("images/user,jpg", width: 40, height: 40, fit: BoxFit.fill,)
                                : Image.network(postController.postRelation!.user!.image!, width: 40, height: 40, fit: BoxFit.fill,),
                        ),
                        const SizedBox(width: 14,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(postController.postRelation!.user!.name!, style: const TextStyle(color: Colors.white, fontSize: 16),),
                            Text(Utils.formatDateToddmmyy(postController.postRelation!.post!.createdAt!), style: const TextStyle(color: Colors.white, fontSize: 16),)
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10,),
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 20,
                      child: Text(postController.postRelation!.post!.content!,
                        style: const TextStyle(fontSize: 16, color: Colors.white),
                        maxLines: 6,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  ],
                ),
              ),
              Positioned(
                right: 14,
                bottom: MediaQuery.of(context).size.height / 3 - 100,
                child: Column(
                  children: [
                    Column(
                      children: [
                        Obx(
                                () => InkWell(
                              onTap: () {
                                postController.onChanged(Favorite(null, Utils.user!.id!, postController.postRelation!.post!.id));
                              },
                              child: postController.clicked.value
                                  ? const Icon(Icons.favorite, color: Colors.red, size: 30,)
                                  : const Icon(Icons.favorite_outline_rounded, color: Colors.white, size: 30,),
                            )
                        ),
                        Obx(
                                () => Text(
                              postController.quantityLike == 0 ? "" : "${postController.quantityLike}",
                              style: const TextStyle(color: Colors.white, fontSize: 16),
                            )
                        )
                      ],
                    ),
                    const SizedBox(height: 10,),
                    InkWell(
                      onTap: () {
                        Get.to(() => CommentScreen(post: postController.postRelation!.post!,));
                      },
                      child: const Icon(FontAwesomeIcons.commentDots, color: Colors.white, size: 26,),
                    ),
                    const SizedBox(height: 10,),
                    InkWell(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor: Colors.black,
                                shape: Border.all(
                                    color: Colors.grey.withOpacity(0.5)
                                ),
                                title: const Center(child: Text('Thêm', style: TextStyle(color: Colors.white),)),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ListTile(
                                      title: const Row(
                                        children: [
                                          Icon(Icons.info, color: Colors.white,),
                                          SizedBox(width: 20,),
                                          Text("Báo xấu", style: TextStyle(color: Colors.white),)
                                        ],
                                      ),
                                      onTap: () {
                                        Get.back();
                                        showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Get.back();
                                                    report(postController.postRelation!.post!.id!);
                                                    if(postController.postRelation!.post!.ids!.length + 1 >= 3) {
                                                      pushNotificationToAdmin("65fafb24f990482dbe723f04", postController.postRelation!.post!.id!);
                                                    }
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
                                              content: const Text("Bạn chắc chắn muốn báo xấu bài viết này !"),
                                              contentPadding: const EdgeInsets.all(20),
                                            )
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              );
                            }
                        );
                      },
                      child: const Icon(Icons.more_vert_outlined, color: Colors.white, size: 24,),
                    )
                  ],
                ),
              )
            ],
          )
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    videoUtilsList.forEach((element) {
      element.dispose();
    });
  }
}
