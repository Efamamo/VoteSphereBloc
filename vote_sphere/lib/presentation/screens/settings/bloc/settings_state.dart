part of 'settings_bloc.dart';

@immutable
sealed class SettingsState {}

abstract class SettingsActionState extends SettingsState {}

final class SettingsInitial extends SettingsState {}

class SettingsLoadingState extends SettingsState {}

class SettingsLoadedState extends SettingsState {
  final username;
  SettingsLoadedState({required this.username});
}

class NavigateToUpdatePasswordState extends SettingsActionState {}

class ChangePasswordSuccessState extends SettingsActionState {}

class ChangePasswordErrorState extends SettingsActionState {}
