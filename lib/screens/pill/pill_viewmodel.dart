import 'dart:async';
import 'package:diabetes/core/const/enum.dart';
import 'package:diabetes/core/extension/datetime_extension.dart';
import 'package:diabetes/core/service/firebase_database_service.dart';
import 'package:diabetes/model/pill_schedule/pill_schedule_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jiffy/jiffy.dart';

final dayInWeelSelected =
    AutoDisposeNotifierProvider<DayInWeekSelectNotifier, Map<DayInWeek, bool>>(
        DayInWeekSelectNotifier.new);

class DayInWeekSelectNotifier
    extends AutoDisposeNotifier<Map<DayInWeek, bool>> {
  @override
  Map<DayInWeek, bool> build() {
    return Map<DayInWeek, bool>.fromIterable(
      DayInWeek.values,
      value: (_) => true,
    );
  }

  void toggle(DayInWeek dayInWeek) {
    var newValues = Map<DayInWeek, bool>.from(state);
    var currentValue = newValues[dayInWeek] ?? false;
    newValues[dayInWeek] = !currentValue;
    state = newValues;
  }
}

final scheduleBeginProvider =
    AutoDisposeNotifierProvider<ScheduleBeginNotifier, DateTime?>(
        ScheduleBeginNotifier.new);

final scheduleEndProvider =
    AutoDisposeNotifierProvider<ScheduleBeginNotifier, DateTime?>(
        ScheduleBeginNotifier.new);

class ScheduleBeginNotifier extends AutoDisposeNotifier<DateTime?> {
  @override
  DateTime? build() {
    return null;
  }

  void changeDate(DateTime time) {
    state = time;
  }
}

final pillScheduleProvider =
    AutoDisposeAsyncNotifierProvider<PillScheduleNotifier, List<PillModel>>(
        PillScheduleNotifier.new);

class PillScheduleNotifier extends AutoDisposeAsyncNotifier<List<PillModel>> {
  @override
  FutureOr<List<PillModel>> build() async {
    final date = ref.watch(currentDateSelectedProvider);
    final schedules = await FirebaseDatabaseService.getUserSchedule();
    List<PillModel> result = [];
    for (var schedule
        in schedules.where((element) => element.havePillAt(date))) {
      for (var time in schedule.times) {
        result.add(PillModel(
          schedule: schedule,
          note: schedule.note,
          unit: schedule.unit,
          isTaken: schedule.takenPill[date.dateOnly]?.contains(time) ?? false,
          time: time,
          isExpired: date.isBefore(DateTime.now().dateOnly),
          dose: schedule.dose,
          medicineName: schedule.medicineName,
        ));
      }
    }
    result.sort((a, b) =>
        a.time.hour * 60 + a.time.minute - b.time.hour * 60 - b.time.minute);
    return result;
  }
}

final timesProvider =
    AutoDisposeNotifierProvider<TimeListNotifier, List<TimeOfDay>>(
        TimeListNotifier.new);

class TimeListNotifier extends AutoDisposeNotifier<List<TimeOfDay>> {
  @override
  List<TimeOfDay> build() {
    return [
      const TimeOfDay(hour: 8, minute: 0),
      const TimeOfDay(hour: 13, minute: 0),
      const TimeOfDay(hour: 18, minute: 0),
    ];
  }

  void removeTime(TimeOfDay time) {
    if (state.contains(time) == false) {
      return;
    }
    var newState = state.where((element) => element != time).toList();
    state = newState;
  }

  void addTime(TimeOfDay time) {
    if (state.contains(time)) {
      return;
    }
    var newState = [...state, time];
    newState.sort((a, b) => a.hour * 60 + a.minute - b.hour * 60 - b.minute);
    state = newState;
  }

  void changeTime(TimeOfDay from, TimeOfDay to) {
    removeTime(from);
    addTime(to);
  }
}

final doseProvider =
    AutoDisposeNotifierProvider<DoseNotifier, double>(DoseNotifier.new);

class DoseNotifier extends AutoDisposeNotifier<double> {
  @override
  double build() {
    final currentUnit = ref.watch(medicineUnitProvider);
    return currentUnit.dose.firstOrNull ?? 1;
  }

  void onChange(double newValue) {
    state = newValue;
  }
}

final medicineUnitProvider =
    AutoDisposeNotifierProvider<MedicineUnitNotifier, MedicineUnit>(
        MedicineUnitNotifier.new);

class MedicineUnitNotifier extends AutoDisposeNotifier<MedicineUnit> {
  @override
  MedicineUnit build() {
    return MedicineUnit.capsule;
  }

  void onChange(MedicineUnit newValue) {
    state = newValue;
  }
}

final medicineUseProvider =
    AutoDisposeNotifierProvider<MedicineUseNotifier, PillUseNote>(
        MedicineUseNotifier.new);

class MedicineUseNotifier extends AutoDisposeNotifier<PillUseNote> {
  @override
  PillUseNote build() {
    return PillUseNote.none;
  }

  void onChange(PillUseNote newValue) {
    state = newValue;
  }
}

final scheduleWeekProvider =
    AutoDisposeNotifierProvider<ScheduleWeekNotifier, List<DateTime>>(
        ScheduleWeekNotifier.new);

class ScheduleWeekNotifier extends AutoDisposeNotifier<List<DateTime>> {
  @override
  List<DateTime> build() {
    final date = getWeekDays();
    return date;
  }
}

final currentDateSelectedProvider =
    AutoDisposeNotifierProvider<CurrentDateSelectedNotifier, DateTime>(
        CurrentDateSelectedNotifier.new);

class CurrentDateSelectedNotifier extends AutoDisposeNotifier<DateTime> {
  @override
  DateTime build() {
    return DateTime.now().dateOnly;
  }

  void changeDate(DateTime date) {
    state = date;
  }
}

List<DateTime> getWeekDays() {
  return List.generate(7, (index) {
    return Jiffy.now()
        .startOf(Unit.week)
        .add(days: index + 1)
        .dateTime
        .dateOnly;
  });
}
