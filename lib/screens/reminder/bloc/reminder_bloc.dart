import 'package:bloc/bloc.dart';
// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';
// ignore: depend_on_referenced_packages
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

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
  
  Future _scheduleAtParticularTimeAndDate(
    DateTime dateTime, int? dayTime) async {
  final flutterNotificationsPlugin = FlutterLocalNotificationsPlugin();
  const androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your other channel id',
      'your other channel name',);//'your other channel description');
  //final iOSPlatformChannelSpecifics = IOSNotificationDetails();
  NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics);
      //iOS: iOSPlatformChannelSpecifics);

  List days = _createNotificationDayOfTheWeek(dayTime);
  await flutterNotificationsPlugin.zonedSchedule(
    1,
    "Fitness",
    "Hey, it's time to start your exercises!",
    _scheduleWeekly(dateTime, days: days),
    platformChannelSpecifics,
    uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
    androidAllowWhileIdle: true,
    matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
  );
}

  tz.TZDateTime _scheduleDaily(DateTime dateTime) {
    final now = tz.TZDateTime.now(tz.local);
    var timezoneOffset = DateTime.now().timeZoneOffset;
    final scheduleDate = tz.TZDateTime.utc(now.year, now.month, now.day)
        .add(Duration(hours: dateTime.hour, minutes: dateTime.minute))
        .subtract(Duration(hours: timezoneOffset.inHours));

    return scheduleDate.isBefore(now)
        ? scheduleDate.add(Duration(days: 1))
        : scheduleDate;
  }

  tz.TZDateTime _scheduleWeekly(DateTime dateTime, {required List? days}) {
    tz.TZDateTime scheduleDate = _scheduleDaily(dateTime);

    for (final int day in days ?? []) {
      scheduleDate = scheduleDate.add(Duration(days: day));
    }

    return scheduleDate;
  }
  
  List _createNotificationDayOfTheWeek(int? dayTime) {
    switch (dayTime) {
      case 0:
        return [
          DateTime.monday,
          DateTime.tuesday,
          DateTime.wednesday,
          DateTime.thursday,
          DateTime.friday,
          DateTime.saturday,
          DateTime.sunday
        ];
      case 1:
        return [
          DateTime.monday,
          DateTime.tuesday,
          DateTime.wednesday,
          DateTime.thursday,
          DateTime.friday
        ];
      case 2:
        return [DateTime.saturday, DateTime.sunday];
      case 3:
        return [DateTime.monday];
      case 4:
        return [DateTime.tuesday];
      case 5:
        return [DateTime.wednesday];
      case 6:
        return [DateTime.thursday];
      case 7:
        return [DateTime.friday];
      case 8:
        return [DateTime.saturday];
      case 9:
        return [DateTime.sunday];
      default:
        return [];
    }
  }
}