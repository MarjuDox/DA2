part of 'sign_in_page_bloc.dart';

@immutable
abstract class SignInPageEvent {}

class OnTextChangeEvent extends SignInPageEvent {}

class SignInTappedEvent extends SignInPageEvent {}

class SignUpTappedEvent extends SignInPageEvent {}

class ForgotPasswordTappedEvent extends SignInPageEvent {}