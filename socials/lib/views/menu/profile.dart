import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socials/api/api_following.dart';
import 'package:socials/api/api_images.dart';
import 'package:socials/api/api_posts.dart';
import 'package:socials/api/api_service.dart';
import 'package:socials/connect/connecting_websocket.dart';
import 'package:socials/models/images.dart';
import 'package:socials/services/following_controller.dart';
import 'package:socials/services/image_controller.dart';
import 'package:socials/services/upload_file.dart';
import 'package:socials/shared_preferences/local_storage.dart';
import 'package:socials/utils/constant.dart';
import 'package:socials/views/all_posts.dart';
import 'package:socials/views/all_short_cut.dart';
import 'package:socials/views/all_stories.dart';
import 'package:socials/views/creating_posts.dart';
import 'package:socials/views/creating_shortcut.dart';
import 'package:socials/views/display_story.dart';
import 'package:socials/views/story_design.dart';
import 'package:socials/views/edit_profile.dart';
import 'package:socials/views/friends.dart';
import 'package:socials/views/login_screen.dart';
import 'package:socials/views/story_galary.dart';
import 'package:video_player/video_player.dart';

import '../../models/post_relation.dart';
import '../../models/story.dart';
import '../../utils/video_app.dart';
import '../test.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  var isObx = true.obs;
  var isItemObx = true.obs;
  List<String> list = ["Ngọc Quỳnh", "Thanh Bình", "Hồng Phương", "Thúy Vân"];
  final ImageController _imageController = Get.put(ImageController());
  final FollowingController _followingController = Get.put(FollowingController());
  List<VideoUtils> videos = [];
  @override
  void initState() {
    _imageController.imageUrl.value = Utils.user!.image == null
        ? "images/user.jpg" : Utils.user!.image!;
    _followingController.getData(Utils.user!.id!);
    _getCountPost();
  }

  void uploadImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if(result != null) {
      File file = File(result.files.single.path!);
      String? imageUrl = await FileUpload.uploadImage(file, "images-profile", "${Utils.user!.name}-${DateTime.now().toString()}-profile");
      Utils.user!.image = imageUrl;
      await APIService.updateUser(Utils.user!);
      Get.snackbar(
          "Upload file",
          "Đã upload thành công",
          duration: const Duration(seconds: 3),
          snackPosition: SnackPosition.TOP,
          colorText: Colors.white,
          backgroundColor: Colors.black
      );
      _imageController.loadImage(imageUrl!);
    }
    else {
      print("error");
    }
  }
  Future<int> _getCountPost() async {
    return await APIPosts.countByUserid(Utils.user!.id!);
  }
  Future<List<Images>> _getImages() async {
    return APIImages.getByUserid(Utils.user!.id!);
  }
  Future<List<Story>> _getStory() async {
    return APIPosts.getStoryByUserid(Utils.user!.id!);
  }
  Future<List<PostRelation>> _getShortCut() async {
    // List<PostRelation> posts = await APIPosts.getAllShortCut(Utils.user!.id!);
    // posts.forEach((element) {
    //   videos.add(VideoUtils.src(element.post!.src!));
    // });
    return APIPosts.getAllShortCut(Utils.user!.id!);
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
            _component1(),
            const SizedBox(height: 25,),
            _component2(),
            const SizedBox(height: 25,),
            _component3(list),
            const SizedBox(height: 20,),
            Row(
              children: [
                const SizedBox(width: 16,),
                const Text("Stories", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500,),),
                Expanded(child: Container()),
                InkWell(
                  onTap: () {
                    Get.to(() => AllStory(user: Utils.user!,));
                  },
                  child: const Text("Xem tất cả", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w500,),),
                ),
                const SizedBox(width: 5,),
              ],
            ),
            const SizedBox(height: 10,),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: FutureBuilder(
                future: _getStory(),
                builder: (context, snapshot) {
                  if(snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  else if(snapshot.hasError) {
                    return const CircularProgressIndicator();
                  }
                  else {
                    final data = snapshot.data;
                    return Row(
                      children: List.generate(data!.length <= 6 ? data!.length : 6, (index) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 16),
                          child: InkWell(
                            onTap: () {
                              Get.to(() => DisplayStory(story: data[index]!, user: Utils.user!,));
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
                                    data[index]!.src_image != null
                                    ? Positioned(
                                        top: 5,
                                        left: 5,
                                        child: ClipRRect(
                                            borderRadius: BorderRadius.circular(35),
                                            child: Image.network(data[index]!.src_image!, width: 70, height: 70, fit: BoxFit.fill,)
                                        ),
                                      )
                                    : const Positioned(
                                        top: 30,
                                        left: 30,
                                        child: Center(child: Icon(Icons.play_arrow, color: Colors.grey,),),
                                      )
                                  ],
                                ),
                                Text(Utils.formatDateToddmmyy(data[index]!.createdAt!), style: const TextStyle(color: Colors.grey, fontFamily: "Arizonia-Regular"),)
                              ],
                            ),
                          ),
                        );
                      }),
                    );
                  }
                },
              ),
            ),
            const SizedBox(height: 35,),
            Row(
              children: [
                _buildButton(true, const Icon(Icons.calendar_view_month_rounded, color: Colors.white,)),
                _buildButton(false, const Icon(Icons.video_library_outlined, color: Colors.white,))
              ],
            ),
            const SizedBox(height: 10,),
            Obx(() {
              bool isDisplay = isItemObx.value;
              if(isDisplay) {
                if(videos.isNotEmpty) {
                  videos.forEach((element) {
                    element.dispose();
                  });
                  videos = [];
                  print(videos);
                }
                print(videos.length);
                return FutureBuilder(
                  future: _getImages(),
                  builder: (context, snapshot) {
                    if(snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator(),);
                    }
                    else if(snapshot.hasError) {
                      return const Center(child: CircularProgressIndicator(),);
                    }
                    else {
                      final data = snapshot.data;
                      return Container(
                        child: GridView.count(
                          crossAxisCount: 3,
                          mainAxisSpacing: 3,
                          crossAxisSpacing: 3,
                          shrinkWrap: true,
                          children: List.generate(data!.length, (index) {
                            return _buildImages(data[index]!);
                          }),
                        ),
                      );
                    }
                  },
                );
              }
              else {
                return FutureBuilder(
                  future: _getShortCut(),
                  builder: (context, snapshot) {
                    if(snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator(),);
                    }
                    else if(snapshot.hasError) {
                      return const Center(child: CircularProgressIndicator(),);
                    }
                    else {
                      final data = snapshot.data;
                      return Container(
                        child: GridView.count(
                          crossAxisCount: 3,
                          mainAxisSpacing: 3,
                          crossAxisSpacing: 3,
                          shrinkWrap: true,
                          children: List.generate(data!.length, (index) {
                            videos.add(VideoUtils.src(data[index].post!.src!));
                            return _buildVideos(videos.last);
                          }),
                        ),
                      );
                    }
                  },
                );
              }
            }),
          ],
        ),
      ),
    );
  }
  PreferredSizeWidget _appBar() {
    return AppBar(
      backgroundColor: Colors.black,
      title: Row(
        children: [
          Text(Utils.user!.name!, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
          const Icon(Icons.keyboard_arrow_down_sharp),
          Expanded(child: Container()),
          InkWell(
            onTap: () {
              _showServiceSelectionDialog(context);
            },
              child: const Icon(Icons.add_box_outlined, size: 32,)
          ),
          const SizedBox(width: 24,),
          InkWell(
            onTap: () {
              ConnectWebSocket.onDisconnect(Utils.user!.email);
              LocalStorage.deleteUser();
              Get.offAll(() => const LoginScreen());
            },
            child: const Icon(Icons.logout, size: 28,),
          ),
        ],
      ),
    );
  }

  Widget _component1() {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, top: 16),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  uploadImage();
                },
                child: Obx(
                    () => ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: _imageController.imageUrl.value == "images/user.jpg" ?
                            Image.asset(_imageController.imageUrl.value, width: 80, height: 80, fit: BoxFit.fill,) :
                            Image.network(_imageController.imageUrl.value, width: 80, height: 80, fit: BoxFit.fill)
                      ,
                    )
                ),
              ),
              const SizedBox(height: 5,),
              Text(Utils.user!.title ?? "", style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500, fontFamily: 'Roboto'),)
            ],
          ),
        ),
        Expanded(child: Container()),
        FutureBuilder(
          future: _getCountPost(),
          builder: (context, snapshot) {
            final data = snapshot.data;
            return Row(
              children: [
                _itemComponent1(data ?? 0, "Bài viết")
              ],
            );
          },
        ),
        Obx(() {
          final isFollowing = _followingController.isFollowing.value;
          final beingFollewed = _followingController.beingFollowed.value;
          return Row(
            children: [
              _itemComponent1(beingFollewed!.length, "Người theo dõi"),
              _itemComponent1(isFollowing!.length, "Đang theo dõi"),
            ],
          );
        }),
        Expanded(child: Container()),
      ],
    );
  }
  Widget _component2() {
    return Row(
      children: [
        Expanded(child: Container()),
        _itemComponent2("Chỉnh sửa trang cá nhân"),
        Expanded(child: Container()),
        _itemComponent2("Chia sẻ trang cá nhân"),
        Expanded(child: Container()),
        SizedBox(
          width: 40,
          height: 36,
          child: TextButton(
            style: TextButton.styleFrom(
                backgroundColor: Colors.grey[700],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)
                )
            ),
            onPressed: () {

            },
            child: Obx(
                    () => GestureDetector(
                  onTap: () {
                    isObx.value = !isObx.value;
                  },
                  child: Icon(
                    isObx.value ? Icons.person_add_outlined : Icons.person_add_rounded,
                    color: Colors.white,
                  ),
                )
            ),
          ),
        ),
        Expanded(child: Container()),
      ],
    );
  }
  Widget _component3(List<String> list) {
    return Obx(() {
      bool isDisplay = isObx.value;
      if(!isDisplay) {
        return Padding(
          padding: const EdgeInsets.only(left: 8, right: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    "Khám phá mọi người", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Expanded(child: Container()),
                  InkWell(
                    onTap: () {
                      APIFollowing.getFollowingId(Utils.user!.id);
                    },
                    child: const Text(
                      "Xem tất cả", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 16,),
              SizedBox(
                  height: 220,
                  child: _listItemFriend(list)
              ),
            ],
          ),
        );
      }
      else {
        return Container();
      }
    });
  }

  Widget _itemComponent1(int quantity, String text) {
    return InkWell(
      onTap: () {
        if(text != "Bài viết") {
          Get.to(() => Friends(user: Utils.user!,));
        }
      },
      child: Container(
        width: 80,
        height: 80,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("$quantity", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
            Text(text, style: const TextStyle(color: Colors.white, fontSize: 16),
              overflow: TextOverflow.ellipsis, maxLines: 1,)
          ],
        ),
      ),
    );
  }
  Widget _itemComponent2(String text) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 2 - 32,
      height: 36,
      child: TextButton(
        style: TextButton.styleFrom(
            backgroundColor: Colors.grey[700],
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10)
                )
            )
        ),
        onPressed: () {
          if(text == "Chỉnh sửa trang cá nhân") {
            Get.to(() => const EditingProfile());
          }
          else {

          }
        },
        child: Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 16),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ),
    );
  }

  Widget _buildButton(bool obx, Icon icon) {
    return Obx(() {
      bool isSelected = obx == isItemObx.value;
      return InkWell(
        onTap: () {
          isItemObx.value = obx;
        },
        child: Container(
            width: MediaQuery.of(context).size.width / 2 - 5,
            height: 50,
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                        color: isSelected ? Colors.white70 : Colors.black,
                        width: 1.5
                    )
                )
            ),
            child: icon
        ),
      );
    });
  }
  Widget _listItemFriend(List<String> list) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: list.length,
      itemBuilder: (context, index) {
        return _itemFriend(list[index]);
      },
    );
  }
  Widget _itemFriend(String name) {
    return Container(
      width: 170,
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
            width: 1,
          )
      ),
      child: Column(
        children: [
          Expanded(child: Container()),
          ClipOval(
            child: Image.asset(
              "images/login.jpg",
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(child: Container()),
          Text(name, style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w700), textAlign: TextAlign.center,),
          Expanded(child: Container()),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: TextButton(
              style: TextButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)
                  )
              ),
              onPressed: () {

              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: const Center(child: Text("Theo dõi", style: TextStyle(color: Colors.white, fontSize: 15),)),
              ),
            ),
          ),
          Expanded(child: Container()),
        ],
      ),
    );
  }
  void _showServiceSelectionDialog(BuildContext context) {
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
                    Icon(Icons.post_add_outlined, color: Colors.white,),
                    SizedBox(width: 20,),
                    Text("Bài viết", style: TextStyle(color: Colors.white),)
                  ],
                ),
                onTap: () {
                  Get.to(() => const CreatingPosts()); // Đóng dialog
                },
              ),
              ListTile(
                title: const Row(
                  children: [
                    Icon(Icons.video_library_outlined, color: Colors.white,),
                    SizedBox(width: 20,),
                    Text("Thướt phim", style: TextStyle(color: Colors.white),)
                  ],
                ),
                onTap: () {
                   Get.to(() => const CreatingShortCut());
                },
              ),
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
  }
  Widget _buildImages(Images image) {
    return InkWell(
      onTap: () {
        Get.to(() => AllPosts(user: Utils.user!,));
      },
      child: Image.network(
        image.image!,
        width: MediaQuery.of(context).size.width / 3,
        height: 130,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildVideos(VideoUtils videoUtils) {
    return InkWell(
      onTap: () {
        Get.to(() => AllShortCut(user: Utils.user!));
      },
      child: VideoPlayer(videoUtils.controller),
    );
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
}
