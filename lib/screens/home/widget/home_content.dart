import 'package:diabetes/core/common_widget/base_screen.dart';
import 'package:diabetes/core/const/color_constants.dart';
import 'package:diabetes/core/const/data_constants.dart';
import 'package:diabetes/core/const/path_constants.dart';
import 'package:diabetes/core/const/text_constants.dart';
import 'package:diabetes/core/extension/context_extension.dart';
import 'package:diabetes/core/extension/datetime_extension.dart';
import 'package:diabetes/core/service/firebase_database_service.dart';
import 'package:diabetes/model/pill_schedule/pill_schedule_model.dart';
import 'package:diabetes/model/workout_model.dart';
import 'package:diabetes/screens/common_widget/card_x.dart';
import 'package:diabetes/screens/common_widget/diabetes_button.dart';
import 'package:diabetes/screens/common_widget/shimmerx.dart';
import 'package:diabetes/screens/common_widget/text_shimmerable.dart';
import 'package:diabetes/screens/edit_account/page/edit_account_page.dart';
import 'package:diabetes/screens/home/bloc/home_bloc.dart';
import 'package:diabetes/screens/home/widget/home_exercises_card.dart';
import 'package:diabetes/screens/home/widget/home_statistics.dart';
import 'package:diabetes/screens/home/widget/home_today_pill.dart';
import 'package:diabetes/screens/pill/modify_schedule_sheet.dart';
import 'package:diabetes/screens/pill/pill_viewmodel.dart';
import 'package:diabetes/screens/pill/widget/day_chip.dart';
import 'package:diabetes/screens/pill/widget/pill_card.dart';
import 'package:diabetes/screens/sign_in/page/sign_in_page.dart';
import 'package:diabetes/screens/tabbar/bloc/tab_bar_bloc.dart';
import 'package:diabetes/screens/workout_details/page/workout_details_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_fadein/flutter_fadein.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    return Scaffold(
      body: Consumer(builder: (context, ref, child) {
        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(pillListProvider);
          },
          child: LayoutBuilder(builder: (context, constraint) {
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1000),
                child: Row(
                  children: [
                    Expanded(
                      child: CustomScrollView(
                        slivers: [
                          SliverAppBar(
                            stretch: true,
                            expandedHeight: 140,
                            flexibleSpace: FlexibleSpaceBar(
                              background: _createProfileData(context),
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Builder(builder: (context) {
                                  if (constraint.maxWidth < 900) {
                                    return overview(context, bloc);
                                  }
                                  return const SizedBox();
                                }),
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  child: Text('Days in week',
                                      style: TextStyle(fontSize: 24)),
                                ),
                                Builder(builder: (context) {
                                  final weekDays = getWeekDays();
                                  return FadeIn(
                                    duration: const Duration(milliseconds: 500),
                                    child: Center(
                                      child: SingleChildScrollView(
                                        reverse: weekDays.indexOf(
                                                DateTime.now().dateOnly) >
                                            3,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 16),
                                        scrollDirection: Axis.horizontal,
                                        child: Consumer(
                                            builder: (context, ref, child) {
                                          final days =
                                              ref.watch(scheduleWeekProvider);
                                          final currentSelectedDay = ref.watch(
                                              currentDateSelectedProvider);
                                          return Row(children: [
                                            ...days
                                                .map((day) => Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 4),
                                                      child: InkWell(
                                                        customBorder:
                                                            RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            100)),
                                                        onTap: () {
                                                          ref
                                                              .read(
                                                                  currentDateSelectedProvider
                                                                      .notifier)
                                                              .changeDate(day);
                                                        },
                                                        child: DayChip(
                                                          dateTime: day,
                                                          isSelected:
                                                              currentSelectedDay ==
                                                                  day,
                                                        ),
                                                      ),
                                                    ))
                                                .toList()
                                          ]);
                                        }),
                                      ),
                                    ),
                                  );
                                }),
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'My prescription',
                                            style: TextStyle(fontSize: 20),
                                          ),
                                          const SizedBox(
                                            height: 4,
                                          ),
                                          Consumer(
                                              builder: (context, ref, child) {
                                            final pilListAsync =
                                                ref.watch(pillListProvider);
                                            return pilListAsync.maybeWhen(
                                              data: (data) {
                                                return FadeIn(
                                                  child: Text(
                                                    'Today you take ${data.length} pill(s)',
                                                    style: TextStyle(
                                                        color: context
                                                            .colorScheme
                                                            .secondary),
                                                  ),
                                                );
                                              },
                                              orElse: () {
                                                return const ShimmerX(
                                                  child: TextShimmerable(
                                                    child: Text(
                                                      'Today you take 3 pill(s)',
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                          })
                                        ],
                                      ),
                                      const Spacer(),
                                      Consumer(builder: (context, ref, child) {
                                        return InkWell(
                                          customBorder: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          onTap: () async {
                                            final User? user = FirebaseAuth
                                                .instance.currentUser;
                                            if (user == null) {
                                              Navigator.of(context)
                                                  .pushReplacement(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              const SignInPage()));
                                              return;
                                            }
                                            final result =
                                                await showModalBottomSheet(
                                                    context: context,
                                                    isScrollControlled: true,
                                                    builder: (context) =>
                                                        ModifyScheduleSheet(
                                                          userId: user.uid,
                                                        ));
                                            if (result is PillScheduleModel) {
                                              FirebaseDatabaseService
                                                      .addUserSchedule(result)
                                                  .then((value) {
                                                ref.invalidate(
                                                    pillListProvider);
                                              });
                                            }
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: ShapeDecoration(
                                              color: context.colorScheme
                                                  .secondaryContainer,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                            child: Icon(
                                              Icons.add,
                                              color: context.colorScheme
                                                  .onSecondaryContainer,
                                            ),
                                          ),
                                        );
                                      })
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                              ],
                            ),
                          ),
                          Consumer(
                            builder: (context, ref, child) {
                              final pilListAsync =
                                  ref.watch(pillListProvider).unwrapPrevious();
                              return pilListAsync.maybeWhen(
                                data: (List<PillModel> pillList) {
                                  return SliverList.separated(
                                    separatorBuilder: (context, index) =>
                                        const SizedBox(
                                      height: 12,
                                    ),
                                    itemCount: pillList.length,
                                    itemBuilder: (context, index) {
                                      final currentPill = pillList[index];
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16),
                                        child: CardX(
                                          child: PillCardContent(
                                            item: currentPill,
                                            onCheck: () {
                                              final currentDate = ref.read(
                                                  currentDateSelectedProvider);
                                              if (currentDate !=
                                                  DateTime.now().dateOnly) {
                                                return;
                                              }
                                              var newPillTaken = currentPill
                                                  .schedule.takenPill;
                                              final currentTaken = newPillTaken[
                                                      currentDate.dateOnly] ??
                                                  [];
                                              if (currentTaken
                                                  .contains(currentPill.time)) {
                                                currentTaken
                                                    .remove(currentPill.time);
                                              } else {
                                                currentTaken
                                                    .add(currentPill.time);
                                              }
                                              final newSchedule =
                                                  currentPill.schedule.copyWith(
                                                takenPill: {
                                                  DateTime.now().dateOnly:
                                                      currentTaken,
                                                },
                                              );
                                              FirebaseDatabaseService
                                                      .addUserSchedule(
                                                          newSchedule)
                                                  .then((value) {
                                                ref.invalidate(
                                                    pillListProvider);
                                              });
                                            },
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                orElse: () {
                                  return SliverList.separated(
                                    separatorBuilder: (context, index) =>
                                        const SizedBox(
                                      height: 12,
                                    ),
                                    itemCount: 5,
                                    itemBuilder: (context, index) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      child: CardX(
                                        child: ShimmerX(
                                          child: PillCardContent(
                                            item: PillModel.blank(),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                          const SliverToBoxAdapter(
                            child: SizedBox(
                              height: 16,
                            ),
                          )
                        ],
                      ),
                    ),
                    if (constraint.maxWidth >= 900)
                      SizedBox(width: 400, child: overview(context, bloc)),
                  ],
                ),
              ),
            );
          }),
        );
      }),
    );
  }

  Widget _createProfileData(BuildContext context) {
    return Container(
      color: context.colorScheme.primary,
      padding: const EdgeInsets.fromLTRB(16, 40, 16, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
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

  Widget overview(BuildContext context, HomeBloc bloc) {
    return Column(
      children: [
        const SizedBox(height: 22),
        _showStartWorkout(context, bloc),
        // const SizedBox(height: 30),
        // _createExercisesList(context),
        // const SizedBox(height: 25),
        // _showProgress(bloc),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _showStartWorkout(BuildContext context, HomeBloc bloc) {
    return workouts.isEmpty
        ? _createStartWorkout(context, bloc)
        : const HomeStatistics();
  }

  Widget _createStartWorkout(BuildContext context, HomeBloc bloc) {
    final blocTabBar = BlocProvider.of<TabBarBloc>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: CardX(
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
      ),
    );
  }

  Widget _createExercisesList(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
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
          height: 192,
          child: ListView(
            padding: const EdgeInsets.all(16),
            scrollDirection: Axis.horizontal,
            children: [
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
              const SizedBox(width: 16),
              WorkoutCard(
                color: ColorConstants.armsColor,
                workout: DataConstants.workouts[1],
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => WorkoutDetailsPage(
                      workout: DataConstants.workouts[2],
                    ),
                  ),
                ),
              ),
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
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: CardX(
          child: Row(
            children: [
              const Image(image: AssetImage(PathConstants.progress)),
              const SizedBox(width: 20),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(TextConstants.keepProgress,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
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
        ),
      );
    });
  }
}
