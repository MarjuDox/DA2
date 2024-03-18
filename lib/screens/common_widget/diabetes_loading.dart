import 'package:diabetes/core/extension/context_extension.dart';
import 'package:flutter/cupertino.dart';

class DiabetesLoading extends StatelessWidget {
  const DiabetesLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: CupertinoActivityIndicator(
          color: context.colorScheme.onSurface,
          radius: 17,
        ),
      ),
    );
  }
}
