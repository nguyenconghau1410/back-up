import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class VoiceChat extends StatefulWidget {
  String userid;
  String callid;
  String name;
  VoiceChat({super.key, required this.userid, required this.callid, required this.name});

  @override
  State<VoiceChat> createState() => _VoiceChatState();
}

class _VoiceChatState extends State<VoiceChat> {
  @override
  Widget build(BuildContext context) {
    return ZegoUIKitPrebuiltCall(
      appID: 2052144207,
      appSign: "89f764fbdbc85419153ec423b9d5cecc38a3fde9692d059e8307643b3dcdd069",
      callID: widget.callid,
      userID: widget.userid,
      userName: widget.name,
      config: ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall(),
    );
  }
}
