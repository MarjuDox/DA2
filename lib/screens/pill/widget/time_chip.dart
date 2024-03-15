import 'package:diabetes/core/extension/context_extension.dart';
import 'package:diabetes/core/extension/timeofday_extension.dart';
import 'package:flutter/material.dart';

class TimeChip extends StatelessWidget {
  const TimeChip({super.key, required this.time, this.onDelete});

  final TimeOfDay time;
  final void Function()? onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colorScheme.outlineVariant.withOpacity(0.2),
        borderRadius: BorderRadius.circular(100),
      ),
      padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            time.formattedTime,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: context.colorScheme.onPrimaryContainer),
          ),
          if (onDelete != null)
            InkWell(
              onTap: onDelete,
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Icon(
                  Icons.close_rounded,
                  size: 16,
                  color:
                      context.colorScheme.onPrimaryContainer.withOpacity(0.3),
                ),
              ),
            )
          else
            const SizedBox(
              width: 4,
            ),
        ],
      ),
    );
  }
}
