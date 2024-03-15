import 'package:diabetes/core/extension/context_extension.dart';
import 'package:diabetes/core/extension/datetime_extension.dart';
import 'package:diabetes/model/pill_schedule/pill_schedule_model.dart';
import 'package:diabetes/screens/common_widget/text_shimmerable.dart';
import 'package:diabetes/screens/pill/widget/time_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PillScheduleCardContent extends StatelessWidget {
  const PillScheduleCardContent({super.key, required this.item});

  final PillScheduleModel item;

  bool get isActive {
    return item.isActiveAt(DateTime.now().dateOnly);
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = context.colorScheme.primary;
    return Opacity(
      opacity: isActive ? 1 : 0.5,
      child: Row(
        children: [
          Column(
            children: [
              Icon(
                item.unit.icon,
                size: 40,
                color: primaryColor,
              ),
              Text(
                item.isExpired
                    ? 'Done'
                    : isActive
                        ? 'Active'
                        : 'Inactive',
                style: TextStyle(
                  color: primaryColor,
                ),
              )
            ],
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextShimmerable(
                        child: Text(
                          item.medicineName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    TextShimmerable(
                      child: Text(
                        "${item.dose * item.times.length} ${item.unit.name} / day",
                        style: TextStyle(
                            fontSize: 14, color: context.colorScheme.secondary),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  runSpacing: 10,
                  spacing: 8,
                  children: item.times.map<Widget>((time) {
                    return TimeChip(time: time);
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
