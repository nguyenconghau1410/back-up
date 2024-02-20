import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:socials/utils/constant.dart';
import 'package:socials/views/chat_room.dart';

import '../api/api_service.dart';
import '../models/user.dart';
import 'others_profile.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  String keyword = "";
  Future<List<User>> _getUserByNameContaining(String keyword) async {
    return APIService.getUserByNameContaining(keyword);
  }

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _appBar(),
      body: keyword != ""
          ? SingleChildScrollView(
        child: FutureBuilder(
          future: _getUserByNameContaining(keyword),
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(),);
            }
            else if(snapshot.hasError) {
              return const Center(child: CircularProgressIndicator(),);
            }
            else {
              final data = snapshot.data;
              return Column(
                children: List.generate(data!.length, (index) => _item(data[index])),
              );
            }
          },
        ),
      )
          : Container()
    );
  }

  PreferredSizeWidget _appBar() {
    return AppBar(
      backgroundColor: Colors.black,
      elevation: 2,
      title: TextFormField(
        controller: _controller,
        focusNode: _focusNode,
        onChanged: (value) {
          setState(() {
            keyword = value;
          });
        },
        style: const TextStyle(fontSize: 18, color: Colors.white),
        decoration: InputDecoration(
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
          // filled: true,
        ),
      )
    );
  }
  Widget _item(User user) {
    return InkWell(
      onTap: () {
        Get.to(() => ChatRoom(sender: Utils.user!, recipient: user));
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10, left: 20),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: user.image == null
                  ? Image.asset("images/user.jpg", width: 50, height: 50, fit: BoxFit.fill,)
                  : Image.network(user.image!, width: 50, height: 50, fit: BoxFit.fill),
            ),
            const SizedBox(width: 16,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user.name!, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),),
                const SizedBox(height: 5,),
                Text(user.title!, style: const TextStyle(color: Colors.grey, fontSize: 14),)
              ],
            )
          ],
        ),
      ),
    );
  }
}
