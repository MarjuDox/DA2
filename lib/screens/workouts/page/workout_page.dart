import 'package:diabetes/screens/home/page/home_page.dart';
import 'package:diabetes/screens/workouts/bloc/workouts_bloc.dart';
import 'package:diabetes/screens/workouts/widget/workout_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WorkoutsPage extends StatelessWidget {
  const WorkoutsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _buildContext(context));
  }

  BlocProvider<WorkoutsBloc> _buildContext(BuildContext context) {
    return BlocProvider<WorkoutsBloc>(
      create: (context) => WorkoutsBloc(),
      child: BlocConsumer<WorkoutsBloc, WorkoutsState>(
        buildWhen: (_, currState) => currState is WorkoutsInitial,
        builder: (context, state) {
          final bloc = BlocProvider.of<WorkoutsBloc>(context);
          bloc.add(WorkoutsInitialEvent());
          return WorkoutContent();
        },
        listenWhen: (_, currState) => currState is CardTappedState,
        listener: (context, state) async {
          if (state is CardTappedState) {
            await Navigator.of(context, rootNavigator: true).push(
              MaterialPageRoute(
                builder: (_) => HomePage() //WorkoutDetailsPage(workout: state.workout),
              ),
            );
            // ignore: use_build_context_synchronously
            final bloc = BlocProvider.of<WorkoutsBloc>(context);
            bloc.add(WorkoutsInitialEvent());
          }
        },
      ),
    );
  }
}