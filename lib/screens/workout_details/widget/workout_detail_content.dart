import 'package:diabetes/core/const/text_constants.dart';
import 'package:diabetes/model/exercise_cell_model.dart';
import 'package:diabetes/model/workout_model.dart';
import 'package:diabetes/screens/workout_details/bloc/workout_details_bloc.dart';
import 'package:diabetes/screens/workout_details/widget/panel/workout_details_panel.dart';
import 'package:diabetes/screens/workout_details/widget/panel/workout_tag.dart';
import 'package:diabetes/screens/workout_details/widget/workout_details_body.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class WorkoutDetailsContent extends StatelessWidget {
  final WorkoutModel workout;

  const WorkoutDetailsContent({super.key, required this.workout});

  @override
  Widget build(BuildContext context) {
    return _createSlidingUpPanel(context);
  }

  Widget _createSlidingUpPanel(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar.large(
          flexibleSpace: FlexibleSpaceBar(
            background: Image(
              image: AssetImage(workout.image ?? ""),
              fit: BoxFit.contain,
            ),
          ),
          expandedHeight: 200,
        ),
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              _createHeader(),
              const SizedBox(height: 8),
              _createWorkoutData(context),
              const SizedBox(height: 16),
            ],
          ),
        ),
        BlocBuilder<WorkoutDetailsBloc, WorkoutDetailsState>(
          buildWhen: (_, currState) => currState is ReloadWorkoutDetailsState,
          builder: (context, state) {
            final exercises = workout.exerciseDataList ?? [];
            return SliverList.separated(
              itemCount: exercises.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ExerciseCell(
                    currentExercise: exercises[index],
                    nextExercise: index == exercises.length - 1
                        ? null
                        : exercises[index + 1],
                    workout: workout,
                    index: index,
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return const SizedBox(height: 16);
              },
            );
          },
        ),
        const SliverToBoxAdapter(
          child: SizedBox(
            height: 16,
          ),
        ),
      ],
    );
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

  Widget _createHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        "${workout.title!}  ${TextConstants.workout}",
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _createWorkoutData(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          WorkoutTag(
            icon: FluentIcons.clock_24_filled,
            content: _getTimeExercise(),
          ),
          const SizedBox(width: 15),
          WorkoutTag(
            icon: FluentIcons.accessibility_24_filled,
            content:
                '${workout.exerciseDataList!.length} ${TextConstants.exercisesLowercase}',
          ),
        ],
      ),
    );
  }

  int _getExerciseMinutes() {
    int minutes = 0;
    final List<int?> exerciseList =
        workout.exerciseDataList!.map((e) => e.minutes).toList();
    for (var e in exerciseList) {
      minutes += e!;
    }
    return minutes;
  }

  int _getExerciseSeconds() {
    int second = 0;
    final List<int?> exerciseList =
        workout.exerciseDataList!.map((e) => e.seconds).toList();
    for (var e in exerciseList) {
      second += e!;
    }
    return second;
  }

  String _getTimeExercise() {
    String time = '';
    int m = _getExerciseMinutes();
    int s = _getExerciseSeconds();
    int t = s % 60;
    m = m + (s ~/ 60);
    time = '$m : $t';
    return time;
  }
}
