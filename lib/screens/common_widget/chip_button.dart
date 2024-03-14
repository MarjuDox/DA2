import 'package:diabetes/core/extension/context_extension.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

class ChipButton<T> extends StatelessWidget {
  final T value;
  final String label;
  final bool isSelected;

  const ChipButton({
    super.key,
    required this.value,
    required this.label,
    required this.isSelected,
  });
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: ShapeDecoration(
        color: isSelected
            ? context.colorScheme.surface
            : context.colorScheme.secondaryContainer.withOpacity(0.5),
        shape: SmoothRectangleBorder(
          side: BorderSide(
            strokeAlign: BorderSide.strokeAlignInside,
            color:
                isSelected ? context.colorScheme.primary : Colors.transparent,
          ),
          borderRadius: SmoothBorderRadius(
            cornerRadius: 17,
            cornerSmoothing: 1,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label,
              maxLines: 1,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: isSelected
                    ? context.colorScheme.primary
                    : context.colorScheme.onSecondaryContainer,
              )),
          const SizedBox(
            height: 4,
          ),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                boxShadow: [
                  BoxShadow(
                      color: context.colorScheme.shadow.withOpacity(0.05),
                      blurRadius: 3,
                      spreadRadius: 1,
                      offset: const Offset(2, 2)),
                ]),
            child: Icon(
              FluentIcons.checkmark_circle_32_filled,
              color: isSelected
                  ? context.colorScheme.primary
                  : context.colorScheme.surface,
            ),
          ),
        ],
      ),
    );
  }
}