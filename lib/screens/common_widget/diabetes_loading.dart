import 'package:diabetes/core/const/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';


class DiabetesLoading extends StatelessWidget {
  const DiabetesLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: ColorConstants.loadingBlack,
      child: Center(
        child: Theme(
          data: ThemeData(
            cupertinoOverrideTheme:
                const CupertinoThemeData(brightness: Brightness.dark),
          ),
          child: const CupertinoActivityIndicator(
            radius: 17,
          ),
        ),
      ),
    );
  }
}