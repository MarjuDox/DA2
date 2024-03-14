import 'dart:core';

import 'package:diabetes/model/pill_schedule/pill_schedule_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class FirebaseDatabaseService {
  static Future<List<PillScheduleModel>> getUserSchedule() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      CollectionReference schedules =
          FirebaseFirestore.instance.collection('schedules');
      final result = await schedules.where('userId', isEqualTo: user.uid).get();
      return result.docs
          .map((e) => e.data())
          .whereType<Map<String, dynamic>>()
          .map(PillScheduleModel.fromMap)
          .toList();
    }
    return [];
  }

  static Future<void> addUserSchedule(PillScheduleModel schedule) async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      CollectionReference schedules =
          FirebaseFirestore.instance.collection('schedules');
      await schedules.doc(schedule.uid).set(schedule.toMap());
    }
  }
}
