part of 'settings_bloc.dart';

@immutable
sealed class SettingsEvent {}

class LoadSettingEvent extends SettingsEvent {}

class NavigateToChangePasswordEvent extends SettingsEvent {}

class ChangePaswordEvent extends SettingsEvent {
  final newPassword;

  ChangePaswordEvent({required this.newPassword});
}

class DeleteAccountEvent extends SettingsEvent {}
