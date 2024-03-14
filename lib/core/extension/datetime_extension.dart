import 'package:intl/intl.dart';

extension DateTimeX on DateTime? {
  String get toMMMd {
    if (this == null) return '';
    var format = DateFormat.MMMd();
    return format.format(this!);
  }

  DateTime get dateOnly {
    return DateTime(this!.year, this!.month, this!.day);
  }
}
