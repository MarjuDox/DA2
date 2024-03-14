import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

enum DayInWeek {
  mon,
  tue,
  wed,
  thu,
  fri,
  sat,
  sun;

  String get label {
    switch (this) {
      case DayInWeek.mon:
        return 'Mon';
      case DayInWeek.tue:
        return 'Tue';
      case DayInWeek.wed:
        return 'Wed';
      case DayInWeek.thu:
        return 'Thu';
      case DayInWeek.fri:
        return 'Fri';
      case DayInWeek.sat:
        return 'Sat';
      case DayInWeek.sun:
        return 'Sun';
    }
  }

  static DayInWeek fromDateTime(DateTime dateTime) {
    switch (dateTime.weekday) {
      case 1:
        return DayInWeek.mon;
      case 2:
        return DayInWeek.tue;
      case 3:
        return DayInWeek.wed;
      case 4:
        return DayInWeek.thu;
      case 5:
        return DayInWeek.fri;
      case 6:
        return DayInWeek.sat;
      case 7:
        return DayInWeek.sun;
    }
    throw Exception('Unknown DayInWeek: ${dateTime.weekday}');
  }

  String get toJson {
    return name;
  }

  static DayInWeek fromJson(String json) {
    switch (json) {
      case 'mon':
        return DayInWeek.mon;
      case 'tue':
        return DayInWeek.tue;
      case 'wed':
        return DayInWeek.wed;
      case 'thu':
        return DayInWeek.thu;
      case 'fri':
        return DayInWeek.fri;
      case 'sat':
        return DayInWeek.sat;
      case 'sun':
        return DayInWeek.sun;
      default:
        throw Exception('Unknown DayInWeek: $json');
    }
  }
}

enum MedicineUnit {
  pill,
  capsule,
  ml;

  String get toJson {
    return name;
  }

  static MedicineUnit fromJson(String json) {
    switch (json) {
      case 'pill':
        return MedicineUnit.pill;
      case 'capsule':
        return MedicineUnit.capsule;
      case 'ml':
        return MedicineUnit.ml;
      default:
        throw Exception('Unknown MedicineUnit: $json');
    }
  }

  IconData get icon {
    switch (this) {
      case MedicineUnit.pill:
        return FluentIcons.circle_line_20_filled;
      case MedicineUnit.capsule:
        return FluentIcons.pill_20_filled;
      case MedicineUnit.ml:
        return FluentIcons.syringe_20_filled;
    }
  }

  List<double> get dose {
    switch (this) {
      case MedicineUnit.pill:
        return [0.5, 1, 1.5, 2];
      case MedicineUnit.capsule:
        return [1, 2, 3, 4];
      case MedicineUnit.ml:
        return [50, 100, 150, 200, 250, 300, 350];
    }
  }
}

enum PillUseNote {
  beforeEat,
  afterEat,
  none;

  String get label {
    switch (this) {
      case PillUseNote.beforeEat:
        return 'Before eat';
      case PillUseNote.afterEat:
        return 'After eat';
      case PillUseNote.none:
        return 'None';
    }
  }

  String get toJson {
    return name;
  }

  static PillUseNote fromJson(String json) {
    switch (json) {
      case 'beforeEat':
        return PillUseNote.beforeEat;
      case 'afterEat':
        return PillUseNote.afterEat;
      case 'none':
        return PillUseNote.none;
      default:
        throw Exception('Unknown PillUseNote: $json');
    }
  }
}
