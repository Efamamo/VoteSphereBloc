part of '../../application/blocs/settings_bloc.dart';

@immutable
sealed class SettingsState {}

abstract class SettingsActionState extends SettingsState {}

final class SettingsInitial extends SettingsState {}

class SettingsLoadingState extends SettingsState {}

class SettingsLoadedState extends SettingsState {
  final username;
  final email;
  final role;
  SettingsLoadedState({required this.username, required this.email, required this.role});
}

class NavigateToUpdatePasswordState extends SettingsActionState {}

class ChangePasswordSuccessState extends SettingsActionState {}

class ChangePasswordErrorState extends SettingsActionState {
  final error;
  ChangePasswordErrorState({required this.error});
}

class DeleteAccountState extends SettingsActionState {}
