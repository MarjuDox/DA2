import 'package:diabetes/core/common_widget/dropdown_menu_x.dart';
import 'package:diabetes/core/const/enum.dart';
import 'package:diabetes/core/extension/context_extension.dart';
import 'package:diabetes/core/extension/datetime_extension.dart';
import 'package:diabetes/core/extension/timeofday_extension.dart';
import 'package:diabetes/screens/common_widget/chip_button.dart';
import 'package:diabetes/screens/common_widget/diabetes_button.dart';
import 'package:diabetes/screens/common_widget/text_field.dart';
import 'package:diabetes/screens/pill/pill_viewmodel.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fadein/flutter_fadein.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddScheduleSheet extends StatefulWidget {
  const AddScheduleSheet({super.key});

  @override
  State<AddScheduleSheet> createState() => _AddScheduleSheetState();
}

class _AddScheduleSheetState extends State<AddScheduleSheet> {
  final controller = TextEditingController();
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
                    Consumer(builder: (context, ref, child) {
                      final errorText = ref.watch(medicineNameErrorProvider);
                      return TextFieldX(
                        labelText: 'Medicine name',
                        controller: controller,
                        onChanged: (value) {
                          ref.read(medicineNameErrorProvider.notifier).state =
                              null;
                        },
                        errorText: errorText,
                      );
                    }),
                    const SizedBox(
                      height: 22,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Consumer(builder: (context, ref, child) {
                            final currentDose = ref.watch(doseProvider);
                            final currentUnit = ref.watch(medicineUnitProvider);
                            return DropDownMenuX<double>(
                              initValue: currentDose,
                              items: currentUnit.dose,
                              getLabel: (value) {
                                switch (currentUnit) {
                                  case MedicineUnit.pill:
                                    return value.toString();
                                  case MedicineUnit.capsule:
                                  case MedicineUnit.ml:
                                    return value.toInt().toString();
                                }
                              },
                              leadingIcon: FluentIcons.syringe_20_regular,
                              onSelected: (value) {
                                if (value != null) {
                                  ref
                                      .read(doseProvider.notifier)
                                      .onChange(value);
                                }
                              },
                              label: 'Dose',
                            );
                          }),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        Expanded(
                          child: Consumer(builder: (context, ref, child) {
                            final currentUnit = ref.watch(medicineUnitProvider);
                            return DropDownMenuX(
                              items: MedicineUnit.values,
                              initValue: currentUnit,
                              getLabel: (value) {
                                return value.name;
                              },
                              onSelected: (value) {
                                if (value != null) {
                                  ref
                                      .read(medicineUnitProvider.notifier)
                                      .onChange(value);
                                }
                              },
                              leadingIcon: FluentIcons.ruler_20_regular,
                              label: 'Unit',
                            );
                          }),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Text(
                      'Time:',
                      style: TextStyle(
                          fontSize: 12,
                          color:
                              context.colorScheme.secondary.withOpacity(0.6)),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    AnimatedSize(
                      alignment: Alignment.topCenter,
                      duration: const Duration(milliseconds: 200),
                      child: Consumer(builder: (context, ref, child) {
                        var times = ref.watch(timesProvider);
                        return Wrap(
                          runSpacing: 10,
                          spacing: 8,
                          children: [
                            ...times.map((time) {
                              return InkWell(
                                onTap: () async {
                                  final timeSelected = await showTimePicker(
                                    context: context,
                                    initialTime: time,
                                  );
                                  if (timeSelected != null) {
                                    ref
                                        .read(timesProvider.notifier)
                                        .changeTime(time, timeSelected);
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: context.colorScheme.outlineVariant
                                        .withOpacity(0.2),
                                    // color: context.colorScheme.primaryContainer,
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  padding:
                                      const EdgeInsets.fromLTRB(12, 8, 8, 8),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        time.formattedTime,
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: context.colorScheme
                                                .onPrimaryContainer),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          ref
                                              .read(timesProvider.notifier)
                                              .removeTime(time);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(4),
                                          child: Icon(
                                            Icons.close_rounded,
                                            size: 16,
                                            color: context
                                                .colorScheme.onPrimaryContainer
                                                .withOpacity(0.3),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                customBorder: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                onTap: () async {
                                  final timeSelected = await showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now());
                                  if (timeSelected != null) {
                                    ref
                                        .read(timesProvider.notifier)
                                        .addTime(timeSelected);
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: context
                                            .colorScheme.outlineVariant
                                            .withOpacity(0.6)),
                                    // color: context.colorScheme.surfaceVariant,
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 8),
                                  child: Icon(
                                    Icons.add_rounded,
                                    size: 23,
                                    color: context.colorScheme.secondary,
                                  ),
                                ),
                              ),
                            )
                          ],
                        );
                      }),
                    ),
                    AnimatedSize(
                      duration: const Duration(milliseconds: 200),
                      child: Consumer(
                        builder: (context, ref, child) {
                          var timesError = ref.watch(timesErrorProvider);
                          if (timesError?.isNotEmpty ?? false) {
                            return FadeIn(child: Text(timesError!));
                          }
                          return const SizedBox();
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 22,
                    ),
                    Consumer(builder: (context, ref, child) {
                      final currentUse = ref.watch(medicineUseProvider);
                      return DropDownMenuX<PillUseNote>(
                        initValue: currentUse,
                        items: PillUseNote.values,
                        getLabel: (value) {
                          return value.label;
                        },
                        onSelected: (value) {
                          if (value != null) {
                            ref
                                .read(medicineUseProvider.notifier)
                                .onChange(value);
                          }
                        },
                        leadingIcon: FluentIcons.food_24_regular,
                        label: 'Use',
                      );
                    }),
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
              Consumer(builder: (context, ref, child) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: DiabetesButton(
                    title: "Add schedule",
                    onTap: () {
                      if (controller.text.isEmpty) {
                        ref.read(medicineNameErrorProvider.notifier).state =
                            'Input required';
                      }
                      final times = ref.read(timesProvider);
                      if (times.isEmpty) {}
                      // Navigator.pop(context);
                    },
                  ),
                );
              }),
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

final medicineNameErrorProvider =
    StateProvider.autoDispose<String?>((ref) => null);

final timesErrorProvider = StateProvider.autoDispose<String?>((ref) => null);
