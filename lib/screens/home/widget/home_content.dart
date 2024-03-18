import 'package:diabetes/core/const/color_constants.dart';
import 'package:diabetes/core/const/data_constants.dart';
import 'package:diabetes/core/const/path_constants.dart';
import 'package:diabetes/core/const/text_constants.dart';
import 'package:diabetes/core/extension/context_extension.dart';
import 'package:diabetes/model/workout_model.dart';
import 'package:diabetes/screens/common_widget/diabetes_button.dart';
import 'package:diabetes/screens/edit_account/page/edit_account_page.dart';
import 'package:diabetes/screens/home/bloc/home_bloc.dart';
import 'package:diabetes/screens/home/widget/home_exercises_card.dart';
import 'package:diabetes/screens/home/widget/home_statistics.dart';
import 'package:diabetes/screens/home/widget/home_today_pill.dart';
import 'package:diabetes/screens/tabbar/bloc/tab_bar_bloc.dart';
import 'package:diabetes/screens/workout_details/page/workout_details_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeContent extends StatelessWidget {
  final List<WorkoutModel> workouts;

  const HomeContent({
    Key? key,
    required this.workouts,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _createHomeBody(context);
  }

  Widget _createHomeBody(BuildContext context) {
    final bloc = BlocProvider.of<HomeBloc>(context);
    return ColoredBox(
      color: context.colorScheme.primary,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(
              height: 16,
            ),
            _createProfileData(context),
            const SizedBox(height: 35),
            // _showStartWorkout(context, bloc),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(top: 6),
                margin: const EdgeInsets.only(top: 20),
                decoration: ShapeDecoration(
                  color: context.colorScheme.background,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(30),
                    ),
                  ),
                ),
                child: ColoredBox(
                    color: context.colorScheme.surfaceVariant.withOpacity(0.1),
                    child: const HomeTodayPill()),
              ),
            ),
          ],
        ),
      ),
    );
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        children: [
          _createProfileData(context),
          const SizedBox(height: 35),
          _showStartWorkout(context, bloc),
          const SizedBox(height: 30),
          _createExercisesList(context),
          const SizedBox(height: 25),
          _showProgress(bloc),
        ],
      ),
    );
  }

  Widget _createProfileData(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocBuilder<HomeBloc, HomeState>(
                buildWhen: (_, currState) =>
                    currState is ReloadDisplayNameState,
                builder: (context, state) {
                  final displayName =
                      state is ReloadDisplayNameState ? state.displayName : '';
                  return Text(
                    'Hi, $displayName',
                    style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w500,
                        color: context.colorScheme.onPrimary),
                  );
                },
              ),
              const SizedBox(height: 2),
              Text(
                TextConstants.checkActivity,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color: context.colorScheme.onPrimary),
              ),
            ],
          ),
          BlocBuilder<HomeBloc, HomeState>(
            buildWhen: (_, currState) => currState is ReloadImageState,
            builder: (context, state) {
              final photoURL =
                  state is ReloadImageState ? state.photoURL : null;
              return GestureDetector(
                child: photoURL == null
                    ? const CircleAvatar(
                        backgroundImage: AssetImage(PathConstants.profile),
                        radius: 25)
                    : CircleAvatar(
                        radius: 25,
                        child: ClipOval(
                            child: FadeInImage.assetNetwork(
                                placeholder: PathConstants.profile,
                                image: photoURL,
                                fit: BoxFit.cover,
                                width: 200,
                                height: 120))),
                onTap: () async {
                  await Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => const EditAccountScreen()));
                  BlocProvider.of<HomeBloc>(context).add(ReloadImageEvent());
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _showStartWorkout(BuildContext context, HomeBloc bloc) {
    return workouts.isEmpty
        ? _createStartWorkout(context, bloc)
        : const HomeStatistics();
  }

  Widget _createStartWorkout(BuildContext context, HomeBloc bloc) {
    final blocTabBar = BlocProvider.of<TabBarBloc>(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: ColorConstants.white,
        boxShadow: [
          BoxShadow(
            color: context.colorScheme.shadow.withOpacity(0.12),
            blurRadius: 5.0,
            spreadRadius: 1.1,
          )
        ],
      ),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: AssetImage(PathConstants.light),
                width: 24,
                height: 24,
              ),
              SizedBox(width: 10),
              Text(TextConstants.didYouKnow,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500))
            ],
          ),
          const SizedBox(height: 16),
          const Text(TextConstants.sportActivity,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          const Text(TextConstants.signToStart,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: ColorConstants.textGrey)),
          const SizedBox(height: 24),
          DiabetesButton(
            title: TextConstants.startWorkout,
            onTap: () {
              blocTabBar.add(
                  TabBarItemTappedEvent(index: blocTabBar.currentIndex = 2));
            },
          ),
        ],
      ),
    );
  }

  Widget _createExercisesList(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            TextConstants.discoverWorkouts,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 15),
        SizedBox(
          height: 160,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              const SizedBox(width: 20),
              WorkoutCard(
                color: ColorConstants.cardioColor,
                workout: DataConstants.workouts[0],
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => WorkoutDetailsPage(
                      workout: DataConstants.workouts[0],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              // WorkoutCard(
              //   //color: ColorConstants.armsColor,
              //   workout: DataConstants.workouts[1],
              //   // onTap: () => Navigator.of(context).push(
              //   //   MaterialPageRoute(
              //   //     builder: (_) => WorkoutDetailsPage(
              //   //       workout: DataConstants.workouts[2],
              //   //     ),
              //   //   ),
              //   // ),
              // ),
              // const SizedBox(width: 20),
            ],
          ),
        ),
      ],
    );
  }

  Widget _showProgress(HomeBloc bloc) {
    return workouts.isNotEmpty ? _createProgress(bloc) : Container();
  }

  Widget _createProgress(HomeBloc bloc) {
    return Builder(builder: (context) {
      return Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: ColorConstants.white,
          boxShadow: [
            BoxShadow(
              color: context.colorScheme.shadow.withOpacity(0.12),
              blurRadius: 5.0,
              spreadRadius: 1.1,
            ),
          ],
        ),
        child: Row(
          children: [
            const Image(image: AssetImage(PathConstants.progress)),
            const SizedBox(width: 20),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(TextConstants.keepProgress,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 3),
                  Text(
                    '${TextConstants.profileSuccessful} ${bloc.getProgressPercentage()}% of workouts.',
                    style: const TextStyle(fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
