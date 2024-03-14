// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:diabetes/core/const/enum.dart';
import 'package:diabetes/core/extension/timeofday_extension.dart';

class PillScheduleModel {
  final String uid;
  final String userId;
  final String medicineName;
  final List<TimeOfDay> times;
  final DateTime startDate;
  final PillUseNote note;
  final DateTime endDate;
  final List<DayInWeek> daysInWeek;
  final double dose;
  final MedicineUnit unit;
  final Map<DateTime, List<TimeOfDay>> takenPill;

  bool get isActive {
    if (DateTime.now().isAfter(endDate)) {
      return false;
    }
    if (DateTime.now().isBefore(startDate)) {
      return false;
    }
    return true;
  }

  bool get havePillToday {
    if (!isActive) {
      return false;
    }
    final toDay = DateTime.now();
    return daysInWeek.contains(DayInWeek.fromDateTime(toDay));
  }

  PillScheduleModel({
    required this.uid,
    required this.userId,
    required this.medicineName,
    required this.times,
    required this.startDate,
    required this.endDate,
    required this.daysInWeek,
    required this.dose,
    required this.unit,
    required this.note,
    this.takenPill = const {},
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'userId': userId,
      'medicineName': medicineName,
      'times': times.map((x) => x.toJson).toList(),
      'startDate': startDate.toIso8601String(),
      'note': note.toJson,
      'endDate': endDate.toIso8601String(),
      'daysInWeek': daysInWeek.map((x) => x.toJson).toList(),
      'dose': dose,
      'unit': unit.toJson,
      'takenPill': takenPill.isEmpty
          ? {}
          : takenPill.map((key, value) => MapEntry(
              key.toIso8601String(), value.map((e) => e.toJson).toList()))
    };
  }

  factory PillScheduleModel.fromMap(Map<String, dynamic> map) {
    return PillScheduleModel(
      uid: map['uid'] as String,
      userId: map['userId'] as String,
      medicineName: map['medicineName'] as String,
      times: List<TimeOfDay>.from(
        (map['times'] as List<dynamic>).map<TimeOfDay>(
          (x) => TimeOfDayX.fromMap(x),
        ),
      ),
      startDate: DateTime.parse(map['startDate']),
      note: PillUseNote.fromJson(map['note']),
      endDate: DateTime.parse(map['endDate']),
      daysInWeek: List<DayInWeek>.from(
        (map['daysInWeek'] as List<dynamic>).map<DayInWeek>(
          (x) => DayInWeek.fromJson(x),
        ),
      ),
      dose: map['dose'] as double,
      unit: MedicineUnit.fromJson(map['unit']),
      takenPill: map['takenPill'] == null
          ? {}
          : (map['takenPill'] as Map<String, dynamic>)
              .map<DateTime, List<TimeOfDay>>(
              (key, value) => MapEntry(
                DateTime.parse(key),
                List<TimeOfDay>.from(
                  (value as List<dynamic>).map<TimeOfDay>(
                    (x) => TimeOfDayX.fromMap(x),
                  ),
                ),
              ),
            ),
    );
  }

  String toJson() => json.encode(toMap());

  factory PillScheduleModel.fromJson(String source) =>
      PillScheduleModel.fromMap(json.decode(source) as Map<String, dynamic>);

  PillScheduleModel copyWith({
    String? uid,
    String? userId,
    String? medicineName,
    List<TimeOfDay>? times,
    DateTime? startDate,
    PillUseNote? note,
    DateTime? endDate,
    List<DayInWeek>? daysInWeek,
    double? dose,
    MedicineUnit? unit,
    Map<DateTime, List<TimeOfDay>>? takenPill,
  }) {
    return PillScheduleModel(
      uid: uid ?? this.uid,
      userId: userId ?? this.userId,
      medicineName: medicineName ?? this.medicineName,
      times: times ?? this.times,
      startDate: startDate ?? this.startDate,
      note: note ?? this.note,
      endDate: endDate ?? this.endDate,
      daysInWeek: daysInWeek ?? this.daysInWeek,
      dose: dose ?? this.dose,
      unit: unit ?? this.unit,
      takenPill: takenPill ?? this.takenPill,
    );
  }
}

class PillModel {
  final String medicineName;
  final TimeOfDay time;
  final MedicineUnit unit;
  final double dose;
  final PillUseNote note;
  final bool isTaken;
  final PillScheduleModel schedule;

  PillModel({
    required this.medicineName,
    required this.time,
    required this.unit,
    required this.dose,
    required this.note,
    required this.schedule,
    this.isTaken = false,
  });

  PillModel copyWith({
    String? medicineName,
    TimeOfDay? time,
    MedicineUnit? unit,
    double? dose,
    PillUseNote? note,
    bool? isTaken,
    PillScheduleModel? schedule,
  }) {
    return PillModel(
      schedule: schedule ?? this.schedule,
      medicineName: medicineName ?? this.medicineName,
      time: time ?? this.time,
      unit: unit ?? this.unit,
      dose: dose ?? this.dose,
      note: note ?? this.note,
      isTaken: isTaken ?? this.isTaken,
    );
  }
}
