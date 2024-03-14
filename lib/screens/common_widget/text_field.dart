import 'package:diabetes/core/extension/context_extension.dart';
import 'package:flutter/material.dart';

class TextFieldX extends StatelessWidget {
  const TextFieldX({
    super.key,
    required this.controller,
    this.errorText,
    this.labelText,
    this.hintText,
    this.onChanged,
  });
  final TextEditingController controller;
  final String? hintText;
  final String? labelText;
  final String? errorText;
  final ValueChanged<String?>? onChanged;

  OutlineInputBorder getBorder(Color color) {
    return OutlineInputBorder(
      borderSide: BorderSide(color: color, width: 1),
      borderRadius: BorderRadius.circular(18),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelStyle: MaterialStateTextStyle.resolveWith(
          (Set<MaterialState> states) {
            final Color color = states.contains(MaterialState.error)
                ? Theme.of(context).colorScheme.error
                : context.colorScheme.secondary.withOpacity(0.6);
            return TextStyle(color: color);
          },
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        errorText: errorText,
        hintText: hintText,
        labelText: labelText,
        border: getBorder(context.colorScheme.outlineVariant.withOpacity(0.6)),
        enabledBorder:
            getBorder(context.colorScheme.outlineVariant.withOpacity(0.6)),
        errorBorder: getBorder(context.colorScheme.error),
      ),
    );
  }
}
