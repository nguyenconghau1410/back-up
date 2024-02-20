import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:socials/api/api_service.dart';
import 'package:socials/views/others_profile.dart';

import '../../models/user.dart';

class LookingFor extends StatefulWidget {
  const LookingFor({super.key});

  @override
  State<LookingFor> createState() => _LookingForState();
}

class _LookingForState extends State<LookingFor> {
  final _controller = TextEditingController();
  String keyword = "";
  Future<List<User>> _getUserByNameContaining(String keyword) async {
    return APIService.getUserByNameContaining(keyword);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, top: 10, right: 20),
          child: Column(
            children: [
              TextFormField(
                controller: _controller,
                onChanged: (value) {
                  setState(() {
                    keyword = value;
                  });
                },
                style: const TextStyle(fontSize: 18, color: Colors.white),
                decoration: InputDecoration(
                  prefixIcon: const Icon(FontAwesomeIcons.search, color: Colors.grey,),
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
              const SizedBox(height: 10,),
              keyword != ""
              ? Expanded(child: SingleChildScrollView(
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
              ))
              : Container()
            ],
          ),
        ),
      ),
    );
  }

  Widget _item(User user) {
    return InkWell(
      onTap: () {
        Get.to(() => OthersProfile(user: user));
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: user.image == null
                  ? Image.asset("images/user.jpg", width: 60, height: 60, fit: BoxFit.fill,)
                  : Image.network(user.image!, width: 60, height: 60, fit: BoxFit.fill),
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
