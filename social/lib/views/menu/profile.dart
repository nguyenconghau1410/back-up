import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social/api/api_following.dart';
import 'package:social/api/api_service.dart';
import 'package:social/connect/connecting_websocket.dart';
import 'package:social/services/following_controller.dart';
import 'package:social/services/image_controller.dart';
import 'package:social/services/upload_file.dart';
import 'package:social/utils/constant.dart';
import 'package:social/views/creating_posts.dart';
import 'package:social/views/creating_shortcut.dart';
import 'package:social/views/story_design.dart';
import 'package:social/views/edit_profile.dart';
import 'package:social/views/friends.dart';
import 'package:social/views/login_screen.dart';
import 'package:social/views/story_galary.dart';

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
  @override
  void initState() {
    _imageController.imageUrl.value = Utils.user!.image == null
        ? "images/user.jpg" : Utils.user!.image!;
    _followingController.getData();
  }

  void uploadImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if(result != null) {
      File file = File(result.files.single.path!);
      String? imageUrl = await FileUpload.uploadImage(file, "images-profile");
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
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _appBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _component1(),
            const SizedBox(height: 25,),
            _component2(),
            const SizedBox(height: 25,),
            _component3(list),
            const SizedBox(height: 35,),
            Row(
              children: [
                _buildButton(true, const Icon(Icons.calendar_view_month_rounded, color: Colors.white,)),
                _buildButton(false, const Icon(Icons.account_box_rounded, color: Colors.white,))
              ],
            ),
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
          Text(Utils.user!.name!, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
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
              Get.offAll(const LoginScreen());
            },
            child: const Icon(Icons.logout, size: 28,),
          )
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
              Text(Utils.user!.title!, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500, fontFamily: 'Roboto'),)
            ],
          ),
        ),
        Expanded(child: Container()),
        _itemComponent1(0, "Bài viết"),
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
          Get.to(() => const Friends());
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
}
