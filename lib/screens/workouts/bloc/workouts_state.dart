part of 'workouts_bloc.dart';

@immutable
sealed class WorkoutsState {}

final class WorkoutsInitial extends WorkoutsState {}

class CardTappedState extends WorkoutsState {
  final WorkoutModel workout;

  CardTappedState({required this.workout});
}

class ReloadWorkoutsState extends WorkoutsState {
  final List<WorkoutModel> workouts;

  ReloadWorkoutsState({
    required this.workouts,
  });
}
