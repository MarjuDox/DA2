import 'package:diabetes/core/const/color_constants.dart';
import 'package:diabetes/core/const/global_constants.dart';
import 'package:diabetes/core/extension/context_extension.dart';
import 'package:diabetes/core/service/notification_service.dart';
import 'package:diabetes/firebase_options.dart';
import 'package:diabetes/model/user_model.dart';
import 'package:diabetes/screens/sign_in/page/sign_in_page.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
// ignore: depend_on_referenced_packages
import 'package:timezone/data/latest.dart' as tz;
import 'package:diabetes/screens/onboarding/page/onboarding_page.dart';
import 'package:diabetes/screens/tabbar/page/tab_bar_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
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
      darkTheme: getTheme(Brightness.dark),
      theme: getTheme(Brightness.light),
      home: isLoggedIn ? const TabBarPage() : const OnboardingPage(),
    );
  }

  Future onDidReceiveNotificationResponse(NotificationResponse? payload) async {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("PayLoad"),
          content: Text("Payload : $payload"),
        );
      },
    );
  }

  ThemeData getTheme(Brightness brightness) {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: brightness,
          tertiary: const Color(0xff7AC9CD),
          primary: const Color.fromARGB(255, 76, 144, 222)),
      textTheme: const TextTheme(
        titleLarge: TextStyle(
          fontSize: 18,
        ),
      ),
      filledButtonTheme: const FilledButtonThemeData(
          style: ButtonStyle(
        padding: MaterialStatePropertyAll(
          EdgeInsets.all(18),
        ),
        shape: MaterialStatePropertyAll(RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        )),
        textStyle: MaterialStatePropertyAll(
          TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      )),
      appBarTheme: const AppBarTheme(),
      fontFamily: 'NotoSansKR',
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }
}
