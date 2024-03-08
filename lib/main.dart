import 'package:diabetes/core/const/color_constants.dart';
import 'package:diabetes/core/const/global_constants.dart';
import 'package:diabetes/core/service/notification_service.dart';
import 'package:diabetes/firebase_options.dart';
import 'package:diabetes/model/user_model.dart';
import 'package:flutter/services.dart';
// ignore: depend_on_referenced_packages
import 'package:timezone/data/latest.dart' as tz;
import 'package:diabetes/screens/onboarding/page/onboarding_page.dart';
import 'package:diabetes/screens/tabbar/page/tab_bar_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
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
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      NotificationService.flutterLocalNotificationsPlugin;

  @override
  initState() {
    super.initState();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    // final IOSInitializationSettings initializationSettingsIOS =
    //     IOSInitializationSettings();
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    //iOS: initializationSettingsIOS);

    tz.initializeTimeZones();

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse? notificationResponse) {
      if (notificationResponse != null) {
        showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              title: const Text("Payload"),
              content: Text("Payload : ${notificationResponse.payload}"),
            );
          },
        );
      }
    });
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
        textTheme: const TextTheme(
            bodyLarge: TextStyle(color: ColorConstants.textColor)),
        fontFamily: 'NotoSansKR',
        scaffoldBackgroundColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: isLoggedIn ? const TabBarPage() : const OnboardingPage(),
    );
  }
}
