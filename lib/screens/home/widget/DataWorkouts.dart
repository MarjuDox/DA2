import 'package:diabetes/core/const/color_constants.dart';
import 'package:diabetes/core/extension/context_extension.dart';
import 'package:diabetes/screens/common_widget/card_x.dart';
import 'package:flutter/material.dart';

class DataWorkouts extends StatelessWidget {
  final String icon;
  final String title;
  final String count;
  final String text;

  const DataWorkouts({
    super.key,
    required this.icon,
    required this.title,
    required this.count,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return CardX(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            children: [
              Image(image: AssetImage(icon)),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            children: [
              Text(
                count,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                text,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: ColorConstants.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
