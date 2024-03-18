import 'package:diabetes/core/common_widget/dropdown_menu_x.dart';
import 'package:diabetes/core/const/enum.dart';
import 'package:diabetes/core/extension/context_extension.dart';
import 'package:diabetes/core/extension/datetime_extension.dart';
import 'package:diabetes/core/service/firebase_database_service.dart';
import 'package:diabetes/core/service/firebase_storage_service.dart';
import 'package:diabetes/model/pill_schedule/pill_schedule_model.dart';
import 'package:diabetes/screens/common_widget/chip_button.dart';
import 'package:diabetes/screens/common_widget/diabetes_button.dart';
import 'package:diabetes/screens/common_widget/text_field.dart';
import 'package:diabetes/screens/pill/pill_viewmodel.dart';
import 'package:diabetes/screens/pill/widget/time_chip.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fadein/flutter_fadein.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

class ModifyScheduleSheet extends ConsumerStatefulWidget {
  const ModifyScheduleSheet({super.key, required this.userId, this.schedule});
  final String userId;
  final PillScheduleModel? schedule;
  @override
  ConsumerState<ModifyScheduleSheet> createState() =>
      _ModifyScheduleSheetState();
}

class _ModifyScheduleSheetState extends ConsumerState<ModifyScheduleSheet> {
  late final controller =
      TextEditingController(text: widget.schedule?.medicineName);

  late final DateTime? scheduleBeginDate = widget.schedule?.startDate;

  @override
  void initState() {
    if (widget.schedule != null) {
      Future.delayed(Duration.zero, () {
        ref.read(medicineUnitProvider.notifier).onChange(widget.schedule!.unit);
        ref.read(doseProvider.notifier).onChange(widget.schedule!.dose);
        ref.read(timesProvider.notifier).setValue(widget.schedule!.times);
        ref.read(medicineUseProvider.notifier).onChange(widget.schedule!.note);
        ref.read(dayInWeelSelected.notifier).setValue(
            Map.fromIterable(widget.schedule!.daysInWeek, value: (_) => true));
        ref
            .read(scheduleBeginProvider.notifier)
            .changeDate(widget.schedule!.startDate);
        ref
            .read(scheduleEndProvider.notifier)
            .changeDate(widget.schedule!.endDate);
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Container(
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
                              final currentUnit =
                                  ref.watch(medicineUnitProvider);
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
                              final currentUnit =
                                  ref.watch(medicineUnitProvider);
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
                                    child: TimeChip(
                                      time: time,
                                      onDelete: () {
                                        ref
                                            .read(timesProvider.notifier)
                                            .removeTime(time);
                                      },
                                    ));
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
                            var times = ref.watch(timesProvider);
                            if (times.isEmpty) {
                              return FadeIn(
                                  child: Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text(
                                  'Input required',
                                  style: TextStyle(
                                      color: context.colorScheme.error),
                                ),
                              ));
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
                              final beginDate =
                                  ref.watch(scheduleBeginProvider);
                              final beginDateError =
                                  ref.watch(dateBeginErrorProvider);
                              return InkWell(
                                onTap: () async {
                                  var endDate = ref.read(scheduleEndProvider);
                                  final dateSelected = await showDatePicker(
                                      context: context,
                                      firstDate:
                                          scheduleBeginDate ?? DateTime.now(),
                                      initialDate: beginDate,
                                      lastDate: endDate ?? DateTime(3000));
                                  if (dateSelected != null) {
                                    ref
                                        .read(scheduleBeginProvider.notifier)
                                        .changeDate(dateSelected);
                                    ref
                                        .read(dateBeginErrorProvider.notifier)
                                        .state = null;
                                  }
                                },
                                child: DropDownMenuX<DateTime?>(
                                  errorText: beginDateError,
                                  items: const [],
                                  initValue: beginDate,
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
                              final endDateError =
                                  ref.watch(dateEndErrorProvider);
                              return InkWell(
                                onTap: () async {
                                  var beginDate =
                                      ref.read(scheduleBeginProvider);
                                  final dateSelected = await showDatePicker(
                                      context: context,
                                      firstDate: beginDate ?? DateTime.now(),
                                      initialDate: currentDate,
                                      lastDate: DateTime(3000));
                                  if (dateSelected != null) {
                                    ref
                                        .read(scheduleEndProvider.notifier)
                                        .changeDate(dateSelected);
                                    ref
                                        .read(dateEndErrorProvider.notifier)
                                        .state = null;
                                  }
                                },
                                child: DropDownMenuX<DateTime?>(
                                  errorText: endDateError,
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
                AnimatedSize(
                  duration: const Duration(milliseconds: 200),
                  child: Consumer(
                    builder: (context, ref, child) {
                      var daysPicked = ref.watch(dayInWeelSelected
                          .select((value) => value.containsValue(true)));
                      if (!daysPicked) {
                        return FadeIn(
                            child: Padding(
                          padding: const EdgeInsets.only(
                              top: 8, left: 16, right: 16),
                          child: Text(
                            'Input required',
                            style: TextStyle(color: context.colorScheme.error),
                          ),
                        ));
                      }
                      return const SizedBox();
                    },
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Consumer(builder: (context, ref, child) {
                  final formIsValid = ref.watch(formIsValidProvider);
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: DiabetesButton(
                      isEnabled: formIsValid,
                      title: widget.schedule == null
                          ? "Add schedule"
                          : "Save schedule",
                      onTap: () {
                        bool isValid = true;
                        if (controller.text.isEmpty) {
                          ref.read(medicineNameErrorProvider.notifier).state =
                              'Input required';
                          isValid = false;
                        }
                        if (ref.read(scheduleBeginProvider) == null) {
                          ref.read(dateBeginErrorProvider.notifier).state =
                              'Input required';
                          isValid = false;
                        }
                        if (ref.read(scheduleEndProvider) == null) {
                          ref.read(dateEndErrorProvider.notifier).state =
                              'Input required';
                          isValid = false;
                        }
                        if (isValid) {
                          final medicineName = controller.text;
                          final times = ref.read(timesProvider);
                          final startDate = ref.read(scheduleBeginProvider)!;
                          final endDate = ref.read(scheduleEndProvider)!;
                          final daysInWeekMap = ref.read(dayInWeelSelected);
                          daysInWeekMap
                              .removeWhere((key, value) => value == false);
                          final daysInWeek = daysInWeekMap.keys.toList();
                          final dose = ref.read(doseProvider);
                          final unit = ref.read(medicineUnitProvider);
                          final pillNote = ref.read(medicineUseProvider);
                          final schedule = PillScheduleModel(
                              uid: widget.schedule == null
                                  ? const Uuid().v4()
                                  : widget.schedule!.uid,
                              userId: widget.userId,
                              medicineName: medicineName,
                              times: times,
                              startDate: startDate,
                              endDate: endDate,
                              daysInWeek: daysInWeek,
                              dose: dose,
                              unit: unit,
                              note: pillNote);
                          Navigator.pop(context, schedule);
                        }
                      },
                    ),
                  );
                }),
                const SizedBox(
                  height: 16,
                ),
                if (widget.schedule != null)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: FilledButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                          context.colorScheme.surfaceVariant.withOpacity(0.6),
                        ),
                      ),
                      child: Text(
                        'Delete schedule',
                        style: TextStyle(
                          color: context.colorScheme.error.withOpacity(0.7),
                        ),
                      ),
                      onPressed: () async {
                        Navigator.of(context).pop(true);
                      },
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

final formIsValidProvider = StateProvider.autoDispose<bool>((ref) {
  final medicineNameIsValid = ref.watch(
      medicineNameErrorProvider.select((value) => value?.isEmpty ?? true));
  final timesIsValid =
      ref.watch(timesProvider.select((value) => value.isNotEmpty));
  final dateBeginIsValid = ref
      .watch(dateBeginErrorProvider.select((value) => value?.isEmpty ?? true));
  final dateEndIsValid =
      ref.watch(dateEndErrorProvider.select((value) => value?.isEmpty ?? true));
  final daysIsValid =
      ref.watch(dayInWeelSelected.select((value) => value.containsValue(true)));
  return medicineNameIsValid &&
      timesIsValid &&
      dateBeginIsValid &&
      dateEndIsValid &&
      daysIsValid;
});

final medicineNameErrorProvider =
    StateProvider.autoDispose<String?>((ref) => null);
final dateBeginErrorProvider =
    StateProvider.autoDispose<String?>((ref) => null);
final dateEndErrorProvider = StateProvider.autoDispose<String?>((ref) => null);
