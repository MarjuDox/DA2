import 'package:flutter/material.dart';
import 'notification_model.dart';
import 'day_of_week_enum.dart';

abstract class NotificationModelAdapter<T> {
  FNotificationModel parse(T model);
}

abstract class NotificationManager {
  // ignore: non_constant_identifier_names
  final int DEFAULT_ERROR_ID = -1;
  Future<void> init();
  void askPermission();
  Future<String?> getFirebaseToken();
  void createNotification(int id,
      {required String title,
      required String body,
      required String channelKey});
  Future<bool> createSchedulednotification(int id,
      {required List<DayOfWeekEnum> dayOfWeeks,
      required TimeOfDay timeOfDay,
      required String title,
      required String body,
      required String channelKey});
  Future<List<FNotificationModel>> getListScheduledNotification();
  Future<void> cancelAllSchedulednotification({required String channelKey});
}
