import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:socials/api/api_service.dart';
import 'package:socials/services/hint_controller.dart';
import 'package:socials/utils/constant.dart';

import '../models/user.dart';
import 'others_profile.dart';

class RecommendFriends extends StatefulWidget {
  const RecommendFriends({super.key});

  @override
  State<RecommendFriends> createState() => _RecommendFriendsState();
}

class _RecommendFriendsState extends State<RecommendFriends> {
  List<HintController> friends = [];
  Future<void> getHintUser() async {
    List<User> users = await APIService.getHintUser(Utils.user!.id!);
    users.forEach((element) {
      HintController hint = HintController();
      hint.init(element);
      friends.add(hint);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _appBar("Gợi ý kết bạn"),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: getHintUser(),
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(),);
            }
            else if(snapshot.hasError) {
              return const Center(child: CircularProgressIndicator(),);
            }
            else {
              return Column(
                children: List.generate(friends.length, (index) => _itemFriend(friends[index])),
              );
            }
          },
        ),
      )
    );
  }
  Widget _itemFriend(HintController hint) {
    return InkWell(
      onTap: () {
        Get.to(() => OthersProfile(user: hint.user!));
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        child: Row(
          children: [
            const SizedBox(width: 20,),
            ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: hint.user!.image == null
                ? Image.asset("images/user.jpg", width: 50, height: 50,fit: BoxFit.fill)
                : Image.network(hint.user!.image!, width: 50, height: 50,fit: BoxFit.fill)
            ),
            const SizedBox(width: 20,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(hint.user!.name!, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),),
                Text(hint.user!.title!, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey),),
              ],
            ),
            Expanded(child: Container()),
            Obx(
                () => ElevatedButton(
                  onPressed: () {
                    hint.onChanged(Utils.user!.id!, hint.user!.id!);
                  },
                  child: hint.clicked.value ? const Text("Đã theo dõi") : const Text("Theo dõi"),
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
          Text(text, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 20),),
          Expanded(child: Container()),
        ],
      ),
    );
  }
}
