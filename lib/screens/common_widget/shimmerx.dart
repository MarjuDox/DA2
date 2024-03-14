import 'package:diabetes/core/extension/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerX extends StatelessWidget {
  const ShimmerX({Key? key, required this.child}) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    return Shimmer.fromColors(
      period: const Duration(milliseconds: 1500),
      highlightColor:
          context.colorScheme.primary.withOpacity(isLight ? 0.5 : 0.1),
      baseColor: isLight
          ? context.colorScheme.primary.withOpacity(0.3)
          : context.colorScheme.outlineVariant.withOpacity(0.2),
      child: child,
    );
  }
}
