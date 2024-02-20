import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socials/connect/connecting_websocket.dart';
import 'package:socials/models/chat_message.dart';
import 'package:socials/models/chat_relation.dart';
import 'package:socials/models/chat_rooms.dart';
import 'package:socials/services/chat_controller.dart';
import 'package:socials/services/chat_room_controller.dart';
import 'package:socials/utils/constant.dart';

import '../models/user.dart';

class ChatRoom extends StatefulWidget {
  User sender;
  User recipient;
  ChatRoom({super.key, required this.sender, required this.recipient});

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  final _controller = TextEditingController();
  final _chatRoom = Get.put(ChatRoomController());
  @override
  void initState() {
    super.initState();
    _loadData();
  }
  Future<void> _loadData() async {
    await ChatController.init(widget.sender!.id!, widget.recipient!.id!);
  }
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
              child: SingleChildScrollView(
                reverse: true,
                child: FutureBuilder(
                  future: _loadData(),
                  builder: (context, snapshot) {
                    if(snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator(),);
                    }
                    else if(snapshot.hasError) {
                      return const Center(child: CircularProgressIndicator(),);
                    }
                    else {
                      final data = ChatController.messages;
                      return Obx(
                          () => Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: List.generate(data.length, (index) => _buildMessageItem(data[index])),
                          )
                      );
                    }
                  },
                ),
              )
          ),
          const SizedBox(height: 20,),
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
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: widget.recipient.image == null
                    ? Image.asset("images/user.jpg", width: 36, height: 36,)
                    : Image.network(widget.recipient.image!, width: 36, height: 36, fit: BoxFit.fill,),
              ),
              Positioned(
                bottom: 0,
                right: -1,
                child: widget.recipient.status == "ONLINE"
                  ? const Icon(Icons.circle, color: Colors.green, size: 12,)
                  : Container(),
              )
            ],
          ),
          const SizedBox(width: 10,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.recipient.name!, style: const TextStyle(color: Colors.white, fontSize: 16),),
              widget.recipient.status == "ONLINE"
              ? const Text("Active", style: TextStyle(color: Colors.grey, fontSize: 14),)
              : const Text("Inactive", style: TextStyle(color: Colors.grey, fontSize: 14),)
            ],
          ),
          Expanded(child: Container()),
          InkWell(
              onTap: () {

              },
              child: const Icon(Icons.phone, size: 24,)
          ),
          const SizedBox(width: 20,),
          InkWell(
              onTap: () {

              },
              child: const Icon(Icons.videocam_outlined, size: 32,)
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
              ChatMessage message = ChatMessage(null, null, widget.sender.id, widget.recipient.id,
                  _controller.text.trim(), null, DateTime.now().toString());
              ConnectWebSocket.chatMessage(message);
              ChatController.addMessage(message);
              ChatRelation chatRelation = ChatRelation(widget.recipient, null, message);
              _chatRoom.changePosition(chatRelation);
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
  Widget _buildMessageItem(ChatMessage chatMessage) {
    var aligment = (chatMessage.senderId == widget.sender.id) ? Alignment.centerRight : Alignment.centerLeft;
    return Container(
      alignment: aligment,
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Column(
          crossAxisAlignment:
          (chatMessage.senderId == widget.sender.id) ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          mainAxisAlignment:
          (chatMessage.senderId == widget.sender.id) ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            (chatMessage.senderId == widget.sender.id)
            ? Container(
                padding: const EdgeInsets.only(top: 8, bottom: 8, left: 10, right: 10),
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width / 1.5
                ),
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10)
                  )
                ),
                child: Text(chatMessage.content!, style: const TextStyle(color: Colors.white, fontSize: 15),),
            )
            : Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: widget.recipient.image == null
                    ? Image.asset("images/user.jpg", width: 30, height: 30, fit: BoxFit.fill,)
                    : Image.network(widget.recipient.image!, width: 30, height: 30, fit: BoxFit.fill),
                ),
                const SizedBox(width: 10,),
                Container(
                  padding: const EdgeInsets.only(top: 8, bottom: 8, left: 10, right: 10),
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width / 1.5
                  ),
                  decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(20),
                          bottomRight: Radius.circular(20)
                      )
                  ),
                  child: Text(chatMessage.content!, style: const TextStyle(color: Colors.white, fontSize: 15),),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
  @override
  void dispose() {
    ChatController.destroy();
    super.dispose();
  }
}
