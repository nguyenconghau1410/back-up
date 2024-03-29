import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:socials/api/api_notification.dart';
import 'package:socials/api/api_posts.dart';
import 'package:socials/models/images.dart';
import 'package:socials/models/notification_be.dart';
import 'package:socials/models/story.dart';
import 'package:socials/models/story_relation.dart';
import 'package:socials/services/post_controller.dart';
import 'package:socials/utils/constant.dart';
import 'package:socials/views/display_story.dart';
import 'package:socials/views/messenger_screen.dart';
import 'package:socials/views/notification_screen.dart';
import 'package:socials/views/others_profile.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

import '../../models/favorite.dart';
import '../../models/post_relation.dart';
import '../comment_screen.dart';
import '../story_design.dart';
import '../story_galary.dart';
import '../view_image.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<PostController> postControllers = [];
  @override
  void initState() {
    super.initState();
  }

  Future<List<StoryRelation>> getStoryOfFriends() async {
    return APIPosts.getStoryOfFriends(Utils.user!.id!);
  }

  Future<void> getOtherPost() async {
    List<PostRelation> post = await APIPosts.getOtherPost(Utils.user!.id!);
    List<PostController> list = [];
    post.forEach((element) {
      PostController postController = PostController();
      postController.init(element, Utils.user!.id!);
      list.add(postController);
    });
    postControllers = list;
  }

  Future<void> pushNotificationToOther(String userid) async {
    NotificationBE notificationBE = NotificationBE(null, userid, Utils.user, "${Utils.user!.title} đã thích bài viết của bạn",
        DateTime.now().toString(), false);
    await APINotification.addNotification(notificationBE);
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _appBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: FutureBuilder(
                future: getStoryOfFriends(),
                builder: (context, snapshot) {
                  if(snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator(),);
                  }
                  else if(snapshot.hasError) {
                    return const Center(child: CircularProgressIndicator(),);
                  }
                  else {
                    final data = snapshot.data;
                    data!.insert(0, StoryRelation(null, null));
                    return Row(
                      children: List.generate(data.length, (index) {
                        if(index == 0) {
                          return _myStory();
                        }
                        else {
                          return _story(data[index]);
                        }
                      }),
                    );
                  }
                },
              ),
            ),
            const SizedBox(height: 20,),
            FutureBuilder(
              future: getOtherPost(),
              builder: (context, snapshot) {
                if(snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(),);
                }
                else if(snapshot.hasError) {
                  print(snapshot.error);
                  return const Center(child: CircularProgressIndicator(),);
                }
                else {
                  return postControllers.isNotEmpty
                    ? Column(
                        children: List.generate(postControllers.length, (index) => _buildPost(postControllers[index])),
                      )
                    : const Padding(
                        padding: EdgeInsets.only(top: 50),
                        child: Center(
                          child: Text(
                            "Hãy theo dõi người khác để xem bài viết của họ",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16
                            ),
                          ),
                        ),
                      );
                }
              },
            )
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _appBar() {
    return AppBar(
      backgroundColor: Colors.black,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          const Text("Znet", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 32, fontFamily: "Pacifico"),),
          Expanded(child: Container()),
          InkWell(
            onTap: () {
              Get.to(() => const NotificationScreen());
            },
            child: const Icon(Icons.favorite_outline_rounded, size: 30,),
          ),
          const SizedBox(width: 25,),
          InkWell(
            onTap: () {
              Get.to(() => const MessengerScreen());
            },
            child: const Icon(FontAwesomeIcons.facebookMessenger,),
          ),
          const SizedBox(width: 5,)
        ],
      ),
    );
  }
  Widget _buildPost(PostController post) {
    bool flag = false;
    post.postRelation!.post!.ids!.forEach((element) {
      if(element == Utils.user!.id) {
        flag = true;
      }
    });
    return !flag ? Container(
      decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(
                width: 1.0,
                color: Colors.grey
            ),
            bottom: BorderSide(
                width: 1.0,
                color: Colors.grey
            ),
          )
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 20, bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const SizedBox(width: 10,),
                InkWell(
                  onTap: () {
                    Get.to(() => OthersProfile(user: post.postRelation!.user!));
                  },
                  child: ClipOval(
                    child: post.postRelation!.user!.image == null
                        ? Image.asset(
                      "images/login.jpg",
                      width: 40,
                      height: 40,
                      fit: BoxFit.fill,
                    )
                        : Image.network(post.postRelation!.user!.image!, width: 40, height: 40, fit: BoxFit.fill,),
                  ),
                ),
                const SizedBox(width: 10,),
                InkWell(
                  onTap: () {
                    Get.to(() => OthersProfile(user: post.postRelation!.user!));
                  },
                  child: Text(post.postRelation!.user!.name!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),),
                ),
                Expanded(child: Container()),
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
                                                 report(post.postRelation!.post!.id!);
                                                 if(post.postRelation!.post!.ids!.length + 1 >= 3) {
                                                   pushNotificationToAdmin("65fafb24f990482dbe723f04", post.postRelation!.post!.id!);
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
                  child: const Icon(Icons.more_vert, color: Colors.white, size: 24,),
                )
              ],
            ),
            const SizedBox(height: 30,),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: RichText(
                text: TextSpan(
                    style: DefaultTextStyle.of(context).style,
                    children: [
                      TextSpan(
                          text: post.postRelation!.post!.content!,
                          style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white
                          )
                      )
                    ]
                ),
              ),
            ),
            const SizedBox(height: 5,),
            Container(
                constraints: const BoxConstraints(
                    maxHeight: 450
                ),
                child: _buildListImages(post.postRelation!.post!.images!)
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 30),
              child: Row(
                children: [
                  Obx(
                          () => InkWell(
                        onTap: () {
                          post.onChanged(Favorite(null, Utils.user!.id!, post.postRelation!.post!.id));
                          if(Utils.user!.id != post.postRelation!.user!.id) {
                            if(!post.clicked.value) {
                              pushNotificationToOther(post.postRelation!.user!.id!);
                            }
                          }
                        },
                        child: post.clicked.value
                            ? const Icon(Icons.favorite, color: Colors.red, size: 24,)
                            : const Icon(Icons.favorite_outline_rounded, color: Colors.white, size: 24,),
                      )
                  ),
                  const SizedBox(width: 20,),
                  InkWell(
                    onTap: () {
                      Get.to(() => CommentScreen(post: post.postRelation!.post!,));
                    },
                    child: const Icon(FontAwesomeIcons.commentDots, color: Colors.white, size: 24,),
                  ),
                  const SizedBox(width: 20,),
                  const Icon(Icons.share, color: Colors.white, size: 24,)
                ],
              ),
            ),
            Obx(
                    () => Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: Text("${post.quantityLike.value} lượt thích", style: const TextStyle(color: Colors.white),)
                )
            )
          ],
        ),
      ),
    ) : Container();
  }
  Widget _buildListImages(List<Images> list) {
    return PageView(
      children: List.generate(list.length, (index) {
        int cnt = list.length;
        int i = index + 1;
        return InkWell(
          onTap: () {
            Get.to(() => ViewImage(images: list));
          },
          child: Stack(
            children: [
              _buildImage(list[index]),
              Positioned(
                top: 5,
                right: 10,
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                  child: Text(cnt == 1 ? "" : "$i/$cnt", style: const TextStyle(color: Colors.white),),
                ),
              )
            ],
          ),
        );
      })
    );
  }
  Widget _buildImage(Images images) {
    return Image.network(
      images!.image!,
      width: MediaQuery.of(context).size.width, fit: BoxFit.fill,
    );
  }
  Widget _story(StoryRelation story) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 20),
      child: InkWell(
        borderRadius: BorderRadius.circular(35),
        onTap: () {
          Get.to(() => DisplayStory(story: story.story!, user: story.user!,));
        },
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(40),
                      border: Border.all(color: Colors.grey)
                  ),
                ),
                story.story!.src_image != null
                ? Positioned(
                  top: 5,
                  left: 5,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(35),
                    child: Image.network(story.story!.src_image!, width: 70, height: 70, fit: BoxFit.cover,),
                  ),
                )
                : const Positioned(
                  top: 30,
                  left: 30,
                  child: Center(child: Icon(Icons.play_arrow, color: Colors.grey,),),
                )    
              ],
            ),
            const SizedBox(height: 10,),
            Text(story.user!.name!, style: const TextStyle(fontSize: 16, color: Colors.white,),)
          ],
        ),
      ),
    );
  }
  Widget _myStory() {
    return Padding(
      padding: const EdgeInsets.only(left: 18, top: 20),
      child: Row(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(40),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: Colors.black,
                      shape: Border.all(
                          color: Colors.grey.withOpacity(0.5)
                      ),
                      title: const Center(child: Text('Tạo', style: TextStyle(color: Colors.white),)),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            title: const Row(
                              children: [
                                Icon(Icons.add_circle_outline_outlined, color: Colors.white,),
                                SizedBox(width: 20,),
                                Text("Tin", style: TextStyle(color: Colors.white),)
                              ],
                            ),
                            onTap: () {
                              Get.to(() => const StoryGallary());
                            },
                          ),
                          ListTile(
                            title: const Row(
                              children: [
                                Icon(Icons.design_services_outlined, color: Colors.white,),
                                SizedBox(width: 20,),
                                Text("Thiết kế tin", style: TextStyle(color: Colors.white),)
                              ],
                            ),
                            onTap: () {
                              Get.to(() => const StoryDesign());
                            },
                          ),
                        ],
                      ),
                    );
                  }
              );
            },
            child: Column(
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: Utils.user!.image == null
                        ? Image.asset("images/user.jpg", width: 80, height: 80, fit: BoxFit.fill,)
                        : Image.network(Utils.user!.image!, width: 80, height: 80, fit: BoxFit.fill),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 9,
                      child: Image.asset(
                        "images/add.png",
                        width: 20,
                        height: 20,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 10,),
                const Text("Thêm tin", style: TextStyle(fontSize: 16, color: Colors.white,),)
              ],
            ),
          ),

        ],
      ),
    );
  }
}
