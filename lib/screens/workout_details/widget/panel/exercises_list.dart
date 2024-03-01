import 'package:diabetes/model/exercise_cell_model.dart';
import 'package:diabetes/model/exercise_model.dart';
import 'package:diabetes/model/workout_model.dart';
import 'package:flutter/material.dart';

class ExercisesList extends StatelessWidget {
  final WorkoutModel workout;
  final List<ExerciseModel> exercises;

  const ExercisesList({required this.exercises, required this.workout});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.only(top: 10),
      itemCount: exercises.length,
      itemBuilder: (context, index) {
        return ExerciseCell(
          currentExercise: exercises[index],
          nextExercise:
              index == exercises.length - 1 ? null : exercises[index + 1],
          workout: workout,
          index: index,
        );
      },
      separatorBuilder: (context, index) {
        return const SizedBox(height: 15);
      },
    );
  }

  
}