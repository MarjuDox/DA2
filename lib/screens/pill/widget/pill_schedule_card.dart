import 'package:diabetes/core/extension/context_extension.dart';
import 'package:diabetes/core/extension/timeofday_extension.dart';
import 'package:diabetes/model/pill_schedule/pill_schedule_model.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';

class PillScheduleCard extends StatelessWidget {
  const PillScheduleCard({super.key, required this.item, this.onCheck});

  final PillModel item;
  final VoidCallback? onCheck;

  IconData get icon {
    if (item.isTaken) {
      return Icons.check_rounded;
    } else {
      if (item.isExpired) {
        return Icons.close_rounded;
      } else {
        return Icons.check_rounded;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: ShapeDecoration(
        shape: const SmoothRectangleBorder(
          borderRadius: SmoothBorderRadius.all(
              SmoothRadius(cornerRadius: 20, cornerSmoothing: 1)),
        ),
        color: context.colorScheme.surface,
        shadows: [
          BoxShadow(
            color: context.colorScheme.shadow.withOpacity(0.05),
            spreadRadius: 3,
            blurRadius: 10,
            offset: const Offset(0, 5), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            item.unit.icon,
            size: 40,
            color: context.colorScheme.primary,
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Builder(
                    builder: (context) {
                      return Text(
                        item.time.formattedTime,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      );
                    },
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    item.medicineName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              Text(
                "${item.dose} ${item.unit.name}",
                style: TextStyle(
                    fontSize: 14, color: context.colorScheme.secondary),
              ),
            ],
          ),
          const Spacer(),
          InkWell(
            onTap: onCheck,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: ShapeDecoration(
                shape: CircleBorder(
                  side: BorderSide(
                    color: context.colorScheme.primary.withOpacity(0.2),
                    width: 2,
                  ),
                ),
              ),
              child: Icon(
                icon,
                color: item.isExpired
                    ? item.isTaken
                        ? context.colorScheme.primary.withOpacity(0.5)
                        : context.colorScheme.error.withOpacity(0.5)
                    : item.isTaken
                        ? context.colorScheme.primary
                        : Colors.transparent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
