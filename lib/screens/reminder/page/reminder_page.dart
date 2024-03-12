import 'package:diabetes/core/const/text_constants.dart';
import 'package:diabetes/screens/common_widget/diabetes_button.dart';
import 'package:diabetes/screens/reminder/bloc/reminder_bloc.dart';
import 'package:diabetes/screens/reminder/widget/reminder_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReminderPage extends StatelessWidget {
  const ReminderPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ReminderBloc>(
      create: (context) => ReminderBloc(),
      child: BlocBuilder<ReminderBloc, ReminderState>(
        buildWhen: (_, currState) => currState is ReminderInitial,
        builder: (context, state) {
          return Scaffold(
            body: _buildContext(context),
            appBar: AppBar(
              titleSpacing: 0,
              title: const Text(TextConstants.reminder),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: DiabetesButton(
                title: TextConstants.save,
                onTap: () {
                  final bloc = BlocProvider.of<ReminderBloc>(context);
                  bloc.add(OnSaveTappedEvent());
                },
              ),
            ),
          );
        },
      ),
    );
  }

  BlocConsumer<ReminderBloc, ReminderState> _buildContext(
      BuildContext context) {
    return BlocConsumer<ReminderBloc, ReminderState>(
      buildWhen: (_, currState) => currState is ReminderInitial,
      builder: (context, state) {
        if (state is ReminderInitial) {
          BlocProvider.of<ReminderBloc>(context).add(
            ReminderNotificationTimeEvent(dateTime: DateTime.now()),
          );
        }
        return const ReminderContent();
      },
      listenWhen: (_, currState) => currState is OnSaveTappedState,
      listener: (context, state) {
        Navigator.of(context).pop();
      },
    );
  }
}
