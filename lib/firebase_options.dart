// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBV8HXufyL2kw16Pqcn6TGFBkg-S6VvCWU',
    appId: '1:482540848886:web:9c9db8cc9c3e68e5558ed7',
    messagingSenderId: '482540848886',
    projectId: 'diabetes-82089',
    authDomain: 'diabetes-82089.firebaseapp.com',
    storageBucket: 'diabetes-82089.appspot.com',
    measurementId: 'G-NJGK0ND39J',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC-KXzjN0Nls0loL2Mpk3Gp4F8mdNTaMhI',
    appId: '1:482540848886:android:86bb4da700d06e0c558ed7',
    messagingSenderId: '482540848886',
    projectId: 'diabetes-82089',
    storageBucket: 'diabetes-82089.appspot.com',
  );
}