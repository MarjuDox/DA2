import 'package:diabetes/core/extension/context_extension.dart';
import 'package:diabetes/core/extension/timeofday_extension.dart';
import 'package:diabetes/model/pill_schedule/pill_schedule_model.dart';
import 'package:diabetes/screens/common_widget/text_shimmerable.dart';
import 'package:flutter/material.dart';

class PillCardContent extends StatelessWidget {
  const PillCardContent({super.key, required this.item, this.onCheck});

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
    return Row(
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
                TextShimmerable(
                  child: Text(
                    item.time.formattedTime,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                TextShimmerable(
                  child: Text(
                    item.medicineName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            TextShimmerable(
              child: Text(
                "${item.dose} ${item.unit.name}",
                style: TextStyle(
                    fontSize: 14, color: context.colorScheme.secondary),
              ),
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
    );
  }
}
