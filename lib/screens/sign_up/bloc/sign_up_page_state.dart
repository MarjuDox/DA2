part of 'sign_up_page_bloc.dart';

@immutable
abstract class SignUpPageState {}

class SignUpPageInitial extends SignUpPageState {}

class SignUpButtonEnableChangedState extends SignUpPageState{
  final bool isEnabled;

  SignUpButtonEnableChangedState({
    required  this.isEnabled,
  });
}

class ShowErrorState extends SignUpPageState{}

class ErrorState  extends SignUpPageState{
  final String message;
  ErrorState({required this.message});
}

class NextTabBarPageState extends SignUpPageState{}

class NextSignInPageState extends SignUpPageState{}

class LoadingState extends SignUpPageState{}