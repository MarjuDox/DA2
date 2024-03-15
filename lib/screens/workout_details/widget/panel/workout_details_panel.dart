import 'package:diabetes/core/const/path_constants.dart';
import 'package:diabetes/core/const/text_constants.dart';
import 'package:diabetes/model/workout_model.dart';
import 'package:diabetes/screens/workout_details/bloc/workout_details_bloc.dart';
import 'package:diabetes/screens/workout_details/widget/panel/exercises_list.dart';
import 'package:diabetes/screens/workout_details/widget/panel/workout_tag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:math';

class WorkoutDetailsPanel extends StatelessWidget {
  final WorkoutModel workout;

  WorkoutDetailsPanel({required this.workout});

  @override
  Widget build(BuildContext context) {
    return _createPanelData(context);
  }

  Widget _createPanelData(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 15),
        _createRectangle(),
        const SizedBox(height: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _createHeader(),
              const SizedBox(height: 20),
              _createWorkoutData(context),
              SizedBox(height: 20),
              _createExerciseList(),
            ],
          ),
        ),
      ],
    );
  }

   Widget _createRectangle() {
    return Image(image: AssetImage(PathConstants.rectangle));
  }

  Widget _createHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        workout.title! + "  " + TextConstants.workout,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _createWorkoutData(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          WorkoutTag(
            icon: PathConstants.timeTracker,
            content: "${_getTimeExercise()}",
          ),
          const SizedBox(width: 15),
          WorkoutTag(
            icon: PathConstants.exerciseTracker,
            content:
                '${workout.exerciseDataList!.length} ${TextConstants.exercisesLowercase}',
          ),
        ],
      ),
    );
  }

  int _getExerciseMinutes() {
    int minutes = 0;
    final List<int?> exerciseList = workout.exerciseDataList!.map((e) => e.minutes).toList();
    exerciseList.forEach((e) {
      minutes += e!;
    });
    return minutes;
  }

  int _getExerciseSeconds() {
    int second = 0;
    final List<int?> exerciseList = workout.exerciseDataList!.map((e) => e.seconds).toList();
    exerciseList.forEach((e) {
      second += e!;
    });
    return second;
  }

  String _getTimeExercise(){
    String time = '';
    int m = _getExerciseMinutes();
    int s = _getExerciseSeconds();
    int t = s % 60;
    m = m + (s ~/ 60);
    time = '$m : $t';
    return time;
  }

  Widget _createExerciseList() {
    return BlocBuilder<WorkoutDetailsBloc, WorkoutDetailsState>(
      buildWhen: (_, currState) => currState is ReloadWorkoutDetailsState,
      builder: (context, state) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ExercisesList(
              exercises: workout.exerciseDataList ?? [],
              workout: workout,
            ),
          ),
        );
      },
    );
  }
}
