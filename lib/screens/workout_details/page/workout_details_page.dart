import 'package:diabetes/core/common_widget/base_screen.dart';
import 'package:diabetes/core/const/text_constants.dart';
import 'package:diabetes/model/workout_model.dart';
import 'package:diabetes/screens/common_widget/diabetes_button.dart';
import 'package:diabetes/screens/start_workout/page/start_workout_page.dart';
import 'package:diabetes/screens/workout_details/bloc/workout_details_bloc.dart';
import 'package:diabetes/screens/workout_details/widget/workout_detail_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WorkoutDetailsPage extends StatelessWidget {
  final WorkoutModel workout;

  const WorkoutDetailsPage({
    super.key,
    required this.workout,
  });

  @override
  Widget build(BuildContext context) {
    return _buildContext(context);
  }

  BlocProvider<WorkoutDetailsBloc> _buildContext(BuildContext context) {
    final workoutDetailsBloc = WorkoutDetailsBloc();
    return BlocProvider<WorkoutDetailsBloc>(
      create: (context) => workoutDetailsBloc,
      child: BlocConsumer<WorkoutDetailsBloc, WorkoutDetailsState>(
        buildWhen: (_, currState) => currState is WorkoutDetailsInitial,
        builder: (context, state) {
          final bloc = BlocProvider.of<WorkoutDetailsBloc>(context);
          bloc.add(WorkoutDetailsInitialEvent(workout: workout));
          return Scaffold(
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            body: BaseScreen(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: WorkoutDetailsContent(workout: workout)),
                DiabetesButton(
                  title: workout.currentProgress == 0
                      ? TextConstants.start
                      : TextConstants.continueT,
                  onTap: () {
                    final index = workout.currentProgress ==
                            workout.exerciseDataList!.length
                        ? 0
                        : workout.currentProgress;
                    bloc.add(StartTappedEvent(index: index));
                  },
                ),
              ],
            )),
          );
        },
        listenWhen: (_, currState) =>
            currState is BackTappedState ||
            currState is WorkoutExerciseCellTappedState ||
            currState is StartTappedState,
        listener: (context, state) async {
          if (state is BackTappedState) {
            Navigator.pop(context);
          } else if (state is StartTappedState) {
            final workout = state.isReplace
                ? await Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: BlocProvider.of<WorkoutDetailsBloc>(context),
                        child: StartWorkoutPage(
                          workout: state.workout,
                          index: state.index,
                        ),
                      ),
                    ),
                  )
                : await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: BlocProvider.of<WorkoutDetailsBloc>(context),
                        child: StartWorkoutPage(
                          workout: state.workout,
                          index: state.index,
                        ),
                      ),
                    ),
                  );
            if (workout is WorkoutModel) {
              BlocProvider.of<WorkoutDetailsBloc>(context).add(
                WorkoutDetailsInitialEvent(workout: workout),
              );
            }
          }
        },
      ),
    );
  }
}
