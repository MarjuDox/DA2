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
    return FilledButton(
      onPressed: isEnabled ? onTap : null,
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
