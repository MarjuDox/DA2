import 'dart:io';

import 'package:diabetes/core/const/color_constants.dart';
import 'package:diabetes/core/const/path_constants.dart';
import 'package:diabetes/core/const/text_constants.dart';
import 'package:diabetes/core/extension/context_extension.dart';
import 'package:diabetes/core/service/auth_service.dart';
import 'package:diabetes/screens/chatbot/chatbot_page/chatbot_page.dart';
import 'package:diabetes/screens/common_widget/diabetes_settings_container.dart';
import 'package:diabetes/screens/edit_account/page/edit_account_page.dart';
import 'package:diabetes/screens/reminder/page/reminder_page.dart';
import 'package:diabetes/screens/setting_page/bloc/settings_bloc.dart';
import 'package:diabetes/screens/sign_in/page/sign_in_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State {
  String? photoUrl;
  String? displayName;
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _buildContext(context));
  }

  BlocProvider<SettingsBloc> _buildContext(BuildContext context) {
    return BlocProvider<SettingsBloc>(
      create: (context) => SettingsBloc(),
      child: BlocConsumer<SettingsBloc, SettingsState>(
        buildWhen: (_, currState) => currState is SettingsInitial,
        builder: (context, state) {
          final bloc = BlocProvider.of<SettingsBloc>(context);
          if (state is SettingsInitial) {
            bloc.add(SettingsReloadDisplayNameEvent());
            bloc.add(SettingsReloadImageEvent());
          }
          return _settingsContent(context);
        },
        listenWhen: (_, currState) => true,
        listener: (context, state) {},
      ),
    );
  }

  Widget _settingsContent(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    displayName = user?.displayName ?? "No Username";
    photoUrl = user?.photoURL;
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
          child: Column(children: [
            Stack(alignment: Alignment.topRight, children: [
              Center(
                child: photoUrl?.isEmpty ?? true
                    ? const CircleAvatar(
                        backgroundImage: AssetImage(PathConstants.profile),
                        radius: 60)
                    : CircleAvatar(
                        radius: 60,
                        child: ClipOval(
                            child: FadeInImage.assetNetwork(
                          placeholder: PathConstants.profile,
                          image: photoUrl!,
                          fit: BoxFit.cover,
                          width: 200,
                          height: 120,
                        )),
                      ),
              ),
              TextButton(
                onPressed: () async {
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const EditAccountScreen()));
                  setState(() {
                    photoUrl = user?.photoURL;
                    displayName = user?.displayName;
                  });
                },
                style: TextButton.styleFrom(
                  shape: const CircleBorder(),
                  backgroundColor:
                      context.colorScheme.secondaryContainer.withOpacity(
                    0.4,
                  ),
                ),
                child: const Icon(
                  Icons.edit,
                  // color: ColorConstants.primaryColor,
                ),
              ),
            ]),
            const SizedBox(height: 15),
            Text(
              displayName ?? 'No Username',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            SettingsContainer(
              withArrow: true,
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const ReminderPage()));
              },
              child: const Text(TextConstants.reminder,
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500)),
            ),
            SettingsContainer(
              withArrow: true,
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const ChatBotPage()));
              },
              child: const Text(TextConstants.chatBot,
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500)),
            ),
            if (!kIsWeb)
              SettingsContainer(
                child: Text(
                    '${TextConstants.rateUsOn}${Platform.isIOS ? 'App store' : 'Play market'}',
                    style: const TextStyle(
                        fontSize: 17, fontWeight: FontWeight.w500)),
                onTap: () {
                  return launch(Platform.isIOS
                      ? 'https://www.apple.com/app-store/'
                      : 'https://play.google.com/store');
                },
              ),
            // SettingsContainer(
            //     onTap: () => launch('https://perpet.io/'),
            //     child: Text(TextConstants.terms,
            //         style:
            //             TextStyle(fontSize: 17, fontWeight: FontWeight.w500))),
            SettingsContainer(
                child: const Text(TextConstants.signOut,
                    style:
                        TextStyle(fontSize: 17, fontWeight: FontWeight.w500)),
                onTap: () {
                  AuthService.signOut();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (_) => const SignInPage()));
                }),
            const SizedBox(height: 15),
            const Text(TextConstants.joinUs,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                    onPressed: () => launch('https://www.facebook.com/'),
                    style: TextButton.styleFrom(
                        shape: const CircleBorder(),
                        backgroundColor: Colors.white,
                        elevation: 1),
                    child: Image.asset(PathConstants.facebook)),
                TextButton(
                    onPressed: () => launch('https://www.instagram.com/'),
                    style: TextButton.styleFrom(
                        shape: const CircleBorder(),
                        backgroundColor: Colors.white,
                        elevation: 1),
                    child: Image.asset(PathConstants.instagram)),
                TextButton(
                    onPressed: () => launch('https://twitter.com'),
                    style: TextButton.styleFrom(
                        shape: const CircleBorder(),
                        backgroundColor: Colors.white,
                        elevation: 1),
                    child: Image.asset(PathConstants.twitter)),
              ],
            )
          ]),
        ),
      ),
    );
  }
}
