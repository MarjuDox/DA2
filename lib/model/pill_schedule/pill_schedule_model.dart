// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:diabetes/core/const/enum.dart';
import 'package:flutter/material.dart';

class PillScheduleModel {
  final String medicineName;
  final List<TimeOfDay> times;
  final DateTime startDate;
  final PillUseNote note;
  final DateTime endDate;
  final List<DayInWeek> daysInWeek;
  final double dose;
  final MedicineUnit unit;

  PillScheduleModel({
    required this.medicineName,
    required this.times,
    required this.startDate,
    required this.endDate,
    required this.daysInWeek,
    required this.dose,
    required this.unit,
    required this.note,
  });
}

class PillModel {
  final String medicineName;
  final TimeOfDay time;
  final MedicineUnit unit;
  final double dose;
    final PillUseNote note;
  final bool isTaken;

  PillModel({
    required this.medicineName,
    required this.time,
    required this.unit,
    required this.dose,
    required this.note,
    this.isTaken = false,
  });

  PillModel copyWith({
    String? medicineName,
    TimeOfDay? time,
    MedicineUnit? unit,
    double? dose,
    PillUseNote? note,
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
