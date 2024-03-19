import 'package:diabetes/core/extension/context_extension.dart';
import 'package:flutter/material.dart';

class SettingsContainer extends StatelessWidget {
  final bool withArrow;
  final Widget child;
  final IconData? icon;
  final Function()? onTap;

  const SettingsContainer({
    Key? key,
    this.withArrow = false,
    required this.child,
    this.onTap,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: context.colorScheme.background,
            boxShadow: [
              BoxShadow(
                color: context.colorScheme.shadow.withOpacity(0.05),
                spreadRadius: 3,
                blurRadius: 10,
                offset: const Offset(0, 5), // changes position of shadow
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: Row(
              children: [
                if (icon != null)
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: context.colorScheme.secondary.withOpacity(0.1),
                    ),
                    padding: const EdgeInsets.all(6),
                    margin: const EdgeInsets.only(right: 12),
                    child: Icon(
                      icon!,
                      size: 18,
                    ),
                  ),
                Expanded(child: child),
                if (withArrow)
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16,
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
