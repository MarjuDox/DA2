import 'package:diabetes/core/const/color_constants.dart';
import 'package:diabetes/core/const/path_constants.dart';
import 'package:diabetes/model/workout_model.dart';
import 'package:diabetes/screens/workout_details/bloc/workout_details_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WorkoutDetailsBody extends StatelessWidget {
  final WorkoutModel workout;
  WorkoutDetailsBody({required this.workout});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: ColorConstants.white,
      child: Stack(
        children: [
          _createImage(),
          _createBackButton(context),
        ],
      ),
    );
  }

  Widget _createImage() {
    return Container(
      width: double.infinity,
      child: Image(
        image: AssetImage(workout.image ?? ""),
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _createBackButton(BuildContext context) {
    final bloc = BlocProvider.of<WorkoutDetailsBloc>(context);
    return Positioned(
      child: SafeArea(
        child: BlocBuilder<WorkoutDetailsBloc, WorkoutDetailsState>(
          builder: (context, state) {
            return GestureDetector(
              child: Container(
                width: 30,
                height: 30,
                child: Image(
                  image: AssetImage(PathConstants.back),
                ),
              ),
              onTap: () {
                bloc.add(BackTappedEvent());
              },
            );
          },
        ),
      ),
      left: 20,
      top: 14,
    );
  }
}
