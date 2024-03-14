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
}

enum MedicineUnit {
  pill,
  capsule,
  ml;

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
        return [1, 2];
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
}
