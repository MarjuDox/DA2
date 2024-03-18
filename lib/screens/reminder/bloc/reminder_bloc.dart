import 'dart:async';

// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:diabetes/core/service/notification/day_of_week_enum.dart';
import 'package:diabetes/core/service/notification/notification_constants.dart';
import 'package:diabetes/core/service/notification/notification_manager.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
// ignore: depend_on_referenced_packages

part 'reminder_event.dart';

part 'reminder_state.dart';

class ReminderBloc extends Bloc<ReminderEvent, ReminderState> {
  ReminderBloc() : super(ReminderInitial());

  int? selectedRepeatDayIndex;
  late DateTime reminderTime;
  int? dayTime;

  @override
  Stream<ReminderState> mapEventToState(
    ReminderEvent event,
  ) async* {
    if (event is RepeatDaySelectedEvent) {
      selectedRepeatDayIndex = event.index;
      dayTime = event.dayTime;
      yield RepeatDaySelectedState(index: selectedRepeatDayIndex);
    } else if (event is ReminderNotificationTimeEvent) {
      reminderTime = event.dateTime;
      yield ReminderNotificationState();
    } else if (event is OnSaveTappedEvent) {
      _scheduleAtParticularTimeAndDate(reminderTime, dayTime);
      yield OnSaveTappedState();
    }
  }

  final _notificationManager = GetIt.I<NotificationManager>();

  List<DayOfWeekEnum> dateOptionToListDayOfWeek(int? optionDate) {
    switch (dayTime) {
      case 0:
        return [
          DayOfWeekEnum.monday,
          DayOfWeekEnum.tuesday,
          DayOfWeekEnum.wednesday,
          DayOfWeekEnum.thursday,
          DayOfWeekEnum.friday,
          DayOfWeekEnum.saturday,
          DayOfWeekEnum.sunday,
        ];
      case 1:
        return [
          DayOfWeekEnum.monday,
          DayOfWeekEnum.tuesday,
          DayOfWeekEnum.wednesday,
          DayOfWeekEnum.thursday,
          DayOfWeekEnum.friday,
        ];
      case 2:
        return [
          DayOfWeekEnum.saturday,
          DayOfWeekEnum.sunday,
        ];
      case 3:
        return [DayOfWeekEnum.monday];
      case 4:
        return [DayOfWeekEnum.tuesday];
      case 5:
        return [DayOfWeekEnum.wednesday];
      case 6:
        return [DayOfWeekEnum.thursday];
      case 7:
        return [DayOfWeekEnum.friday];
      case 8:
        return [DayOfWeekEnum.saturday];
      case 9:
        return [DayOfWeekEnum.sunday];
      default:
        return [];
    }
  }

  void _scheduleAtParticularTimeAndDate(DateTime dateTime, int? dateOption) {
    _notificationManager.createSchedulednotification(1,
        title: 'REMINDER-TITLE',
        body: 'REMINDER-BODY',
        channelKey: FNotificationChannelEnum.reminder.toKey(),
        dayOfWeeks: dateOptionToListDayOfWeek(dateOption),
        timeOfDay: TimeOfDay(hour: dateTime.hour, minute: dateTime.minute));
  }
}
