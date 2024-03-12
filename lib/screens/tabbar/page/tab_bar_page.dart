import 'package:diabetes/core/const/color_constants.dart';
import 'package:diabetes/core/const/path_constants.dart';
import 'package:diabetes/core/const/text_constants.dart';
import 'package:diabetes/screens/home/page/home_page.dart';
import 'package:diabetes/screens/pill/pill_page.dart';
import 'package:diabetes/screens/setting_page/page/settings_page.dart';
import 'package:diabetes/screens/sign_in/page/sign_in_page.dart';
import 'package:diabetes/screens/tabbar/bloc/tab_bar_bloc.dart';
import 'package:diabetes/screens/workouts/page/workout_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TabBarPage extends StatefulWidget {
  const TabBarPage({Key? key}) : super(key: key);

  @override
  State<TabBarPage> createState() => _TabBarPageState();
}

class _TabBarPageState extends State<TabBarPage> {
  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const SignInPage(),
        ));
      } else {
        print('User is signed in!');
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TabBarBloc>(
      create: (BuildContext context) => TabBarBloc(),
      child: BlocConsumer<TabBarBloc, TabBarState>(
        listener: (context, state) {},
        buildWhen: (_, currState) =>
            currState is TabBarInitial || currState is TabBarItemSelectedState,
        builder: (context, state) {
          final bloc = BlocProvider.of<TabBarBloc>(context);
          return Scaffold(
            body: _createBody(context, bloc.currentIndex),
            bottomNavigationBar: _createdBottomTabBar(context),
          );
        },
      ),
    );
  }

  Widget _createdBottomTabBar(BuildContext context) {
    final bloc = BlocProvider.of<TabBarBloc>(context);
    return BottomNavigationBar(
      currentIndex: bloc.currentIndex,
      unselectedIconTheme: IconThemeData(color: Colors.grey[400]!),
      fixedColor: ColorConstants.primaryColor,
      items: [
        BottomNavigationBarItem(
          icon: Image(
            image: const AssetImage(PathConstants.home),
            color: bloc.currentIndex == 0 ? ColorConstants.primaryColor : null,
          ),
          label: TextConstants.homeIcon,
        ),
        const BottomNavigationBarItem(
          icon: Icon(
            Icons.medical_services_outlined,
          ),
          label: TextConstants.pillIcon,
        ),
        BottomNavigationBarItem(
          icon: Image(
            image: const AssetImage(PathConstants.workouts),
            color: bloc.currentIndex == 2 ? ColorConstants.primaryColor : null,
          ),
          label: TextConstants.workoutsIcon,
        ),
        BottomNavigationBarItem(
          icon: Image(
            image: const AssetImage(PathConstants.settings),
            color: bloc.currentIndex == 3 ? ColorConstants.primaryColor : null,
          ),
          label: TextConstants.settingsIcon,
        ),
      ],
      onTap: (index) {
        bloc.add(TabBarItemTappedEvent(index: index));
      },
    );
  }

  Widget _createBody(BuildContext context, int index) {
    final children = [
      const HomePage(),
      const PillPage(),
      const WorkoutsPage(),
      const SettingsPage()
    ];
    return children[index];
  }
}
