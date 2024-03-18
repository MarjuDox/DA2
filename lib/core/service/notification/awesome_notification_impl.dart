import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:awesome_notifications_fcm/awesome_notifications_fcm.dart';
import 'package:flutter/material.dart';
import 'day_of_week_enum.dart';
import 'notification_constants.dart';
import 'notification_manager.dart';
import 'notification_model.dart';

class AwesomeNotificationImpl extends NotificationManager
    implements NotificationModelAdapter<NotificationModel> {
  final String? key;

  AwesomeNotificationImpl({required this.key});

  final _noti = AwesomeNotifications();
  final primaryColor = Colors.blue;

  @override
  void createNotification(int id,
      {required String title,
      required String body,
      required String channelKey}) {
    _noti.createNotification(
        content: NotificationContent(
      color: primaryColor,
      id: id,
      channelKey: channelKey,
      wakeUpScreen: true,
      criticalAlert: true,
      actionType: ActionType.Default,
      title: title,
      body: body,
    ));
    print('Create notification');
  }

  @override
  Future<bool> createSchedulednotification(int id,
      {required List<DayOfWeekEnum> dayOfWeeks,
      required TimeOfDay timeOfDay,
      required String title,
      required String body,
      required String channelKey}) async {
    final createResult = await Future.wait(dayOfWeeks.map((dayOfWeek) {
      return _noti.createNotification(
          schedule: NotificationCalendar(
            weekday: dayOfWeek.index,
            hour: timeOfDay.hour,
            minute: timeOfDay.minute,
          ),
          content: NotificationContent(
            color: const Color.fromARGB(255, 106, 106, 106),
            id: dayOfWeek.index,
            channelKey: channelKey,
            actionType: ActionType.Default,
            title: title,
            body: body,
          ));
    }).toList());

    if (createResult.contains(false)) return false;
    print('created scheduled notification');
    return true;
  }

  @override
  Future<void> cancelAllSchedulednotification({required String channelKey}) {
    print('Cancel all scheduled notifications');
    return _noti.cancelNotificationsByChannelKey(channelKey);
  }

  @override
  void askPermission() async {
    await AwesomeNotifications().requestPermissionToSendNotifications(
        // channelKey: channelKey,
        // permissions: lockedPermissions

        );
  }

  @override
  Future<List<FNotificationModel>> getListScheduledNotification() async {
    final scheduledNotis = await _noti.listScheduledNotifications();
    return scheduledNotis.map((e) => parse(e)).toList();
  }

  final _notiFCM = AwesomeNotificationsFcm();

  Future<void> initializeRemoteNotifications({required bool debug}) async {
    List<String>? licenseKeys;
    if (key != null) licenseKeys = [key!];
    print('AwesomeNoticationKey = $key');
    final notiFCMInitializeResult = await _notiFCM.initialize(
        onFcmTokenHandle: NotificationController.myFcmTokenHandle,
        onNativeTokenHandle: NotificationController.myNativeTokenHandle,
        onFcmSilentDataHandle: NotificationController.mySilentDataHandle,
        licenseKeys: licenseKeys,
        debug: debug);

    print('Notification FCM initialize v4: $notiFCMInitializeResult');

    final token = await getFirebaseToken();
    print('Token Firebase: '+token.toString());
  }

  // Request FCM token to Firebase

  @override
  Future<String?> getFirebaseToken() async {
    const getFirebaseMessagingTokenTag = 'getFirebaseMessagingToken';

    String? firebaseAppToken;
    if (await _notiFCM.isFirebaseAvailable) {
      try {
        firebaseAppToken = await _notiFCM.requestFirebaseAppToken();
      } catch (exception) {
        print(exception);
      }
    } else {
      print('Firebase is not available on this project');
    }
    return firebaseAppToken;
  }

  @override
  Future<void> init() async {
    final awesomeNotificationInitialize = await AwesomeNotifications().initialize(
      NotificationConstants.logo,
      NotificationConstants.channels,
      debug: true,
    );

    print('AwesomeNotification initialize: $awesomeNotificationInitialize');
    await initializeRemoteNotifications(debug: true);
  }

  @override
  FNotificationModel parse(model) {
    return FNotificationModel(
        title: model.content?.title ?? '',
        body: model.content?.body ?? '',
        id: model.content?.id ?? DEFAULT_ERROR_ID);
  }
}

class NotificationController extends ChangeNotifier {
  static final NotificationController _instance =
      NotificationController._internal();

  factory NotificationController() {
    return _instance;
  }

  NotificationController._internal();

  /// *********************************************
  ///  OBSERVER PATTERN
  /// *********************************************

  String _firebaseToken = '';

  String get firebaseToken => _firebaseToken;

  String _nativeToken = '';

  String get nativeToken => _nativeToken;

  ///  *********************************************
  ///     REMOTE NOTIFICATION EVENTS
  ///  *********************************************

  /// Use this method to execute on background when a silent data arrives
  /// (even while terminated)
  @pragma("vm:entry-point")
  static Future<void> mySilentDataHandle(FcmSilentData silentData) async {
    print('"SilentData": ${silentData.toString()}');

    if (silentData.createdLifeCycle != NotificationLifeCycle.Foreground) {
      print("bg");
    } else {
      print("FOREGROUND");
    }

    print("starting long task");
    await Future.delayed(Duration(seconds: 4));
    print("long task done");
  }

  /// Use this method to detect when a new fcm token is received
  @pragma("vm:entry-point")
  static Future<void> myFcmTokenHandle(String token) async {
    const nameFunc = 'myFcmTokenHandle';
    if (token.isNotEmpty) {
      // Globals.app.showToast('Fcm token received');
      // debugPrint('Firebase Token:"$token"');
      print('Fcm token received');
    } else {
      print('Fcm token deleted');
      // Globals.app.showToast('Fcm token deleted');
      // debugPrint('Firebase Token deleted');
    }

    _instance._firebaseToken = token;
    _instance.notifyListeners();
  }

  /// Use this method to detect when a new native token is received
  @pragma("vm:entry-point")
  static Future<void> myNativeTokenHandle(String token) async {
    // Globals.app.showToast('Native token received');
    // debugPrint('Native Token:"$token"');
    print('Native Token: "$token"');
    _instance._nativeToken = token;
    _instance.notifyListeners();
  }

  ///  *********************************************
  ///     BACKGROUND TASKS TEST
  ///  *********************************************

  static Future<void> executeLongTaskInBackground() async {
    // print("starting long task");
    print('executeLongTaskInBackground');
    // await Future.delayed(const Duration(seconds: 4));
    // final url = Uri.parse("http://google.com");
    // final re = await http.get(url);
    // print(re.body);
    // print("long task done");
  }
}
