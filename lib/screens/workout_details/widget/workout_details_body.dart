import 'package:diabetes/model/workout_model.dart';
import 'package:diabetes/screens/workout_details/bloc/workout_details_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WorkoutDetailsBody extends StatelessWidget {
  final WorkoutModel workout;
  const WorkoutDetailsBody({super.key, required this.workout});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _createImage(),
        _createBackButton(context),
      ],
    );
  }

  Widget _createImage() {
    return SizedBox(
      width: double.infinity,
      child: Image(
        image: AssetImage(workout.image ?? ""),
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _createBackButton(BuildContext context) {
    final bloc = BlocProvider.of<WorkoutDetailsBloc>(context, listen: false);
    return SafeArea(
      child: BlocBuilder<WorkoutDetailsBloc, WorkoutDetailsState>(
        builder: (context, state) {
          return BackButton(
            onPressed: () {
              bloc.add(BackTappedEvent());
            },
          );
        },
      ),
    );
  }
}
