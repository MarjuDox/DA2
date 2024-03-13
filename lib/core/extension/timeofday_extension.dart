import 'package:flutter/material.dart';

extension TimeOfDayX on TimeOfDay {
  String get formattedTime {
    final hour = this.hour.toString().padLeft(2, '0');
    final minute = this.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}