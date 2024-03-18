import 'package:diabetes/core/extension/context_extension.dart';
import 'package:flutter/material.dart';

class WorkoutTag extends StatelessWidget {
  final IconData icon;
  final String content;

  const WorkoutTag({super.key, required this.icon, required this.content});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: context.colorScheme.primary.withOpacity(0.12),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 17,
            color: context.colorScheme.primary,
          ),
          const SizedBox(width: 7),
          Text(content,
              style: TextStyle(
                  color: context.colorScheme.primary,
                  fontSize: 14,
                  fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
