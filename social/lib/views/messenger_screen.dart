import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:social/views/chat_room.dart';

class MessengerScreen extends StatefulWidget {
  const MessengerScreen({super.key});

  @override
  State<MessengerScreen> createState() => _MessengerScreenState();
}

class _MessengerScreenState extends State<MessengerScreen> {
  final _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _appBar("nvh1410"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20,),
              TextFormField(
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
              const SizedBox(height: 30,),
              Row(
                children: [
                  const Text("Online", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 20),),
                  Expanded(child: Container()),
                  InkWell(
                    onTap: () {

                    },
                      child: const Text("Xem tất cả", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w400, fontSize: 18),)
                  )
                ],
              ),
              const SizedBox(height: 15,),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(6, (index) {
                    if(index == 0) {
                      return _me("");
                    }
                    else {
                      return _others("");
                    }
                  }),
                ),
              ),
              const SizedBox(height: 15,),
              const Text("Tin nhắn", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 20),),
              const SizedBox(height: 20,),
              Column(
                children: List.generate(2, (index) => _message("user.jpg", "user 1", "......")),
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
          Text(text, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 24),),
          const Icon(Icons.keyboard_arrow_down_sharp),
          Expanded(child: Container()),
          const Icon(Icons.video_call_outlined, size: 40,),
          const SizedBox(width: 30,),
          const Icon(FontAwesomeIcons.penToSquare, size: 30,)
        ],
      ),
    );
  }

  Widget _message(String src, String name, String message)  {
    return InkWell(
      onTap: () {
        Get.to(const ChatRoom());
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10, top: 10),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Image.asset('images/$src', width: 60, height: 60,),
            ),
            const SizedBox(width: 20,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontSize: 18, color: Colors.white),),
                Text(message, style: const TextStyle(fontSize: 16, color: Colors.grey),)
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _me(String path) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(34),
          child: Image.asset("images/user.jpg", width: 68, height: 68,),
        ),
        const SizedBox(height: 5,),
        const Text("Ghi chú", style: TextStyle(color: Colors.white),)
      ],
    );
  }

  Widget _others(String path) {
    return InkWell(
      onTap: () {

      },
      child: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Column(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(34),
                  child: Image.asset("images/user.jpg", width: 68, height: 68,),
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
            const Text(".....", style: TextStyle(color: Colors.white),)
          ],
        ),
      ),
    );
  }
}
