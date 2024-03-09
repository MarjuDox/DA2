import 'package:bloc/bloc.dart';
import 'package:diabetes/core/const/text_constants.dart';
import 'package:diabetes/core/service/user_service.dart';
import 'package:flutter/material.dart';


part 'change_password_settings_event.dart';
part 'change_password_settings_state.dart';

class ChangePasswordSettingsBloc extends Bloc<ChangePasswordSettingsEvent,ChangePasswordSettingsState> {
  ChangePasswordSettingsBloc() : super(ChangePasswordSettingsInitial());

 @override
  Stream<ChangePasswordSettingsState> mapEventToState(
    ChangePasswordSettingsEvent event,
  ) async* {
    if (event is ChangePasswordSettings) {
      yield ChangePasswordProgress();
      try {
        await UserService.changePassword(newPass: event.newPass);
        yield ChangePasswordSuccess(message: TextConstants.passwordUpdated);
        await Future.delayed(const Duration(seconds: 1));
        yield ChangePasswordSettingsInitial();
        await UserService.signOut();
      } catch (e) {
        yield ChangePasswordError(e.toString());
        await Future.delayed(const Duration(seconds: 1));
        yield ChangePasswordSettingsInitial();
      }
    }
  }  
}
