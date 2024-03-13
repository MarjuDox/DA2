import 'package:intl/intl.dart';

extension DateTimeX on DateTime? {
  String get toMMMd {
    if (this == null) return '';
    var format = DateFormat.MMMd();
    return format.format(this!);
  }
}
