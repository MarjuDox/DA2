import 'dart:convert';

import 'package:diabetes/core/const/Global_constants.dart';
import 'package:diabetes/core/service/user_storage_service.dart';
import 'package:diabetes/model/workout_model.dart';

class DataService {
  static Future<List<WorkoutModel>> getWorkoutsForUser() async {
    final currUserEmail = GlobalConstants.currentUser.mail;

    // await UserStorageService.deleteSecureData('${currUserEmail}Workouts');

    final workoutsStr =
        await UserStorageService.readSecureData('${currUserEmail}Workouts');
    if (workoutsStr == null) return [];
    final decoded = (json.decode(workoutsStr) as List?) ?? [];
    final workouts = decoded.map((e) {
      final decodedE = json.decode(e) as Map<String, dynamic>?;
      return WorkoutModel.fromJson(decodedE!);
    }).toList();
    GlobalConstants.workouts = workouts;
    return workouts;
  }

  static Future<void> saveWorkout(WorkoutModel workout) async {
    final allWorkouts = await getWorkoutsForUser();
    final index = allWorkouts.indexWhere((w) => w.id == workout.id);
    if (index != -1) {
      allWorkouts[index] = workout;
    } else {
      allWorkouts.add(workout);
    }
    GlobalConstants.workouts = allWorkouts;
    final workoutsStr = allWorkouts.map((e) => e.toJsonString()).toList();
    final encoded = json.encode(workoutsStr);
    final currUserEmail = GlobalConstants.currentUser.mail;
    await UserStorageService.writeSecureData(
      '${currUserEmail}Workouts',
      encoded,
    );
  }
}