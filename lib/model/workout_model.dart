import 'dart:convert';

import 'package:diabetes/model/exercise_model.dart';

class WorkoutModel {
  String? id;
  String? title;
  String? exercises;
  String? minutes;
  int? currentProgress;
  int? progress;
  String? image;
  List<ExerciseModel>? exerciseDataList;

  WorkoutModel({
    required this.id,
    required this.title,
    required this.exercises,
    required this.minutes,
    required this.currentProgress,
    required this.progress,
    required this.image,
    required this.exerciseDataList,
  });

  WorkoutModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    exercises = json['exercises'];
    minutes = json['minutes'];
    currentProgress = json['currentProgress'];
    progress = json['progress'];
    image = json['image'];
    if (json['exerciseDataList'] != null) {
      List<ExerciseModel> exercises = [];
      json['exerciseDataList'].forEach((v) {
        exercises.add(ExerciseModel.fromJson(v));
      });
      exerciseDataList = exercises;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['exercises'] = this.exercises;
    data['minutes'] = this.minutes;
    data['currentProgress'] = this.currentProgress;
    data['progress'] = this.progress;
    data['image'] = this.image;
    if (this.exerciseDataList != null) {
      data['exerciseDataList'] =
          this.exerciseDataList!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  String toJsonString() {
    final str = json.encode(this.toJson());
    return str;
  }
}