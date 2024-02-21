import 'dart:ui';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:socials/models/post_relation.dart';
import 'package:socials/services/chat_controller.dart';
import 'package:socials/services/post_controller.dart';

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

  }

  // static Future<void> showNotification() async {
  //   if(!ChatController.isCreated) {
  //     await AwesomeNotifications().createNotification(
  //       content: NotificationContent(
  //         id: 10,
  //         channelKey: 'high_importance_channel',
  //         title: 'Tin nhắn',
  //         body: 'Cái con cặt',
  //       )
  //     );
  //   }
  // }
  static Future<void> showNotification({
    required final String title,
    required final String body,
    final String? summary,
    final Map<String, String>? payload,
    final ActionType actionType = ActionType.Default,
    final NotificationLayout notificationLayout = NotificationLayout.Default,
    final NotificationCategory? category,
    final String? bigPicture,
    final List<NotificationActionButton>? actionButtons,
    final bool scheduled = false,
    final String? icon,
    final int? interval,
  }) async {
    assert(!scheduled || (scheduled && interval != null));

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: -1,
        channelKey: 'high_importance_channel',
        title: title,
        body: body,
        actionType: actionType,
        notificationLayout: notificationLayout,
        summary: summary,
        category: category,
        payload: payload,
        bigPicture: bigPicture,
      ),
      actionButtons: actionButtons,
      schedule: scheduled
          ? NotificationInterval(
        interval: interval,
        timeZone:
        await AwesomeNotifications().getLocalTimeZoneIdentifier(),
        preciseAlarm: true,
      )
          : null,
    );
  }

}