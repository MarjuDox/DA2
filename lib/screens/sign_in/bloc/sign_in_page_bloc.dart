import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:diabetes/core/service/auth_service.dart';
import 'package:diabetes/core/service/validation_service.dart';
import 'package:flutter/material.dart';

part 'sign_in_page_event.dart';
part 'sign_in_page_state.dart';

class SignInPageBloc extends Bloc<SignInPageEvent, SignInPageState> {
  SignInPageBloc() : super(SignInPageInitial());
  
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  
  bool isButtonEnabled = false;

   Stream<SignInPageState> mapEventToState(
    SignInPageEvent event,
  ) async* {
    if (event is OnTextChangeEvent) {
      if (isButtonEnabled != _checkIfSignInButtonEnabled()) {
        isButtonEnabled = _checkIfSignInButtonEnabled();
        yield SignInButtonEnableChangedState(isEnabled: isButtonEnabled);
      }
    } else if (event is SignInTappedEvent) {
      if (_checkValidatorsOfTextField()) {
        try {
          yield LoadingState();
          await AuthService.signIn(emailController.text, passwordController.text);
          yield NextTabBarPageState();
          print("Go to the next page");
        } catch (e) {
          print('E to tstrng: ' + e.toString());
          yield ErrorState(message: e.toString());
        }
      } else {
        yield ShowErrorState();
      }
    } else if (event is ForgotPasswordTappedEvent) {
      yield NextForgotPasswordPageState();
    } else if (event is SignUpTappedEvent) {
      yield NextSignUpPageState();
    }
  }

  bool _checkIfSignInButtonEnabled() {
    return emailController.text.isNotEmpty && passwordController.text.isNotEmpty;
  }

  bool _checkValidatorsOfTextField() {
    return ValidationService.email(emailController.text) && ValidationService.password(passwordController.text);
  }
}
