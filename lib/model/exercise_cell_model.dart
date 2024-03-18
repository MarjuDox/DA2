import 'package:diabetes/core/const/color_constants.dart';
import 'package:diabetes/core/const/path_constants.dart';
import 'package:diabetes/core/extension/context_extension.dart';
import 'package:diabetes/model/exercise_model.dart';
import 'package:diabetes/model/workout_model.dart';
import 'package:diabetes/screens/common_widget/card_x.dart';
import 'package:diabetes/screens/workout_details/bloc/workout_details_bloc.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class ExerciseCell extends StatelessWidget {
  final WorkoutModel workout;
  final ExerciseModel currentExercise;
  final ExerciseModel? nextExercise;
  final int index;

  const ExerciseCell({
    super.key,
    required this.currentExercise,
    required this.workout,
    required this.nextExercise,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<WorkoutDetailsBloc>(context);
    return BlocBuilder<WorkoutDetailsBloc, WorkoutDetailsState>(
      buildWhen: (_, currState) => currState is WorkoutExerciseCellTappedState,
      builder: (context, state) {
        return InkWell(
          borderRadius: BorderRadius.circular(40),
          onTap: () {
            bloc.add(
              StartTappedEvent(
                workout: workout,
                index: index,
              ),
            );
          },
          child: CardX(
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.asset(
                      workout.image ?? "",
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 3,
                  child: _createExerciseTextInfo(),
                ),
                const SizedBox(width: 10),
                _createRightArrow(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _createExerciseTextInfo() {
    final minutesStr =
        "${currentExercise.minutes}': ${currentExercise.seconds}″ ";
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          currentExercise.title ?? "",
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        Builder(builder: (context) {
          return Text(
            minutesStr,
            style: TextStyle(
              fontSize: 14,
              color: context.colorScheme.secondary,
              fontWeight: FontWeight.w400,
            ),
          );
        }),
        const SizedBox(height: 11),
        Builder(builder: (context) {
          return Padding(
            padding: const EdgeInsets.only(right: 20),
            child: LinearPercentIndicator(
              percent: currentExercise.progress ?? 0,
              progressColor: context.colorScheme.primary,
              backgroundColor: context.colorScheme.primary.withOpacity(0.12),
              lineHeight: 6,
              barRadius: const Radius.circular(100),
              padding: EdgeInsets.zero,
            ),
          );
        }),
      ],
    );
  }

  Widget _createRightArrow() {
    return Builder(builder: (context) {
      return Icon(
        FluentIcons.chevron_right_24_filled,
        color: context.colorScheme.primary,
      );
    });
  }
}
