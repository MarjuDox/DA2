import 'package:diabetes/core/common_widget/base_screen.dart';
import 'package:diabetes/core/const/text_constants.dart';
import 'package:diabetes/model/workout_model.dart';
import 'package:diabetes/screens/workouts/bloc/workouts_bloc.dart';
import 'package:diabetes/screens/workouts/widget/workout_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WorkoutContent extends StatelessWidget {
  const WorkoutContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _createHomeBody(context);
  }

  Widget _createHomeBody(BuildContext context) {
    final bloc = BlocProvider.of<WorkoutsBloc>(context);
    return BlocBuilder<WorkoutsBloc, WorkoutsState>(
      buildWhen: (_, currState) => currState is ReloadWorkoutsState,
      builder: (context, state) {
        return SafeArea(
          child: BaseScreen(
            child: Padding(
              padding: const EdgeInsets.only(top: 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      TextConstants.workouts,
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                      children: bloc.workouts
                          .map((e) => _createWorkoutCard(e))
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _createWorkoutCard(WorkoutModel workoutModel) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: WorkoutCard(workout: workoutModel),
    );
  }
}
