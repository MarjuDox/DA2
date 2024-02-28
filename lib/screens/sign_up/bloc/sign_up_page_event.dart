part of 'sign_up_page_bloc.dart';

@immutable
abstract class SignUpPageEvent {}

class OnTextChangedEvent extends SignUpPageEvent{}

class SignUpTappedEvent extends SignUpPageEvent{}

class SignInTappedEvent extends SignUpPageEvent{}

