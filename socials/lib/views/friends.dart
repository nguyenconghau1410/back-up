
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:socials/api/api_following.dart';
import 'package:socials/services/friends_controller.dart';
import 'package:socials/utils/constant.dart';
import 'package:socials/views/others_profile.dart';
import 'package:socials/views/recommendation_friends.dart';

import '../models/friend.dart';
import '../models/user.dart';

class Friends extends StatefulWidget {
  User user;
  Friends({super.key, required this.user});

  @override
  State<Friends> createState() => _FriendsState();
}

class _FriendsState extends State<Friends> {

  final _friendController = Get.put(FriendsController());

  var isDisplay = true.obs;
  var following = 0.obs, follower = 0.obs;
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetch();
    _friendController.getData(isDisplay.value, widget.user.id!);
  }

  
  Future<void> fetch() async {
    following.value = (await APIFollowing.getListUserIsFollowed(widget.user.id!)).length;
    follower.value = (await APIFollowing.getListUserIsFollowing(widget.user.id!)).length;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _appBar(widget.user.name!),
      body: Column(
        children: [
          Row(
            children: [
              Obx(() => GestureDetector(
                onTap: () {
                  isDisplay.value = true;
                  _friendController.getData(true, Utils.user!.id!);
                },
                child: Container(
                  width: MediaQuery.of(context).size.width / 3,
                  height: 40,
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              color: isDisplay.value == true ? Colors.white : Colors.black26,
                              width: 1.0
                          )
                      )
                  ),
                  child: Center(child: Text("Người theo dõi: ${follower.value}", style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700),)),
                ),
              )),
              Obx(() => GestureDetector(
                onTap: () {
                  isDisplay.value = false;
                  _friendController.getData(false, Utils.user!.id!);
                },
                child: Container(
                  width: MediaQuery.of(context).size.width / 3,
                  height: 40,
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              color: isDisplay.value == false ? Colors.white : Colors.black26,
                              width: 1.0
                          )
                      )
                  ),
                  child: Center(child: Text("Đang theo dõi: ${following.value}", style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700),)),
                ),
              )),
              GestureDetector(
                onTap: () {
                  Get.to(() => const RecommendFriends());
                },
                child: Container(
                  width: MediaQuery.of(context).size.width / 3,
                  height: 40,
                  child: const Center(child: Text("Gợi ý kết bạn", style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700),)),
                ),
              )
            ],
          ),
          const SizedBox(height: 16,),
          Padding(
            padding: const EdgeInsets.only(left: 18),
            child: TextFormField(
              controller: _controller,
              style: const TextStyle(fontSize: 18, color: Colors.white),
              decoration: InputDecoration(
                prefixIcon: const Icon(FontAwesomeIcons.search, color: Colors.grey,),
                hintText: "Tìm kiếm",
                hintStyle: const TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors.black,
                    )
                ),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors.black,
                    )
                ),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors.black,
                    )
                ),
                disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors.black,
                    )
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 0,
                ),
                fillColor: const Color(0x77777C8A),
                filled: true,
              ),
            ),
          ),
          const SizedBox(height: 16,),
          Expanded(
            child: SingleChildScrollView(
              child: Obx(() {
                if(_friendController.friends.isEmpty) {
                  return const CircularProgressIndicator();
                }
                else {
                  List<Friend> friends = _friendController.friends.value;
                  return Column(
                    children: List.generate(friends.length, (index) => _itemFriend(index, friends[index])),
                  );
                }
              }),
            ),
          )
        ],
      ),
    );
  }


  Widget _itemFriend(int index, Friend friend) {
    return InkWell(
      onTap: () {
        Get.to(() => OthersProfile(user: friend.user!));
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        child: Row(
          children: [
            const SizedBox(width: 20,),
            ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: friend.user!.image == null
                    ? Image.asset("images/user.jpg", width: 60, height: 60,fit: BoxFit.fill)
                    : Image.network(friend.user!.image!, width: 60, height: 60, fit: BoxFit.fill,),
            ),
            const SizedBox(width: 20,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(friend.user!.name!, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),),
                Text(friend.user!.title!, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey),),
              ],
            ),
            Expanded(child: Container()),
            Obx(
                  () => ElevatedButton(
                onPressed: () {
                  _friendController.toggleFollow(index, Utils.user!.id!, friend.user!.id!);
                },
                child: friend.isFollowing.value ? const Text("Đã theo dõi") : const Text("Theo dõi"),
              ),
            ),
            const SizedBox(width: 16,),
          ],
        ),
      ),
    );
  }
  PreferredSizeWidget _appBar(String text) {
    return AppBar(
      backgroundColor: Colors.black,
      elevation: 0,
      title: Row(
        children: [
          Text(text, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 24),),
          Expanded(child: Container()),
        ],
      ),
    );
  }
}

