part of 'settings_bloc.dart';

@immutable
sealed class SettingsEvent {}

class LoadSettingEvent extends SettingsEvent {}

class NavigateToChangePasswordEvent extends SettingsEvent {}

class ChangePaswordEvent extends SettingsEvent {
  final newPassword;
  final oldPassword;
  ChangePaswordEvent({required this.newPassword, required this.oldPassword});
}

class DeleteAccountEvent extends SettingsEvent {}
