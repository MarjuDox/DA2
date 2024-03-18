enum DayOfWeekEnum {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday;

  String toCode() {
    switch (this) {
      case DayOfWeekEnum.monday:
        return 'MONDAY';
      case DayOfWeekEnum.tuesday:
        return 'TUESDAY';
      case DayOfWeekEnum.wednesday:
        return 'WEDNESDAY';
      case DayOfWeekEnum.thursday:
        return 'THURSDAY';
      case DayOfWeekEnum.friday:
        return 'FRIDAY';
      case DayOfWeekEnum.saturday:
        return 'SATURDAY';
      case DayOfWeekEnum.sunday:
        return 'SUNDAY';
    }
  }

  static DayOfWeekEnum? onParse(String value) {
    switch (value) {
      case 'MONDAY':
        return DayOfWeekEnum.monday;
      case 'TUESDAY':
        return DayOfWeekEnum.tuesday;
      case 'WEDNESDAY':
        return DayOfWeekEnum.wednesday;
      case 'THURSDAY':
        return DayOfWeekEnum.thursday;
      case 'FRIDAY':
        return DayOfWeekEnum.friday;
      case 'SATURDAY':
        return DayOfWeekEnum.saturday;
      case 'SUNDAY':
        return DayOfWeekEnum.sunday;
    }
    return null;
  }

  String toTitleBrief() {
    switch (this) {
      case DayOfWeekEnum.monday:
        return 'MON';
      case DayOfWeekEnum.tuesday:
        return 'TUE';
      case DayOfWeekEnum.wednesday:
        return 'WED';
      case DayOfWeekEnum.thursday:
        return 'THU';
      case DayOfWeekEnum.friday:
        return 'FRI';
      case DayOfWeekEnum.saturday:
        return 'SAT';
      case DayOfWeekEnum.sunday:
        return 'SUN';
    }
  }
}
