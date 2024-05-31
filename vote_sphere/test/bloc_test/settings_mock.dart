import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import '../../lib/infrastructure/repositories/settings_repository.dart';

// Events
abstract class SettingsEvent extends Equatable {
  const SettingsEvent();
}

class ChangePasswordEvent extends SettingsEvent {
  final String newPassword;

  const ChangePasswordEvent(this.newPassword);

  @override
  List<Object> get props => [newPassword];
}

class DeleteAccountEvent extends SettingsEvent {
  @override
  List<Object> get props => [];
}

// States
abstract class SettingsState extends Equatable {
  const SettingsState();
}

class SettingsInitial extends SettingsState {
  @override
  List<Object> get props => [];
}

class SettingsLoading extends SettingsState {
  @override
  List<Object> get props => [];
}

class ChangePasswordSuccess extends SettingsState {
  @override
  List<Object> get props => [];
}

class ChangePasswordFailure extends SettingsState {
  final String error;

  const ChangePasswordFailure(this.error);

  @override
  List<Object> get props => [error];
}

class DeleteAccountSuccess extends SettingsState {
  @override
  List<Object> get props => [];
}

class DeleteAccountFailure extends SettingsState {
  final String error;

  const DeleteAccountFailure(this.error);

  @override
  List<Object> get props => [error];
}

// Bloc
class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final http.Client httpClient;

  SettingsBloc({required this.httpClient}) : super(SettingsInitial()) {
    on<ChangePasswordEvent>(_onChangePassword);
    on<DeleteAccountEvent>(_onDeleteAccount);
  }

  Future<void> _onChangePassword(
      ChangePasswordEvent event, Emitter<SettingsState> emit) async {
    emit(SettingsLoading());
    try {
      final success =
          await SettingsRepository.changePassword(event.newPassword);
      if (success == "success") {
        emit(ChangePasswordSuccess());
      } else {
        emit(ChangePasswordFailure('Failed to change password'));
      }
    } catch (e) {
      emit(ChangePasswordFailure(e.toString()));
    }
  }

  Future<void> _onDeleteAccount(
      DeleteAccountEvent event, Emitter<SettingsState> emit) async {
    emit(SettingsLoading());
    try {
      final success = await SettingsRepository.deleteAccount();
      if (success) {
        emit(DeleteAccountSuccess());
      } else {
        emit(DeleteAccountFailure('Failed to delete account'));
      }
    } catch (e) {
      emit(DeleteAccountFailure(e.toString()));
    }
  }
}
