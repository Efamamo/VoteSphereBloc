import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:vote_sphere/infrastructure/local_storage/secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:vote_sphere/infrastructure/repositories/settings_repository.dart';

part '../../presentation/events/settings_event.dart';
part '../../presentation/states/settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(SettingsInitial()) {
    on<LoadSettingEvent>(loadSettingEvent);
    on<NavigateToChangePasswordEvent>(navigateToChangePasswordEvent);
    on<ChangePaswordEvent>(changePaswordEvent);
    on<DeleteAccountEvent>(deleteAccountEvent);
  }

  FutureOr<void> loadSettingEvent(
      LoadSettingEvent event, Emitter<SettingsState> emit) async {
    Map res = await SettingsRepository.loadSetting(event);

    emit(SettingsLoadedState(username: res["username"], email: res["email"],role: res["role"]));
  }

  FutureOr<void> navigateToChangePasswordEvent(
      NavigateToChangePasswordEvent event, Emitter<SettingsState> emit) {
    emit(NavigateToUpdatePasswordState());
  }

  FutureOr<void> changePaswordEvent(
      ChangePaswordEvent event, Emitter<SettingsState> emit) async {
    String res = await SettingsRepository.changePassword(event);

    if (res == "success") {
      emit(ChangePasswordSuccessState());
    } else {
      emit(ChangePasswordErrorState(error: res));
    }
  }

  FutureOr<void> deleteAccountEvent(
      DeleteAccountEvent event, Emitter<SettingsState> emit) async {
    bool res = await SettingsRepository.deleteAccount();
   
      emit(DeleteAccountState());
    
  }
}
