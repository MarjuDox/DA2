import 'package:diabetes/core/const/color_constants.dart';
import 'package:diabetes/model/workout_model.dart';
import 'package:diabetes/screens/common_widget/card_x.dart';
import 'package:flutter/material.dart';

class WorkoutCard extends StatelessWidget {
  final Color color;
  final WorkoutModel workout;
  final Function() onTap;

  const WorkoutCard({
    super.key,
    required this.color,
    required this.workout,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return CardX(
      onTap: onTap,
      padding: EdgeInsets.zero,
      child: Container(
        padding: const EdgeInsets.only(
          left: 20,
          top: 10,
          right: 12,
        ),
        height: 160,
        width: 250,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: color,
        ),
        child: Stack(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5),
                    Text(
                      "${workout.title} title",
                      style: const TextStyle(
                        color: ColorConstants.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "${workout.exercises} exercises",
                      style: const TextStyle(
                        color: ColorConstants.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "${workout.minutes} minutes",
                      style: const TextStyle(
                        color: ColorConstants.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Image(
                image: AssetImage(workout.image.toString()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
