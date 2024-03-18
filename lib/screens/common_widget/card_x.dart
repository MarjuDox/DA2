import 'package:diabetes/core/extension/context_extension.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';

class CardX extends StatelessWidget {
  const CardX({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(16),
  });
  final Widget child;
  final EdgeInsets padding;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      customBorder: const SmoothRectangleBorder(
        borderRadius: SmoothBorderRadius.all(
            SmoothRadius(cornerRadius: 20, cornerSmoothing: 1)),
      ),
      child: Container(
        padding: padding,
        clipBehavior: Clip.hardEdge,
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
        child: child,
      ),
    );
  }
}
