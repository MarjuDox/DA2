import 'package:diabetes/core/const/color_constants.dart';
import 'package:diabetes/core/extension/context_extension.dart';
import 'package:flutter/material.dart';

class DiabetesButton extends StatelessWidget {
  final String title;
  final bool isEnabled;
  final Function() onTap;

  const DiabetesButton(
      {super.key,
      required this.title,
      this.isEnabled = true,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 55,
      decoration: BoxDecoration(
        color: isEnabled
            ? context.colorScheme.primary
            : context.colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: isEnabled ? onTap : null,
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: isEnabled
                    ? context.colorScheme.onPrimary
                    : context.colorScheme.onSurfaceVariant,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
