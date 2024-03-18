import 'package:diabetes/model/workout_model.dart';
import 'package:diabetes/screens/workout_details/widget/panel/workout_details_panel.dart';
import 'package:diabetes/screens/workout_details/widget/workout_details_body.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class WorkoutDetailsContent extends StatelessWidget {
  final WorkoutModel workout;

  const WorkoutDetailsContent({super.key, required this.workout});

  @override
  Widget build(BuildContext context) {
    return _createSlidingUpPanel(context);
  }

  Widget _createSlidingUpPanel(BuildContext context) {
    return SlidingUpPanel(
      panel: WorkoutDetailsPanel(workout: workout),
      body: WorkoutDetailsBody(workout: workout),
      minHeight: MediaQuery.of(context).size.height * 0.65,
      maxHeight: MediaQuery.of(context).size.height * 0.87,
      isDraggable: true,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(50),
        topRight: Radius.circular(50),
      ),
    );
  }
}
