import 'dart:ui';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socials/models/chat_relation.dart';
import 'package:socials/models/user.dart';
import 'package:socials/views/test.dart';
import 'package:socials/views/video_call.dart';
import 'package:socials/views/voice_chat.dart';

class NotificationService {
  static Future<void> initializeNotification() async {
    await AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelGroupKey: 'high_importance_channel',
          channelKey: 'high_importance_channel',
          channelName: 'Basic notifications',
          channelDescription: 'Notification channel for basic tests',
          defaultColor: const Color(0xFF9D50DD),
          ledColor: Colors.white,
          importance: NotificationImportance.Max,
          channelShowBadge: true,
          onlyAlertOnce: true,
          playSound: true,
          criticalAlerts: true
        )
      ],
      channelGroups: [
        NotificationChannelGroup(
          channelGroupKey: 'high_importance_channel_group',
          channelGroupName: 'Group 1',
        )
      ],
      debug: true
    );

    await AwesomeNotifications().isNotificationAllowed().then((value) async {
      if(!value) {
        await AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });

    await AwesomeNotifications().setListeners(
      onActionReceivedMethod: onActionReceivedMethod,
      onNotificationCreatedMethod: onNotificationCreatedMethod,
      onNotificationDisplayedMethod: onNotificationDisplayedMethod,
      onDismissActionReceivedMethod: onDismissActionReceivedMethod,
    );

  }

  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    debugPrint('onActionReceivedMethod');
    final payload = await receivedAction.payload ?? {};
    if (payload["roomId"] != null) {
      if(payload['type'] == "VOICE") {
        Get.to(() => VoiceChat(userid: payload["userid"]!, callid: payload["roomId"]!, name: payload["name"]!,));
      }
      else {
        Get.to(() => VideoCall(userid: payload["userid"]!, callid: payload["roomId"]!, name: payload["name"]!,));
      }
    }
  }

  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification receivedNotification) async {
    debugPrint('onNotificationCreatedMethod');
  }

  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification) async {
    debugPrint('onNotificationDisplayedMethod');
  }

  static Future<void> onDismissActionReceivedMethod(
      ReceivedAction receivedAction) async {
    debugPrint('onDismissActionReceivedMethod');
    await AwesomeNotifications().cancel(10);
  }

  static Future<void> showNotification(ChatRelation relation) async {
    await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 10,
          channelKey: 'high_importance_channel',
          title: relation.user!.title,
          body: relation.chatMessage!.content,
          summary: "Tin nhắn",
          largeIcon: relation.user!.image ?? "https://as1.ftcdn.net/v2/jpg/03/46/83/96/1000_F_346839683_6nAPzbhpSkIpb8pmAwufkC7c5eD7wYws.jpg",
          notificationLayout: NotificationLayout.Messaging,
          roundedLargeIcon: true
        )
    );
  }

  static Future<void> showNotificationCall(User user, User recipient,String roomId, String type) async {
    String text = type == "VOICE" ? "Cuộc gọi đến" : "Cuộc gọi video";
    await AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: 10,
            channelKey: 'high_importance_channel',
            title: user.title,
            body: text,
            summary: "Tin nhắn",
            largeIcon: user.image ?? "asset/images/111.jpg",
            notificationLayout: NotificationLayout.Messaging,
            roundedLargeIcon: true,
            payload: {
              "roomId": roomId,
              "userid": recipient.id,
              "name": recipient.name,
              "type": type
            }
        ),
        actionButtons: [
          NotificationActionButton(
            key: "accept",
            label: "Accept",
            actionType: ActionType.SilentAction,
            color: Colors.blue,
          ),
          NotificationActionButton(
            key: "refuse",
            label: "Refuse",
            actionType: ActionType.DismissAction,
            color: Colors.blue,
          ),
        ],
    );
  }


}