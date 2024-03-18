import 'package:diabetes/core/common_widget/base_screen.dart';
import 'package:diabetes/core/const/color_constants.dart';
import 'package:diabetes/core/const/path_constants.dart';
import 'package:diabetes/core/const/text_constants.dart';
import 'package:diabetes/core/extension/context_extension.dart';
import 'package:diabetes/core/service/data_service.dart';
import 'package:diabetes/model/exercise_model.dart';
import 'package:diabetes/model/workout_model.dart';
import 'package:diabetes/screens/common_widget/diabetes_button.dart';
import 'package:diabetes/screens/start_workout/bloc/start_workout_bloc.dart';
import 'package:diabetes/screens/start_workout/widget/start_workout_video.dart';
import 'package:diabetes/screens/workout_details/bloc/workout_details_bloc.dart'
    as workout_bloc;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StartWorkoutContent extends StatelessWidget {
  final WorkoutModel workout;
  final ExerciseModel exercise;
  final ExerciseModel? nextExercise;

  const StartWorkoutContent({
    super.key,
    required this.workout,
    required this.exercise,
    required this.nextExercise,
  });

  @override
  Widget build(BuildContext context) {
    return _createDetailedExercise(context);
  }

  Widget _createDetailedExercise(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: BaseScreen(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _createVideo(context),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView(children: [
                    _createTitle(),
                    const SizedBox(height: 9),
                    _createDescription(),
                    const SizedBox(height: 30),
                    _createSteps(),
                  ]),
                ),
                _createTimeTracker(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _createVideo(BuildContext context) {
    final bloc = BlocProvider.of<StartWorkoutBloc>(context);
    return AspectRatio(
      aspectRatio: 3 / 2,
      child: StartWorkoutVideo(
        exercise: exercise,
        onPlayTapped: (time) async {
          bloc.add(PlayTappedEvent(time: time));
        },
        onPauseTapped: (time) {
          bloc.add(PauseTappedEvent(time: time));
        },
      ),
    );
  }

  Widget _createTitle() {
    return Text(exercise.title ?? "",
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold));
  }

  Widget _createDescription() {
    return Text(exercise.description ?? "",
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500));
  }

  Widget _createSteps() {
    return Column(
      children: [
        for (int i = 0; i < exercise.steps!.length; i++) ...[
          Step(number: "${i + 1}", description: exercise.steps![i]),
          const SizedBox(height: 20),
        ],
      ],
    );
  }

  Widget _createTimeTracker(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        nextExercise != null
            ? Wrap(
                alignment: WrapAlignment.start,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    TextConstants.nextExercise,
                    style: TextStyle(
                      color: context.colorScheme.secondary,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    nextExercise?.title ?? "",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 6.5),
                  const Icon(Icons.access_time, size: 20),
                  const SizedBox(width: 6.5),
                  Text(
                      '${nextExercise!.minutes! > 10 ? nextExercise!.minutes : '0${nextExercise!.minutes}'} : ${nextExercise!.seconds! > 10 ? nextExercise!.seconds : '0${nextExercise!.seconds}'}'),
                  // BlocBuilder<StartWorkoutBloc, StartWorkoutState>(
                  //   buildWhen: (_, currState) => currState is PlayTimerState || currState is PauseTimerState,
                  //   builder: (context, state) {
                  //     return StartWorkoutTimer(
                  //       time: bloc.time,
                  //       isPaused: !(state is PlayTimerState),
                  //     );
                  //   },
                  // ),
                ],
              )
            : const SizedBox.shrink(),
        const SizedBox(height: 10),
        _createButton(context),
      ],
    );
  }

  Widget _createButton(BuildContext context) {
    final bloc = BlocProvider.of<workout_bloc.WorkoutDetailsBloc>(context);
    return DiabetesButton(
      title: nextExercise != null ? TextConstants.next : TextConstants.finished,
      onTap: () async {
        if (nextExercise != null) {
          List<ExerciseModel>? exercisesList = bloc.workout.exerciseDataList;
          int currentExerciseIndex = exercisesList!.indexOf(exercise);

          await _saveWorkout(currentExerciseIndex);

          if (currentExerciseIndex < exercisesList.length - 1) {
            bloc.add(workout_bloc.StartTappedEvent(
              workout: workout,
              index: currentExerciseIndex + 1,
              isReplace: true,
            ));
          }
        } else {
          await _saveWorkout(workout.exerciseDataList!.length - 1);

          Navigator.pop(context, workout);
        }
      },
    );
  }

  Future<void> _saveWorkout(int exerciseIndex) async {
    if (workout.currentProgress! < exerciseIndex + 1) {
      workout.currentProgress = exerciseIndex + 1;
    }
    workout.exerciseDataList![exerciseIndex].progress = 1;

    await DataService.saveWorkout(workout);
  }
}

class Step extends StatelessWidget {
  final String number;
  final String description;

  const Step({super.key, required this.number, required this.description});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 25,
          width: 25,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: context.colorScheme.primary.withOpacity(0.12),
          ),
          child: Center(
            child: Text(
              number,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: context.colorScheme.primary,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(child: Text(description)),
      ],
    );
  }
}
