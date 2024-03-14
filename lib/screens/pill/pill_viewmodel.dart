import 'dart:async';

import 'package:diabetes/core/const/enum.dart';
import 'package:diabetes/model/pill_schedule/pill_schedule_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    await Future.delayed(const Duration(seconds: 1));
    return [
      PillModel(
          medicineName: 'Metformin',
          time: TimeOfDay.now(),
          dose: 1,
          unit: MedicineUnit.pill,
          note: PillUseNote.afterEat),
      PillModel(
          medicineName: 'Metformin',
          time: TimeOfDay.now(),
          dose: 350,
          unit: MedicineUnit.ml,
          note: PillUseNote.afterEat),
      PillModel(
          medicineName: 'Metformin',
          time: TimeOfDay.now(),
          dose: 2,
          unit: MedicineUnit.capsule,
          note: PillUseNote.afterEat),
    ];
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
