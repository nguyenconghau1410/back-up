import 'package:get/get.dart';
import 'package:socials/api/api_chat.dart';
import 'package:socials/models/chat_message.dart';
import 'package:socials/models/chat_relation.dart';

class ChatRoomController extends GetxController {
  var rooms = <ChatRelation>[].obs;
  Future<void> init(String senderId) async {
    // rooms.addAll(await APIChat.findChatRoom(senderId));
    rooms.value = await APIChat.findChatRoom(senderId);
  }

  void changePosition(ChatRelation chatRelation) {
    rooms.removeWhere((element) => element.user!.id == chatRelation.user!.id);
    rooms.insert(0, chatRelation);
  }


}