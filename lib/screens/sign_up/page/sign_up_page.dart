import 'package:diabetes/screens/sign_in/page/sign_in_page.dart';
import 'package:diabetes/screens/sign_up/bloc/sign_up_page_bloc.dart';
import 'package:diabetes/screens/sign_up/widget/sign_up_content.dart';
import 'package:diabetes/screens/tabbar/page/tab_bar_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _buildBody(context));
  }

  BlocProvider<SignUpPageBloc> _buildBody(BuildContext context) {
    return BlocProvider<SignUpPageBloc>(
      create: (BuildContext context) => SignUpPageBloc(),
      child: BlocConsumer<SignUpPageBloc, SignUpPageState>(
        listenWhen: (_, currState) => currState is NextTabBarPageState || currState is NextSignInPageState || currState is ErrorState,
        listener: (context, state) {
          if (state is NextTabBarPageState) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const TabBarPage()));
          } else if (state is NextSignInPageState) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const SignInPage()));
          } else if (state is ErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        buildWhen: (_, currState) => currState is SignUpPageInitial,
        builder: (context, state) {
          return const SignUpContent();
        },
      ),
    );
  }
}