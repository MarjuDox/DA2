import 'package:diabetes/core/const/color_constants.dart';
import 'package:diabetes/core/const/path_constants.dart';
import 'package:diabetes/core/const/text_constants.dart';
import 'package:diabetes/core/extension/context_extension.dart';
import 'package:diabetes/screens/common_widget/card_x.dart';
import 'package:diabetes/screens/home/bloc/home_bloc.dart';
import 'package:diabetes/screens/home/widget/DataWorkouts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeStatistics extends StatelessWidget {
  const HomeStatistics({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<HomeBloc>(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(flex: 3, child: _createCompletedWorkouts(context, bloc)),
          const SizedBox(width: 20),
          Expanded(flex: 4, child: _createColumnStatistics(bloc)),
        ],
      ),
    );
  }

  Widget _createCompletedWorkouts(BuildContext context, HomeBloc bloc) {
    return SizedBox(
      height: 220,
      child: CardX(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Row(
              children: [
                Image(
                  image: AssetImage(
                    PathConstants.finished,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    TextConstants.finished,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.fade,
                    softWrap: false,
                  ),
                ),
              ],
            ),
            Text(
              '${bloc.getFinishedWorkouts()}',
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.w700,
              ),
            ),
            const Text(
              TextConstants.completedWorkouts,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: ColorConstants.textGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _createColumnStatistics(HomeBloc bloc) {
    return Column(
      children: [
        DataWorkouts(
          icon: PathConstants.inProgress,
          title: TextConstants.inProgress,
          count: '${bloc.getInProgressWorkouts()}',
          text: TextConstants.workouts,
        ),
        const SizedBox(
          height: 16,
        ),
        DataWorkouts(
          icon: PathConstants.timeSent,
          title: TextConstants.timeSent,
          count: bloc.getTimeSent() ?? '0',
          text: "",
        ),
      ],
    );
  }
}
