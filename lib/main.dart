import 'package:diabetes/core/const/color_constants.dart';
import 'package:diabetes/core/const/global_constants.dart';
import 'package:diabetes/core/service/notification_service.dart';
import 'package:diabetes/model/user_model.dart';
// ignore: depend_on_referenced_packages
import 'package:timezone/data/latest.dart' as tz;
import 'package:diabetes/screens/onboarding/page/onboarding_page.dart';
import 'package:diabetes/screens/tabbar/page/tab_bar_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// void main() async{
//   WidgetsFlutterBinding.ensureInitialized();
//   SystemChrome.setPreferredOrientations([
//     DeviceOrientation.portraitUp,
//     DeviceOrientation.portraitDown,
//   ]);
//   await Firebase.initializeApp();
//   runApp(MainApp());
// }

// class MainApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final isLoggedIn = FirebaseAuth.instance.currentUser != null;

//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Diabetes',
//       theme: ThemeData(
//         textTheme:
//           const TextTheme(bodyText1: TextStyle(color: ColorConstants.textColor)),
//         fontFamily: 'NotoSansKR',
//         scaffoldBackgroundColor: Colors.white,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//      ),
//      home: isLoggedIn ? const TabBarPage() : OnboardingPage(),
//    );
//   }
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State {
  static late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      NotificationService.flutterLocalNotificationsPlugin;

  @override
  initState() {
    super.initState();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    // final IOSInitializationSettings initializationSettingsIOS =
    //     IOSInitializationSettings();
    const InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid);
            //iOS: initializationSettingsIOS);

    tz.initializeTimeZones();

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);
  }

  @override
  Widget build(BuildContext context) {
    final currUser = FirebaseAuth.instance.currentUser;
    final isLoggedIn = currUser != null;
    if (isLoggedIn) {
      GlobalConstants.currentUser = UserModel.fromFirebase(currUser);
    }
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Diabetes',
      theme: ThemeData(
        textTheme:
            TextTheme(bodyText1: TextStyle(color: ColorConstants.textColor)),
        fontFamily: 'NotoSansKR',
        scaffoldBackgroundColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: isLoggedIn ? TabBarPage() : OnboardingPage(),
    );
  }

  Future onDidReceiveNotificationResponse(NotificationResponse? payload) async {
  showDialog(
    context: context,
    builder: (_) {
      return new AlertDialog(
        title: Text("Payload"),
        content: Text("Payload : $payload"),
      );
    },
  );
}
}
