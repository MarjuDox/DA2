import 'package:diabetes/core/const/color_constants.dart';
import 'package:diabetes/core/const/text_constants.dart';
import 'package:diabetes/core/extension/context_extension.dart';
import 'package:diabetes/model/workout_model.dart';
import 'package:diabetes/screens/common_widget/card_x.dart';
import 'package:diabetes/screens/workouts/bloc/workouts_bloc.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class WorkoutCard extends StatelessWidget {
  final WorkoutModel workout;

  const WorkoutCard({
    Key? key,
    required this.workout,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<WorkoutsBloc>(context, listen: false);
    return CardX(
      onTap: () {
        bloc.add(CardTappedEvent(workout: workout));
      },
      child: BlocBuilder<WorkoutsBloc, WorkoutsState>(
        buildWhen: (_, currState) => currState is CardTappedState,
        builder: (context, state) {
          return Column(
            children: [
              Row(
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(workout.title ?? "",
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            const Spacer(),
                            Text(
                              workout.isDone
                                  ? 'Done'
                                  : '${workout.currentProgress}/${workout.progress}',
                              style: TextStyle(
                                color: workout.isDone
                                    ? context.colorScheme.primary
                                    : context.colorScheme.secondary,
                              ),
                            ),
                          ],
                        ),
                        Text(
                            '${workout.exerciseDataList!.length} ${TextConstants.exercisesUppercase}',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: context.colorScheme.secondary),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2),
                        Text(_getWorkoutMinutes(),
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: context.colorScheme.secondary),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              LinearPercentIndicator(
                percent: workout.currentProgress! / workout.progress!,
                progressColor: context.colorScheme.primary,
                barRadius: const Radius.circular(100),
                backgroundColor: context.colorScheme.primary.withOpacity(0.12),
                lineHeight: 6,
                padding: EdgeInsets.zero,
              ),
            ],
          );
        },
      ),
    );
  }

  String _getWorkoutMinutes() {
    var minutes = 0;
    var seconds = 0;
    final minutesList =
        workout.exerciseDataList!.map((e) => e.minutes).toList();
    final secondsList =
        workout.exerciseDataList!.map((e) => e.seconds).toList();
    for (var e in minutesList) {
      minutes += e!;
    }
    for (var e in secondsList) {
      seconds += e!;
    }

    return "${minutes + (seconds ~/ 60)}':${seconds % 60}″ ";
  }
}
