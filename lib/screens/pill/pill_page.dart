import 'package:diabetes/core/common_widget/dropdown_menu_x.dart';
import 'package:diabetes/core/extension/context_extension.dart';
import 'package:diabetes/core/extension/datetime_extension.dart';
import 'package:diabetes/model/pill_schedule/pill_schedule_model.dart';
import 'package:diabetes/screens/common_widget/diabetes_button.dart';
import 'package:diabetes/screens/pill/pill_viewmodel.dart';
import 'package:diabetes/screens/pill/widget/pill_schedule_card.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
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
              InkWell(
                customBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (context) => const AddScheduleSheet());
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
              )
            ],
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        Expanded(child: Consumer(
          builder: (context, ref, child) {
            final pilListAsync = ref.watch(pillScheduleProvider);
            return pilListAsync.maybeWhen(
              data: (List<PillModel> pillList) {
                return FadeIn(
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    separatorBuilder: (context, index) => const SizedBox(
                      height: 12,
                    ),
                    itemCount: pillList.length,
                    itemBuilder: (context, index) {
                      return PillScheduleCard(
                        item: pillList[index],
                        onCheck: () {
                          //TODO: vi check pill taken
                        },
                      );
                    },
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

class AddScheduleSheet extends StatelessWidget {
  const AddScheduleSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
          decoration: ShapeDecoration(
            color: context.colorScheme.surface,
            shape: const SmoothRectangleBorder(
              borderRadius: SmoothBorderRadius.vertical(
                top: SmoothRadius(
                  cornerRadius: 20,
                  cornerSmoothing: 1,
                ),
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(
                height: 24,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        const Expanded(
                          child: DropDownMenuX(
                            items: [1, 2, 3, 4],
                            leadingIcon: FluentIcons.syringe_20_regular,
                            label: 'Dose',
                          ),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        Expanded(
                          child: DropDownMenuX(
                            items: MedicineUnit.values,
                            getLabel: (value) {
                              return value.name;
                            },
                            leadingIcon: FluentIcons.ruler_20_regular,
                            label: 'Unit',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 22,
                    ),
                    const DropDownMenuX(
                      items: ['Before eat', 'After eat'],
                      leadingIcon: FluentIcons.food_24_regular,
                      label: 'Use',
                    ),
                    const SizedBox(
                      height: 22,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Consumer(builder: (context, ref, child) {
                            var currentDate = ref.watch(scheduleBeginProvider);
                            return InkWell(
                              onTap: () async {
                                var endDate = ref.read(scheduleEndProvider);
                                final dateSelected = await showDatePicker(
                                    context: context,
                                    firstDate: DateTime.now(),
                                    initialDate: currentDate,
                                    lastDate: endDate ?? DateTime(3000));
                                if (dateSelected != null) {
                                  ref
                                      .read(scheduleBeginProvider.notifier)
                                      .changeDate(dateSelected);
                                }
                              },
                              child: DropDownMenuX<DateTime?>(
                                items: const [],
                                initValue: currentDate,
                                getLabel: (value) => value.toMMMd,
                                enable: false,
                                leadingIcon: FluentIcons.calendar_20_regular,
                                label: 'Begin',
                              ),
                            );
                          }),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        Expanded(
                          child: Consumer(builder: (context, ref, child) {
                            var currentDate = ref.watch(scheduleEndProvider);
                            return InkWell(
                              onTap: () async {
                                var beginDate = ref.read(scheduleBeginProvider);
                                final dateSelected = await showDatePicker(
                                    context: context,
                                    firstDate: beginDate ?? DateTime.now(),
                                    initialDate: currentDate,
                                    lastDate: DateTime(3000));
                                if (dateSelected != null) {
                                  ref
                                      .read(scheduleEndProvider.notifier)
                                      .changeDate(dateSelected);
                                }
                              },
                              child: DropDownMenuX<DateTime?>(
                                items: const [],
                                getLabel: (value) => value.toMMMd,
                                initValue: currentDate,
                                enable: false,
                                leadingIcon:
                                    FluentIcons.calendar_checkmark_20_regular,
                                label: 'Finish',
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    SizedBox(
                      height: 80,
                      child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(
                              vertical: 2.5, horizontal: 1),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            final item = DayInWeek.values[index];
                            return Consumer(builder: (context, ref, child) {
                              var isSelected = ref.watch(dayInWeelSelected
                                  .select((value) => value[item] ?? false));
                              return InkWell(
                                onTap: () {
                                  ref
                                      .read(dayInWeelSelected.notifier)
                                      .toggle(item);
                                },
                                child: ChipButton(
                                  value: item,
                                  label: item.label,
                                  isSelected: isSelected,
                                ),
                              );
                            });
                          },
                          separatorBuilder: (_, __) => const SizedBox(
                                width: 10,
                              ),
                          itemCount: DayInWeek.values.length),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 32,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: DiabetesButton(
                  title: "Add schedule",
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              const SizedBox(
                height: 16,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ChipButton<T> extends StatelessWidget {
  final T value;
  final String label;
  final bool isSelected;

  const ChipButton({
    super.key,
    required this.value,
    required this.label,
    required this.isSelected,
  });
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: ShapeDecoration(
        color: isSelected
            ? context.colorScheme.surface
            : context.colorScheme.secondaryContainer.withOpacity(0.5),
        shape: SmoothRectangleBorder(
          side: BorderSide(
            strokeAlign: BorderSide.strokeAlignInside,
            color:
                isSelected ? context.colorScheme.primary : Colors.transparent,
          ),
          borderRadius: SmoothBorderRadius(
            cornerRadius: 17,
            cornerSmoothing: 1,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label,
              maxLines: 1,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: isSelected
                    ? context.colorScheme.primary
                    : context.colorScheme.onSecondaryContainer,
              )),
          const SizedBox(
            height: 4,
          ),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                boxShadow: [
                  BoxShadow(
                      color: context.colorScheme.shadow.withOpacity(0.05),
                      blurRadius: 3,
                      spreadRadius: 1,
                      offset: const Offset(2, 2)),
                ]),
            child: Icon(
              FluentIcons.checkmark_circle_32_filled,
              color: isSelected
                  ? context.colorScheme.primary
                  : context.colorScheme.surface,
            ),
          ),
        ],
      ),
    );
  }
}

enum DayInWeek {
  mon,
  tue,
  wed,
  thu,
  fri,
  sat,
  sun;

  String get label {
    switch (this) {
      case DayInWeek.mon:
        return 'Mon';
      case DayInWeek.tue:
        return 'Tue';
      case DayInWeek.wed:
        return 'Wed';
      case DayInWeek.thu:
        return 'Thu';
      case DayInWeek.fri:
        return 'Fri';
      case DayInWeek.sat:
        return 'Sat';
      case DayInWeek.sun:
        return 'Sun';
    }
  }
}

enum MedicineUnit {
  pill,
  capsule,
  ml;

  IconData get icon {
    switch (this) {
      case MedicineUnit.pill:
        return FluentIcons.circle_line_20_filled;
      case MedicineUnit.capsule:
        return FluentIcons.pill_20_filled;
      case MedicineUnit.ml:
        return FluentIcons.syringe_20_filled;
    }
  }
}
