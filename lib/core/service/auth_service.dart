import 'dart:convert';

import 'package:diabetes/core/const/global_constants.dart';
import 'package:diabetes/core/extentions/exceptions.dart';
import 'package:diabetes/core/service/user_storage_service.dart';
import 'package:diabetes/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static final FirebaseAuth auth = FirebaseAuth.instance;

  static Future<User> signUp(String email, String password, String name) async {
    UserCredential result = await auth.createUserWithEmailAndPassword(
        email: email.trim(), password: password.trim());
    final User user = result.user!;
    await user.updateDisplayName(name);

    final userModel = UserModel.fromFirebase(auth.currentUser);
    await UserStorageService.writeSecureData(email, jsonEncode(userModel));
    GlobalConstants.currentUser = userModel;

    return user;
  }

  static Future resetPassword(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
      return true;
    } on FirebaseAuthException catch (e) {
      throw CustomFirebaseException(getExceptionMessage(e));
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<User?> signIn(String email, String password) async {
    try {
      final UserCredential result = await auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      final User? user = result.user;

      if (user == null) {
        throw Exception("User not found");
      } else {
        final userFromLocal = await UserStorageService.readSecureData(email);
        final userModel = UserModel.fromFirebase(auth.currentUser);
        if (userFromLocal == null) {
          await UserStorageService.writeSecureData(
              email, jsonEncode(userModel));
        }
        GlobalConstants.currentUser = userModel;
      }

      return user;
    } on FirebaseAuthException catch (e) {
      throw CustomFirebaseException(getExceptionMessage(e));
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<void> signOut() async {
    await auth.signOut();
  }
}

String getExceptionMessage(FirebaseAuthException e) {
  print(e.code);
  switch (e.code) {
    case 'user-not-found':
      return 'User not found';
    case 'wrong-password':
      return 'Password is incorrect';
    case 'requires-recent-login':
      return 'Log in again before retrying this request';
    default:
      return e.message ?? 'Error';
  }
}
