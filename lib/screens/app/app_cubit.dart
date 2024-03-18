import 'package:bloc/bloc.dart';
import 'package:diabetes/core/service/firebase_database_service.dart';
import 'package:diabetes/core/service/notification/notification_constants.dart';
import 'package:diabetes/core/service/notification/notification_manager.dart';
import 'package:diabetes/model/pill_schedule/pill_schedule_model.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppState.initial()) {
    getAllSchedulesAndRenewScheduleNotifications();
  }

  final _notificationManager = GetIt.I<NotificationManager>();

  // TODO: Check is equals all schedule notifications
  Future<bool> isEqualAllScheduleNotifications() async {
    throw 'Not found isEqualAllScheduleNotifications';
  }

  Future<void> getAllSchedulesAndRenewScheduleNotifications() async {
    final pillSchedules = await FirebaseDatabaseService.getUserSchedule();
    await _cancelAllSchedulesAndAddSchedules(pillSchedules);
  }

  Future<void> _cancelAllSchedulesAndAddSchedules(
      List<PillScheduleModel> pillSchedules) async {
    await _notificationManager.cancelAllSchedulednotification(
        channelKey: FNotificationChannelEnum.prescription.toKey());
    for (var pillSchedule in pillSchedules) {
      for (var time in pillSchedule.times) {
        await _notificationManager.createSchedulednotification(
            0, // notificationId
            dayOfWeeks:
                pillSchedule.daysInWeek.map((e) => e.toDayOfWeek()).toList(),
            timeOfDay: time,
            title: pillSchedule.medicineName,
            body: pillSchedule.note.label,
            channelKey: FNotificationChannelEnum.prescription.toKey());
      }
    }
  }
}
