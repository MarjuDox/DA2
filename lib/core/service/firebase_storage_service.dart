import 'dart:io';
import 'package:diabetes/core/service/user_service.dart';
import 'package:diabetes/model/pill_schedule/pill_schedule_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageService {
  FirebaseStorage storage = FirebaseStorage.instance;
  static Future<void> listExample() async {
    ListResult result = await FirebaseStorage.instance.ref().listAll();
    for (var element in result.items) {
      print(element.name);
    }
  }

  static Future<bool> uploadImage({required String filePath}) async {
    File file = File(filePath);
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final upload = await FirebaseStorage.instance
            .ref()
            .child('users/${user.uid}/avatar')
            .putFile(file);
        String downloadUrl = await upload.ref.getDownloadURL();
        await UserService.editPhoto(downloadUrl);
        return true;
      }
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
