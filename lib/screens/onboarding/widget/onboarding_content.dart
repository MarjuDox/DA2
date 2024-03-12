import 'package:diabetes/core/const/data_constants.dart';
import 'package:diabetes/screens/common_widget/diabetes_button.dart';
import 'package:diabetes/screens/onboarding/bloc/onboarding_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingContent extends StatelessWidget {
  const OnboardingContent({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<OnboardingBloc>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: [
          TextButton(
            onPressed: () {
              bloc.add(OnboardSkipEvent());
            },
            child: const Text(
              'Skip',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: PageView(
                scrollDirection: Axis.horizontal,
                controller: bloc.pageController,
                children: DataConstants.onboardingTiles,
                onPageChanged: (index) {
                  bloc.add(PageSwipedEvent(index: index));
                },
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            BlocBuilder<OnboardingBloc, OnboardingState>(
              buildWhen: (_, currState) => currState is PageChangedState,
              builder: (context, state) {
                return Center(
                  child: SmoothPageIndicator(
                    count: 3,
                    effect: ExpandingDotsEffect(
                      dotHeight: 6,
                      dotWidth: 6,
                      expansionFactor: 8,
                      activeDotColor: Theme.of(context).colorScheme.primary,
                      dotColor:
                          Theme.of(context).colorScheme.secondaryContainer,
                    ),
                    controller: bloc.pageController,
                  ),
                );
              },
            ),
            const SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: DiabetesButton(
                onTap: () {
                  bloc.add(PageChangedEvent());
                },
                title: 'Continue',
              ),
            ),
            const SizedBox(
              height: 40,
            ),
          ],
        ),
      ),
    );
  }
}
