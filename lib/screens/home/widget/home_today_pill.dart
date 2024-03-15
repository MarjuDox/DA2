import 'package:diabetes/core/extension/context_extension.dart';
import 'package:diabetes/core/extension/datetime_extension.dart';
import 'package:diabetes/core/service/firebase_database_service.dart';
import 'package:diabetes/model/pill_schedule/pill_schedule_model.dart';
import 'package:diabetes/screens/common_widget/card_x.dart';
import 'package:diabetes/screens/common_widget/shimmerx.dart';
import 'package:diabetes/screens/common_widget/text_shimmerable.dart';
import 'package:diabetes/screens/pill/add_schedule_sheet.dart';
import 'package:diabetes/screens/pill/pill_viewmodel.dart';
import 'package:diabetes/screens/pill/widget/day_chip.dart';
import 'package:diabetes/screens/pill/widget/pill_card.dart';
import 'package:diabetes/screens/sign_in/page/sign_in_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fadein/flutter_fadein.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeTodayPill extends StatelessWidget {
  const HomeTodayPill({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 16),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text('Days in week', style: TextStyle(fontSize: 24)),
        ),
        Builder(builder: (context) {
          final weekDays = getWeekDays();
          return FadeIn(
            duration: const Duration(milliseconds: 500),
            child: SingleChildScrollView(
              reverse: weekDays.indexOf(DateTime.now().dateOnly) > 3,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              scrollDirection: Axis.horizontal,
              child: Consumer(builder: (context, ref, child) {
                final days = ref.watch(scheduleWeekProvider);
                final currentSelectedDay =
                    ref.watch(currentDateSelectedProvider);
                return Row(children: [
                  ...days
                      .map((day) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: InkWell(
                              customBorder: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100)),
                              onTap: () {
                                ref
                                    .read(currentDateSelectedProvider.notifier)
                                    .changeDate(day);
                              },
                              child: DayChip(
                                dateTime: day,
                                isSelected: currentSelectedDay == day,
                              ),
                            ),
                          ))
                      .toList()
                ]);
              }),
            ),
          );
        }),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'My prescription',
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Consumer(builder: (context, ref, child) {
                    final pilListAsync = ref.watch(pillListProvider);
                    return pilListAsync.maybeWhen(
                      data: (data) {
                        return FadeIn(
                          child: Text(
                            'Today you take ${data.length} pill(s)',
                            style:
                                TextStyle(color: context.colorScheme.secondary),
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
                    borderRadius: BorderRadius.circular(10),
                  ),
                  onTap: () async {
                    final User? user = FirebaseAuth.instance.currentUser;
                    if (user == null) {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const SignInPage()));
                      return;
                    }
                    final result =
                        await showModalBottomSheet<PillScheduleModel>(
                            context: context,
                            isScrollControlled: true,
                            builder: (context) => ModifyScheduleSheet(
                                  userId: user.uid,
                                ));
                    if (result != null) {
                      FirebaseDatabaseService.addUserSchedule(result)
                          .then((value) {
                        ref.invalidate(pillListProvider);
                      });
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: ShapeDecoration(
                      color: context.colorScheme.secondaryContainer,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Icon(
                      Icons.add,
                      color: context.colorScheme.onSecondaryContainer,
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
        Expanded(child: Consumer(
          builder: (context, ref, child) {
            final pilListAsync = ref.watch(pillListProvider).unwrapPrevious();
            return pilListAsync.maybeWhen(
              data: (List<PillModel> pillList) {
                return FadeIn(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      ref.invalidate(pillListProvider);
                    },
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      separatorBuilder: (context, index) => const SizedBox(
                        height: 12,
                      ),
                      itemCount: pillList.length,
                      itemBuilder: (context, index) {
                        final currentPill = pillList[index];
                        return CardX(
                          child: PillCardContent(
                            item: currentPill,
                            onCheck: () {
                              final currentDate =
                                  ref.read(currentDateSelectedProvider);
                              if (currentDate != DateTime.now().dateOnly) {
                                return;
                              }
                              var newPillTaken = currentPill.schedule.takenPill;
                              final currentTaken =
                                  newPillTaken[currentDate.dateOnly] ?? [];
                              if (currentTaken.contains(currentPill.time)) {
                                currentTaken.remove(currentPill.time);
                              } else {
                                currentTaken.add(currentPill.time);
                              }
                              final newSchedule = currentPill.schedule.copyWith(
                                takenPill: {
                                  DateTime.now().dateOnly: currentTaken,
                                },
                              );
                              FirebaseDatabaseService.addUserSchedule(
                                      newSchedule)
                                  .then((value) {
                                ref.invalidate(pillListProvider);
                              });
                            },
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
              orElse: () {
                return ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  separatorBuilder: (context, index) => const SizedBox(
                    height: 12,
                  ),
                  itemCount: 5,
                  itemBuilder: (context, index) => CardX(
                    child: ShimmerX(
                      child: PillCardContent(
                        item: PillModel.blank(),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ))
      ],
    );
  }
}
