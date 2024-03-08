import 'package:firebase_auth/firebase_auth.dart';
import 'package:diabetes/model/workout_model.dart';

class UserModel {
  String? name;
  String? photo;
  String? mail;
  List<WorkoutModel>? workouts;

  UserModel({
    required this.name,
    required this.photo,
    required this.mail,
    required this.workouts,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    photo = json['photo'];
    mail = json['mail'];
    if (json['workouts'] != null) {
      List<WorkoutModel> workouts = [];
      json['workouts'].forEach((v) {
        workouts.add(new WorkoutModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['photo'] = this.photo;
    data['mail'] = this.mail;
    if (this.workouts != null) {
      data['workouts'] = this.workouts!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  static UserModel? fromFirebase(User? user) {
    return user != null
        ? UserModel(
            name: user.displayName ?? "",
            photo: user.photoURL ?? "",
            mail: user.email ?? "",
            workouts: [],
          )
        : null;
  }
}