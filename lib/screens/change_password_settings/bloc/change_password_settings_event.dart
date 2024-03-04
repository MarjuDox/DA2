part of 'change_password_settings_bloc.dart';

@immutable
abstract class ChangePasswordSettingsEvent {}

class ChangePasswordSettings extends ChangePasswordSettingsEvent {
  final String newPass;
  ChangePasswordSettings({required this.newPass});
}