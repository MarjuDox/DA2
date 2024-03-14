import 'package:diabetes/core/extension/context_extension.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

class DropDownMenuX<T> extends StatefulWidget {
  const DropDownMenuX({
    super.key,
    required this.items,
    required this.label,
    this.getLabel,
    this.leadingIcon,
    this.value,
    this.initValue,
    this.enable = true,
    this.onSelected,
  });

  final List<T> items;
  final bool enable;
  final String label;
  final IconData? leadingIcon;
  final String Function(T value)? getLabel;
  final String? value;
  final T? initValue;
  final ValueChanged<T?>? onSelected;

  @override
  State<DropDownMenuX<T>> createState() => _DropDownMenuXState<T>();
}

class _DropDownMenuXState<T> extends State<DropDownMenuX<T>> {
  late final controller = TextEditingController(
      text: widget.initValue != null
          ? widget.getLabel?.call(widget.initValue as T) ??
              widget.initValue.toString()
          : null);
  late T? initValue = widget.initValue;

  @override
  void didUpdateWidget(covariant DropDownMenuX<T> oldWidget) {
    if (widget.initValue != initValue) {
      initValue = widget.initValue;
    }
    if (initValue != null) {
      controller.text =
          widget.getLabel?.call(initValue as T) ?? initValue.toString();
    }
    super.didUpdateWidget(oldWidget);
  }

  Color get borderColor => context.colorScheme.outlineVariant.withOpacity(0.6);

  OutlineInputBorder getBorder(Color color) {
    return OutlineInputBorder(
      borderSide: BorderSide(color: color, width: 1),
      borderRadius: BorderRadius.circular(18),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<T>(
        onSelected: widget.onSelected,
        enabled: widget.enable,
        controller: controller,
        initialSelection: widget.initValue,
        label: Text(widget.label),
        expandedInsets: const EdgeInsets.all(0),
        textStyle: TextStyle(
          color: context.colorScheme.onSecondaryContainer,
        ),
        menuStyle: MenuStyle(
          surfaceTintColor:
              MaterialStatePropertyAll(context.colorScheme.surface),
          // backgroundColor:
          //     MaterialStatePropertyAll(context.colorScheme.surface),
          alignment: Alignment.centerLeft,
          shape: const MaterialStatePropertyAll(
            SmoothRectangleBorder(
              borderRadius: SmoothBorderRadius.all(
                SmoothRadius(cornerRadius: 18, cornerSmoothing: 1),
              ),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle:
              TextStyle(color: context.colorScheme.secondary.withOpacity(0.6)),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          errorBorder: getBorder(context.colorScheme.error),
          disabledBorder: getBorder(borderColor),
          enabledBorder: getBorder(borderColor),
        ),
        selectedTrailingIcon: Icon(
          FluentIcons.chevron_up_20_regular,
          size: 20,
          color: borderColor,
        ),
        trailingIcon: Icon(
          FluentIcons.chevron_down_20_regular,
          size: 20,
          color: borderColor,
        ),
        leadingIcon: widget.leadingIcon != null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      border: Border(
                          right: BorderSide(
                        width: 1,
                        color: borderColor,
                      )),
                    ),
                    padding: const EdgeInsets.only(
                        left: 14, right: 10, top: 2, bottom: 2),
                    child: Icon(
                      widget.leadingIcon,
                      color: context.colorScheme.primary,
                      size: 24,
                    ),
                  ),
                ],
              )
            : null,
        dropdownMenuEntries: widget.items
            .map((e) => DropdownMenuEntry(
                  value: e,
                  label: widget.getLabel?.call(e) ?? e.toString(),
                ))
            .toList());
  }
}
