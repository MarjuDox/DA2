import 'package:diabetes/core/extension/context_extension.dart';
import 'package:diabetes/screens/common_widget/diabetes_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PillPage extends ConsumerStatefulWidget {
  const PillPage({super.key});

  @override
  ConsumerState<PillPage> createState() => _PillPageState();
}

class _PillPageState extends ConsumerState<PillPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [PillScheduleSection()],
          ),
        ),
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
        Row(
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
        const SizedBox(
          height: 16,
        ),
      ],
    );
  }
}

class AddScheduleSheet extends StatelessWidget {
  const AddScheduleSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          const SizedBox(height: 20),
          const Text(
            "Add Schedule",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          DiabetesButton(
              title: "Choose time",
              onTap: () {
                showTimePicker(context: context, initialTime: TimeOfDay.now());
              }),
          const SizedBox(height: 20),
          DiabetesButton(
            title: "Save",
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
