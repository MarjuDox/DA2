import 'package:diabetes/core/extension/context_extension.dart';
import 'package:diabetes/core/extension/datetime_extension.dart';
import 'package:diabetes/core/service/firebase_database_service.dart';
import 'package:diabetes/model/pill_schedule/pill_schedule_model.dart';
import 'package:diabetes/screens/pill/add_schedule_sheet.dart';
import 'package:diabetes/screens/pill/pill_viewmodel.dart';
import 'package:diabetes/screens/pill/widget/day_chip.dart';
import 'package:diabetes/screens/pill/widget/pill_schedule_card.dart';
import 'package:diabetes/screens/sign_in/page/sign_in_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fadein/flutter_fadein.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PillPage extends ConsumerStatefulWidget {
  const PillPage({super.key});

  @override
  ConsumerState<PillPage> createState() => _PillPageState();
}

class _PillPageState extends ConsumerState<PillPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorScheme.surfaceVariant.withOpacity(0.1),
      body: const SafeArea(
        child: PillScheduleSection(),
      ),
    );
  }
}

class PillScheduleSection extends StatelessWidget {
  const PillScheduleSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Builder(builder: (context) {
          final weekDays = getWeekDays();
          return SingleChildScrollView(
            reverse: weekDays.indexOf(DateTime.now().dateOnly) > 3,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            scrollDirection: Axis.horizontal,
            child: Consumer(builder: (context, ref, child) {
              final days = ref.watch(scheduleWeekProvider);
              final currentSelectedDay = ref.watch(currentDateSelectedProvider);
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
                  Text(
                    'Today you take 3 pills',
                    style: TextStyle(color: context.colorScheme.secondary),
                  )
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
                            builder: (context) => AddScheduleSheet(
                                  userId: user.uid,
                                ));
                    if (result != null) {
                      FirebaseDatabaseService.addUserSchedule(result)
                          .then((value) {
                        ref.invalidate(pillScheduleProvider);
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
            final pilListAsync =
                ref.watch(pillScheduleProvider).unwrapPrevious();
            return pilListAsync.maybeWhen(
              data: (List<PillModel> pillList) {
                return FadeIn(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      ref.invalidate(pillScheduleProvider);
                    },
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      separatorBuilder: (context, index) => const SizedBox(
                        height: 12,
                      ),
                      itemCount: pillList.length,
                      itemBuilder: (context, index) {
                        final currentPill = pillList[index];
                        return PillScheduleCard(
                          item: currentPill,
                          onCheck: () {
                            var newPillTaken = currentPill.schedule.takenPill;
                            final currentTaken =
                                newPillTaken[DateTime.now().dateOnly] ?? [];
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
                            FirebaseDatabaseService.addUserSchedule(newSchedule)
                                .then((value) {
                              ref.invalidate(pillScheduleProvider);
                            });
                          },
                        );
                      },
                    ),
                  ),
                );
              },
              orElse: () {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            );
          },
        ))
      ],
    );
  }
}
