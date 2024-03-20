import 'package:diabetes/screens/food/search/cubit/search_page_cubit.dart';
import 'package:diabetes/screens/food/search/page/search_page.dart';
import 'package:diabetes/screens/home/page/home_page.dart';
import 'package:diabetes/screens/pill/pill_page.dart';
import 'package:diabetes/screens/setting_page/page/settings_page.dart';
import 'package:diabetes/screens/sign_in/page/sign_in_page.dart';
import 'package:diabetes/screens/tabbar/bloc/tab_bar_bloc.dart';
import 'package:diabetes/screens/workouts/page/workout_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
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

  final int _selectedIndex = 0;
  NavigationRailLabelType labelType = NavigationRailLabelType.all;
  bool showLeading = false;
  bool showTrailing = false;
  double groupAlignment = -1.0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraint) {
      return BlocProvider<TabBarBloc>(
        create: (BuildContext context) => TabBarBloc(),
        child: BlocConsumer<TabBarBloc, TabBarState>(
          listener: (context, state) {},
          buildWhen: (_, currState) =>
              currState is TabBarInitial ||
              currState is TabBarItemSelectedState,
          builder: (context, state) {
            final bloc = BlocProvider.of<TabBarBloc>(context);
            return Scaffold(
              body: Row(
                children: [
                  if (constraint.maxWidth >= 900)
                    NavigationRail(
                      groupAlignment: groupAlignment,
                      selectedIndex: bloc.currentIndex,
                      onDestinationSelected: (index) {
                        bloc.add(TabBarItemTappedEvent(index: index));
                      },
                      labelType: labelType,
                      leading: showLeading
                          ? FloatingActionButton(
                              elevation: 0,
                              onPressed: () {
                                // Add your onPressed code here!
                              },
                              child: const Icon(Icons.add),
                            )
                          : const SizedBox(),
                      trailing: showTrailing
                          ? IconButton(
                              onPressed: () {
                                // Add your onPressed code here!
                              },
                              icon: const Icon(Icons.more_horiz_rounded),
                            )
                          : const SizedBox(),
                      destinations: const <NavigationRailDestination>[
                        NavigationRailDestination(
                            selectedIcon: Icon(FluentIcons.home_24_filled),
                            icon: Icon(FluentIcons.home_24_regular),
                            label: Text('Home')),
                        NavigationRailDestination(
                            selectedIcon: Icon(FluentIcons.pill_24_filled),
                            icon: Icon(FluentIcons.pill_24_regular),
                            label: Text('Schedule')),
                        NavigationRailDestination(
                            selectedIcon:
                                Icon(FluentIcons.accessibility_20_filled),
                            icon: Icon(FluentIcons.accessibility_24_regular),
                            label: Text('Workout')),
                        NavigationRailDestination(
                            selectedIcon: Icon(FluentIcons.food_24_filled),
                            icon: Icon(FluentIcons.food_24_regular),
                            label: Text('Food')),
                        NavigationRailDestination(
                            selectedIcon: Icon(FluentIcons.settings_24_filled),
                            icon: Icon(FluentIcons.settings_24_regular),
                            label: Text('Setting')),
                      ],
                    ),
                  const VerticalDivider(thickness: 1, width: 1),
                  Expanded(child: _createBody(context, bloc.currentIndex)),
                ],
              ),
              bottomNavigationBar: constraint.maxWidth < 900
                  ? _createdBottomTabBar(context)
                  : null,
            );
          },
        ),
      );
    });
  }

  Widget _createdBottomTabBar(BuildContext context) {
    final bloc = BlocProvider.of<TabBarBloc>(context);
    return NavigationBar(
      selectedIndex: bloc.currentIndex,
      onDestinationSelected: (index) {
        bloc.add(TabBarItemTappedEvent(index: index));
      },
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      destinations: const [
        NavigationDestination(
            selectedIcon: Icon(FluentIcons.home_24_filled),
            icon: Icon(FluentIcons.home_24_regular),
            label: 'Home'),
        NavigationDestination(
            selectedIcon: Icon(FluentIcons.pill_24_filled),
            icon: Icon(FluentIcons.pill_24_regular),
            label: 'Schedule'),
        NavigationDestination(
            selectedIcon: Icon(FluentIcons.accessibility_20_filled),
            icon: Icon(FluentIcons.accessibility_24_regular),
            label: 'Workout'),
        NavigationDestination(
            selectedIcon: Icon(FluentIcons.food_24_filled),
            icon: Icon(FluentIcons.food_24_regular),
            label: 'Food'),
        NavigationDestination(
            selectedIcon: Icon(FluentIcons.settings_24_filled),
            icon: Icon(FluentIcons.settings_24_regular),
            label: 'Setting'),
      ],
    );
  }

  Widget _createBody(BuildContext context, int index) {
    final children = [
      const HomePage(),
      const SchedulePage(),
      const WorkoutsPage(),
      BlocProvider(
        create: (context) => SearchPageCubit(),
        child: const SearchPage(),
      ), // Search Page
      const SettingsPage()
    ];
    return children[index];
  }
}
