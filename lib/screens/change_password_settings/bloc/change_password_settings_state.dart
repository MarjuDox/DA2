part of 'change_password_settings_bloc.dart';

@immutable
abstract class ChangePasswordSettingsState {}

final class ChangePasswordSettingsInitial extends ChangePasswordSettingsState {}

class ChangePasswordProgress extends ChangePasswordSettingsState {}

class ChangePasswordError extends ChangePasswordSettingsState {
  final String error;
  ChangePasswordError(this.error);
}

class ChangePasswordSuccess extends ChangePasswordSettingsState {
  final String message;
  ChangePasswordSuccess({required this.message});
}
