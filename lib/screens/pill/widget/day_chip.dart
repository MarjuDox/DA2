import 'package:diabetes/core/const/enum.dart';
import 'package:diabetes/core/extension/context_extension.dart';
import 'package:diabetes/core/extension/datetime_extension.dart';
import 'package:flutter/material.dart';

class DayChip extends StatelessWidget {
  const DayChip({
    super.key,
    required this.dateTime,
    this.isSelected = false,
  });

  final DateTime dateTime;
  final bool isSelected;
  bool get isToday => dateTime.dateOnly == DateTime.now().dateOnly;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.all(12),
      decoration: ShapeDecoration(
        shadows: [
          if (isSelected)
            BoxShadow(
              color: context.colorScheme.primary.withOpacity(0.4),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
        ],
        color: isSelected
            ? context.colorScheme.primary
            : context.colorScheme.secondaryContainer,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: isToday ? context.colorScheme.primary : Colors.transparent,
            width: 2,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(100)),
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: context.colorScheme.surface,
            ),
            child: Text(
              dateTime.day.toString(),
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected
                    ? context.colorScheme.primary
                    : context.colorScheme.onSurface,
              ),
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            DayInWeek.fromDateTime(dateTime).label,
            style: TextStyle(
                fontSize: 12,
                color: isSelected
                    ? context.colorScheme.onPrimary
                    : context.colorScheme.onSecondaryContainer),
          ),
          const SizedBox(
            height: 4,
          ),
        ],
      ),
    );
  }
}
