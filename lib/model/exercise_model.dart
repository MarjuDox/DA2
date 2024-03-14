import 'dart:convert';

class ExerciseModel {
  String? id;
  String? title;
  int? minutes;
  int? seconds;
  double? progress;
  String? video;
  String? description;
  List<String>? steps;

  ExerciseModel({
    required this.id,
    required this.title,
    required this.minutes,
    required this.seconds,
    required this.progress,
    required this.video,
    required this.description,
    required this.steps,
  });

  ExerciseModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    minutes = json['minutes'];
    seconds = json['seconds'];
    progress = json['progress'];
    video = json['video'];
    description = json['description'];
    steps = json['steps'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['minutes'] = this.minutes;
    data['seconds'] = this.seconds;
    data['progress'] = this.progress;
    data['video'] = this.video;
    data['description'] = this.description;
    data['steps'] = this.steps;
    return data;
  }

  String toJsonString() {
    final str = json.encode(this.toJson());
    return str;
  }
}