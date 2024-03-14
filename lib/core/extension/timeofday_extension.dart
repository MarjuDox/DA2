import 'package:flutter/material.dart';

extension TimeOfDayX on TimeOfDay {
  String get formattedTime {
    final hour = this.hour.toString().padLeft(2, '0');
    final minute = this.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  Map<String, int> get toJson {
    return {'hour': hour, 'minute': minute};
  }

  static TimeOfDay fromMap(Map<String, dynamic> map) {
    return TimeOfDay(hour: map['hour'] as int, minute: map['minute'] as int);
  }
}
