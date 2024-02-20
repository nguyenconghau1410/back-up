import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socials/api/api_following.dart';
import 'package:socials/services/following_controller.dart';
import 'package:socials/utils/constant.dart';
import 'package:socials/views/others_friends.dart';

import '../api/api_images.dart';
import '../api/api_posts.dart';
import '../models/images.dart';
import '../models/story.dart';
import '../models/user.dart';
import 'all_posts.dart';
import 'all_stories.dart';
import 'display_story.dart';

class OthersProfile extends StatefulWidget {
  User user;
  OthersProfile({super.key, required this.user});

  @override
  State<OthersProfile> createState() => _OthersProfileState();
}

class _OthersProfileState extends State<OthersProfile> {
  var isItemObx = true.obs;
  final FollowingController _followingController = FollowingController();
  var isFriend = false.obs;
  @override
  void initState() {
    _loadData();
  }

  Future<void> _loadData() async {
    await _followingController.getData(widget.user.id!);
    for(int i = 0; i < _followingController.beingFollowed.value.length; i++) {
      if(_followingController.beingFollowed.value[i].userId == Utils.user!.id!) {
        isFriend.value = true;
      }
    }
  }
  Future<List<Story>> _getStory() async {
    return APIPosts.getStoryByUserid(widget.user.id!);
  }
  Future<List<Images>> _getImages() async {
    return APIImages.getByUserid(widget.user.id!);
  }
  Future<int> _getCountPost() async {
    return await APIPosts.countByUserid(widget.user.id!);
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
            const SizedBox(height: 60,),
            Row(
              children: [
                const SizedBox(width: 16,),
                const Text("Stories", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500,),),
                Expanded(child: Container()),
                InkWell(
                  onTap: () {
                    Get.to(() => AllStory(user: widget.user,));
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
                              Get.to(() => DisplayStory(story: data[index], user: widget.user,));
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
            Row(
              children: [
                _buildButton(true, const Icon(Icons.calendar_view_month_rounded, color: Colors.white,)),
                _buildButton(false, const Icon(Icons.account_box_rounded, color: Colors.white,))
              ],
            ),
            const SizedBox(height: 10,),
            Obx(() {
              bool isDisplay = isItemObx.value;
              if(isDisplay) {
                return FutureBuilder(
                  future: _getImages(),
                  builder: (context, snapshot) {
                    if(snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
                    else if(snapshot.hasError) {
                      return const CircularProgressIndicator();
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
                return Container();
              }
            })
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
          Text(widget.user.name!, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
          Expanded(child: Container()),
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

                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: widget.user.image == null
                    ? Image.asset("images/user.jpg", width: 80, height: 80, fit: BoxFit.fill,)
                    : Image.network(widget.user.image!, width: 80, height: 80, fit: BoxFit.fill),
                ),
              ),
              const SizedBox(height: 5,),
              Text(widget.user.title!, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500, fontFamily: 'Roboto'),)
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
        _itemComponent2(""),
        Expanded(child: Container()),
        _itemComponent2("Nhắn tin"),
        Expanded(child: Container()),
      ],
    );
  }

  Widget _itemComponent1(int quantity, String text) {
    return InkWell(
      onTap: () {
        if(text != "Bài viết") {
          Get.to(() => OtherFriends(user: widget.user));
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
      width: MediaQuery.of(context).size.width / 2 - 20,
      height: 36,
      child: text != ""
        ? TextButton(
            style: TextButton.styleFrom(
                backgroundColor: Colors.grey[700],
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                        bottomRight: Radius.circular(10)
                    )
                )
            ),
            onPressed: () {

            },
            child: Text(
              text,
              style: const TextStyle(color: Colors.white, fontSize: 16),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          )
        : Obx(() => TextButton(
            style: TextButton.styleFrom(
                backgroundColor: isFriend.value ? Colors.grey[700] : Colors.blue,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                        bottomRight: Radius.circular(10)
                    )
                )
            ),
            onPressed: () {
              if(isFriend.value) {
                APIFollowing.unFollow(Utils.user!.id!, widget.user.id!);
              }
              else {
                APIFollowing.addFriend(Utils.user!.id!, widget.user.id!);
              }
              isFriend.value = !isFriend.value;
            },
            child: Text(
              isFriend.value ? "Đang theo dõi" : "Theo dõi",
              style: const TextStyle(color: Colors.white, fontSize: 16),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ))
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
  Widget _buildImages(Images image) {
    return InkWell(
      onTap: () {
        Get.to(() => AllPosts(user: widget.user,));
      },
      child: Image.network(
        image.image!,
        width: MediaQuery.of(context).size.width / 3,
        height: 130,
        fit: BoxFit.cover,
      ),
    );
  }
}
