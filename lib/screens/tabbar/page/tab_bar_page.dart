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
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

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
    return NavigationBar(
      selectedIndex: bloc.currentIndex,
      onDestinationSelected: (index) {
        bloc.add(TabBarItemTappedEvent(index: index));
      },
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      destinations: [
        NavigationDestination(
            selectedIcon: Icon(MdiIcons.homeVariant),
            icon: Icon(MdiIcons.homeVariantOutline),
            label: 'Home'),
        NavigationDestination(icon: Icon(MdiIcons.pillMultiple), label: 'Pill'),
        NavigationDestination(
            icon: Icon(MdiIcons.weightLifter), label: 'Workout'),
        NavigationDestination(
            selectedIcon: Icon(MdiIcons.account),
            icon: Icon(MdiIcons.accountOutline),
            label: 'Pill'),
      ],
    );
  }

  Widget _createBody(BuildContext context, int index) {
    final children = [
      const HomePage(),
      const PillPage(),
      const WorkoutsPage(),
      const SettingsPage(),
      const SettingsPage()
    ];
    return children[index];
  }
}
