import 'package:bloc/bloc.dart';
import 'package:diabetes/model/workout_model.dart';
import 'package:flutter/material.dart';

part 'workout_details_event.dart';
part 'workout_details_state.dart';

class WorkoutDetailsBloc
    extends Bloc<WorkoutDetailsEvent, WorkoutDetailsState> {
  WorkoutDetailsBloc() : super(WorkoutDetailsInitial());

  late WorkoutModel workout;

  @override
  Stream<WorkoutDetailsState> mapEventToState(
    WorkoutDetailsEvent event,
  ) async* {
    if (event is WorkoutDetailsInitialEvent) {
      workout = event.workout;
      yield ReloadWorkoutDetailsState(workout: workout);
    } else if (event is BackTappedEvent) {
      yield BackTappedState();
    } else if (event is StartTappedEvent) {
      yield StartTappedState(
        workout: event.workout ?? workout,
        index: event.index ?? 0,
        isReplace: event.isReplace,
      );
    }
  }
}