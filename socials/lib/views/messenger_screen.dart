import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:socials/api/api_service.dart';
import 'package:socials/models/chat_relation.dart';
import 'package:socials/services/chat_room_controller.dart';
import 'package:socials/utils/constant.dart';
import 'package:socials/views/chat_room.dart';
import 'package:socials/views/search_screen.dart';

import '../models/user.dart';

class MessengerScreen extends StatefulWidget {
  const MessengerScreen({super.key});

  @override
  State<MessengerScreen> createState() => _MessengerScreenState();
}

class _MessengerScreenState extends State<MessengerScreen> {
  ChatRoomController _chatRoomController = Get.put(ChatRoomController());
  @override
  void initState() {
    super.initState();
    loadData();
  }
  Future<void> loadData() async {
    await _chatRoomController.init(Utils.user!.id!);
  }
  Future<List<User>> getUserConnected() {
    return APIService.getUsersConnected(Utils.user!);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _appBar(Utils.user!.name!),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20,),
              TextFormField(
                onTap: () {
                  Get.to(() => const SearchScreen());
                },
                style: const TextStyle(fontSize: 18, color: Colors.white),
                decoration: InputDecoration(
                  prefixIcon: const Icon(FontAwesomeIcons.search, color: Colors.grey, size: 20,),
                  hintText: "Tìm kiếm",
                  hintStyle: const TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(
                        color: Colors.black,
                      )
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(
                        color: Colors.black,
                      )
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(
                        color: Colors.black,
                      )
                  ),
                  disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
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
              const SizedBox(height: 30,),
              Row(
                children: [
                  const Text("Online", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 20),),
                  Expanded(child: Container()),
                  InkWell(
                    onTap: () {

                    },
                      child: const Text("Xem tất cả", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w400, fontSize: 16),)
                  )
                ],
              ),
              const SizedBox(height: 15,),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: FutureBuilder(
                  future: getUserConnected(),
                  builder: (context, snapshot) {
                    if(snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator(),);
                    }
                    else if(snapshot.hasError) {
                      return const Center(child: CircularProgressIndicator(),);
                    }
                    else {
                      final data = snapshot.data;
                      print(data!.length);
                      return Row(
                        children: List.generate(data!.length + 1, (index) {
                          if(index == 0) {
                            return _me();
                          }
                          else {
                            return _others(data[index - 1]);
                          }
                        }),
                      );
                    }
                  },
                ),
              ),
              const SizedBox(height: 15,),
              const Text("Tin nhắn", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 20),),
              const SizedBox(height: 20,),
              Obx(
                      () => Column(
                    children: List.generate(_chatRoomController.rooms.length, (index) => _message(_chatRoomController.rooms[index])),
                  )
              )
            ],
          ),
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
          const Icon(Icons.video_call_outlined, size: 40,),
          const SizedBox(width: 30,),
          const Icon(FontAwesomeIcons.penToSquare, size: 24,)
        ],
      ),
    );
  }

  Widget _message(ChatRelation chatRelation)  {
    return InkWell(
      onTap: () {
        Get.to(() => ChatRoom(sender: Utils.user!, recipient: chatRelation.user!));
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10, top: 10),
        child: Row(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: chatRelation.user!.image == null
                      ? Image.asset('images/user.jpg', width: 50, height: 50,)
                      : Image.network(chatRelation.user!.image!,width: 50, height: 50, fit: BoxFit.fill,),
                ),
                Positioned(
                  bottom: 0,
                  right: 1,
                  child: chatRelation.user!.status == "ONLINE"
                    ? const Icon(Icons.circle, color: Colors.green, size: 12,)
                    : Container(),
                )
              ],
            ),
            const SizedBox(width: 20,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(chatRelation.user!.title!, style: const TextStyle(fontSize: 16, color: Colors.white),),
                const SizedBox(height: 5,),
                Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width / 2
                  ),
                  child: Text(
                    chatRelation.chatMessage!.senderId! == Utils.user!.id
                        ? "Bạn: ${chatRelation.chatMessage!.content!}"
                        : chatRelation.chatMessage!.content!,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _me() {
    return InkWell(
      onTap: () {
        Get.to(() => ChatRoom(sender: Utils.user!, recipient: Utils.user!));
      },
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(34),
            child: Utils.user!.image == null
                ? Image.asset("images/user.jpg", width: 68, height: 68,)
                : Image.network(Utils.user!.image!, width: 68, height: 68, fit: BoxFit.fill,),
          ),
          const SizedBox(height: 5,),
          const Text("Ghi chú", style: TextStyle(color: Colors.white),)
        ],
      ),
    );
  }

  Widget _others(User user) {
    return InkWell(
      onTap: () {
        Get.to(() => ChatRoom(sender: Utils.user!, recipient: user));
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Column(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(34),
                  child: user.image == null
                    ? Image.asset("images/user.jpg", width: 68, height: 68,)
                    : Image.network(user.image!, width: 68, height: 68, fit: BoxFit.fill,),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 14, height: 14,
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(7)
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 5,),
            Text(user.title!, style: const TextStyle(color: Colors.white),)
          ],
        ),
      ),
    );
  }

}
