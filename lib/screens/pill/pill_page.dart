import 'package:diabetes/core/common_widget/dropdown_menu_x.dart';
import 'package:diabetes/core/extension/context_extension.dart';
import 'package:diabetes/core/extension/datetime_extension.dart';
import 'package:diabetes/core/extension/timeofday_extension.dart';
import 'package:diabetes/model/pill_schedule/pill_schedule_model.dart';
import 'package:diabetes/screens/common_widget/chip_button.dart';
import 'package:diabetes/screens/common_widget/diabetes_button.dart';
import 'package:diabetes/screens/pill/add_schedule_sheet.dart';
import 'package:diabetes/screens/pill/pill_viewmodel.dart';
import 'package:diabetes/screens/pill/widget/pill_schedule_card.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
                      isScrollControlled: true,
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