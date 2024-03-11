import 'package:bloc/bloc.dart';
import 'package:diabetes/core/const/data_constants.dart';
import 'package:diabetes/core/service/auth_service.dart';
import 'package:diabetes/core/service/data_service.dart';
import 'package:diabetes/core/service/user_storage_service.dart';
import 'package:diabetes/model/exercise_model.dart';
import 'package:diabetes/model/workout_model.dart';
import 'package:flutter/material.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial());

  List<WorkoutModel> workouts = <WorkoutModel>[];
  List<ExerciseModel> exercises = <ExerciseModel>[];
  int timeSent = 0;

  @override
  Stream<HomeState> mapEventToState(
    HomeEvent event,
  ) async* {
    if (event is HomeInitialEvent) {
      workouts = await DataService.getWorkoutsForUser();
      yield WorkoutsGotState(workouts: workouts);
    } else if (event is ReloadImageEvent) {
      String? photoURL = AuthService.auth.currentUser?.photoURL;
      yield ReloadImageState(photoURL: photoURL);
    } else if (event is ReloadDisplayNameEvent) {
      final displayName = await UserStorageService.readSecureData('name');
      yield ReloadDisplayNameState(displayName: displayName);
    }
  }

  int getProgressPercentage() {
    final completed = workouts
        .where((w) =>
            (w.currentProgress ?? 0) > 0 && w.currentProgress == w.progress)
        .toList();
    final percent01 =
        completed.length.toDouble() / DataConstants.workouts.length.toDouble();
    final percent = (percent01 * 100).toInt();
    return percent;
  }

  int? getFinishedWorkouts() {
    final completedWorkouts =
        workouts.where((w) => w.currentProgress == w.progress).toList();
    return completedWorkouts.length;
  }

  int? getInProgressWorkouts() {
    final completedWorkouts = workouts.where(
        (w) => (w.currentProgress ?? 0) > 0 && w.currentProgress != w.progress);
    return completedWorkouts.length;
  }

  int? getTimeSent() {
    for (final WorkoutModel workout in workouts) {
      exercises.addAll(workout.exerciseDataList!);
    }
    final exercise = exercises.where((e) => e.progress == 1).toList();
    for (var e in exercise) {
      timeSent += e.minutes!;
    }
    return timeSent;
  }
}
