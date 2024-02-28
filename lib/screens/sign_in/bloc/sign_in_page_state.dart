part of 'sign_in_page_bloc.dart';

@immutable
abstract class SignInPageState {
  const SignInPageState();
}

class SignInPageInitial extends SignInPageState {}

class SignInButtonEnableChangedState extends SignInPageState{
  final bool isEnabled;

  const SignInButtonEnableChangedState({
    required this.isEnabled
  });
}

class ShowErrorState extends SignInPageState {}

class NextForgotPasswordPageState extends SignInPageState {}

class NextSignUpPageState extends SignInPageState {}

class NextTabBarPageState extends SignInPageState {}

class ErrorState extends SignInPageState {
  final String message;

  const ErrorState({
    required this.message,
  });
}

class LoadingState extends SignInPageState {}