import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ChatRoom extends StatefulWidget {
  const ChatRoom({super.key});

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  final _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black26,
      appBar: _appBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
              child: const SingleChildScrollView(

              )
          ),
          _messageTool(),
          const SizedBox(height: 10,)
        ],
      ),
    );
  }
  PreferredSizeWidget _appBar() {
    return AppBar(
      backgroundColor: Colors.black,
      title: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset("images/111.jpg", width: 40, height: 40,),
          ),
          const SizedBox(width: 10,),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Ngọc Quỳnh", style: TextStyle(color: Colors.white, fontSize: 16),),
              Text("sennnnn", style: TextStyle(color: Colors.grey, fontSize: 14),)
            ],
          ),
          Expanded(child: Container()),
          InkWell(
              onTap: () {

              },
              child: const Icon(Icons.phone, size: 36,)
          ),
          const SizedBox(width: 20,),
          InkWell(
              onTap: () {

              },
              child: const Icon(Icons.videocam_outlined, size: 36,)
          ),
          const SizedBox(width: 5,)
        ],
      ),
    );
  }
  Widget _messageTool() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: TextFormField(
        controller: _controller,
        style: const TextStyle(fontSize: 18, color: Colors.white),
        decoration: InputDecoration(
          prefixIcon: InkWell(
            onTap: () {

            },
            child: const Stack(
              alignment: AlignmentDirectional.center,
              children: [
                Icon(Icons.circle, color: Colors.blue, size: 50,),
                Icon(Icons.camera_alt, color: Colors.white,)
              ],
            ),
          ),
          suffixIcon: InkWell(
            onTap: () {
              _controller.clear();
            },
            child: const Padding(
              padding: EdgeInsets.only(right: 10),
              child: Icon(Icons.send, color: Colors.blue, size: 30,),
            ),
          ),
          hintText: "Nhắn tin",
          hintStyle: const TextStyle(color: Colors.grey),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(
                color: Colors.black,
              )
          ),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(
                color: Colors.black,
              )
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(
                color: Colors.black,
              )
          ),
          disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(
                color: Colors.black,
              )
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 16,
          ),
          fillColor: const Color(0x77777C8A),
          filled: true,
        ),
      ),
    );
  }
}
