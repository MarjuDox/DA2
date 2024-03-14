import 'package:diabetes/core/extension/context_extension.dart';
import 'package:diabetes/screens/common_widget/shimmerx.dart';
import 'package:flutter/material.dart';

class TextShimmerable extends StatelessWidget {
  const TextShimmerable({
    super.key,
    this.backgroundColor,
    required this.child,
  });

  final Color? backgroundColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: backgroundColor ?? context.colorScheme.surface,
          borderRadius: BorderRadius.circular(4),
        ),
        child: child);
  }
}
