// import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

enum FNotificationChannelEnum {
  general,
  reminder;

  String toKey() {
    switch (this) {
      case reminder:
        return 'REMINDER';
      case general:
        return 'GENERAL';
    }
  }
}

class NotificationConstants {
  static const logo = 'resource://drawable/res_logo';
  static final channels = [
    NotificationChannel(
      channelKey: FNotificationChannelEnum.reminder.toKey(),
      channelName: 'Reminder',
      channelDescription: 'Notification Reminder channel',
      defaultColor: Colors.grey,
      ledColor: Colors.white,
    ),
    NotificationChannel(
      channelKey: FNotificationChannelEnum.general.toKey(),
      channelName: 'General',
      channelDescription: 'Notification General channel',
      defaultColor: Colors.grey,
      ledColor: Colors.white,
    ),
  ];
  // static final groupChannels = [
  //   NotificationChannelGroup(
  //       channelGroupKey: 'basic_channel_group', channelGroupName: 'Basic group')
  // ];
}
