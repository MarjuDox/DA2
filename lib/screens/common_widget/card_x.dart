import 'package:diabetes/core/extension/context_extension.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';

class CardX extends StatelessWidget {
  const CardX({super.key, required this.child});
final Widget child;
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
      child: child,
    );
  }
}