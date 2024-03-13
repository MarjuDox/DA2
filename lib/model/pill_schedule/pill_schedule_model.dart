// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:diabetes/screens/pill/pill_page.dart';

class PillScheduleModel {
  final String medicineName;
  final List<TimeOfDay> times;
  final DateTime startDate;
  final DateTime endDate;
  final List<DayInWeek> daysInWeek;
  final int dose;
  final MedicineUnit unit;

  PillScheduleModel({
    required this.medicineName,
    required this.times,
    required this.startDate,
    required this.endDate,
    required this.daysInWeek,
    required this.dose,
    required this.unit,
  });
}

class PillModel {
  final String medicineName;
  final TimeOfDay time;
  final MedicineUnit unit;
  final int dose;
  final String? note;
  final bool isTaken;

  PillModel({
    required this.medicineName,
    required this.time,
    required this.unit,
    required this.dose,
    this.note,
    this.isTaken = false,
  });

  PillModel copyWith({
    String? medicineName,
    TimeOfDay? time,
    MedicineUnit? unit,
    int? dose,
    String? note,
    bool? isTaken,
  }) {
    return PillModel(
      medicineName: medicineName ?? this.medicineName,
      time: time ?? this.time,
      unit: unit ?? this.unit,
      dose: dose ?? this.dose,
      note: note ?? this.note,
      isTaken: isTaken ?? this.isTaken,
    );
  }
}
