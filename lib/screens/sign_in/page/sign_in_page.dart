import 'package:diabetes/screens/forgot_password/page/forgot_password_page.dart';
import 'package:diabetes/screens/sign_in/bloc/sign_in_page_bloc.dart';
import 'package:diabetes/screens/sign_in/widget/sign_in_content.dart';
import 'package:diabetes/screens/sign_up/page/sign_up_page.dart';
import 'package:diabetes/screens/tabbar/page/tab_bar_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildContext(context),
    );
  }

  BlocProvider<SignInPageBloc> _buildContext(BuildContext context) {
    return BlocProvider<SignInPageBloc>(
      create: (BuildContext context) => SignInPageBloc(),
      child: BlocConsumer<SignInPageBloc, SignInPageState>(
        buildWhen: (_, currState) => currState is SignInPageInitial,
        builder: (context, state) {
          return const SignInContent();
        },
        listenWhen: (_, currState) =>
            currState is NextForgotPasswordPageState || currState is NextSignUpPageState || currState is NextTabBarPageState || currState is ErrorState,
        listener: (context, state) {
          if (state is NextForgotPasswordPageState) {
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ForgotPasswordPage()));
          } else if (state is NextSignUpPageState) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const SignUpPage()));
          } else if (state is NextTabBarPageState) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const TabBarPage()));
          } else if (state is ErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
      ),
    );
  }
}