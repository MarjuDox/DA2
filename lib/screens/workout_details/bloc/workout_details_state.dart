part of 'workout_details_bloc.dart';

@immutable
sealed class WorkoutDetailsState {}

final class WorkoutDetailsInitial extends WorkoutDetailsState {}

class BackTappedState extends WorkoutDetailsState {}

class WorkoutExerciseCellTappedState extends WorkoutDetailsState {
  final WorkoutModel workout;
  final int index;

  WorkoutExerciseCellTappedState({
    required this.workout,
    required this.index,
  });
}

class ReloadWorkoutDetailsState extends WorkoutDetailsState {
  final WorkoutModel workout;

  ReloadWorkoutDetailsState({
    required this.workout,
  });
}

class StartTappedState extends WorkoutDetailsState {
  final WorkoutModel workout;
  final int index;
  final bool isReplace;

  StartTappedState({
    required this.workout,
    required this.index,
    required this.isReplace,
  });
}