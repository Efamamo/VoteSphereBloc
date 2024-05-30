import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:vote_sphere/local_storage/secure_storage.dart';
import 'package:http/http.dart' as http;

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(SettingsInitial()) {
    on<LoadSettingEvent>(loadSettingEvent);
    on<NavigateToChangePasswordEvent>(navigateToChangePasswordEvent);
    on<ChangePaswordEvent>(changePaswordEvent);
    on<DeleteAccountEvent>(deleteAccountEvent);
  }

  FutureOr<void> loadSettingEvent(
      LoadSettingEvent event, Emitter<SettingsState> emit) async {
    emit(SettingsLoadingState());

    final secureStorage = SecureStorage().secureStorage;
    final username = await secureStorage.read(key: 'username');
    final email = await secureStorage.read(key: "email");

    emit(SettingsLoadedState(username: username, email: email));
  }

  FutureOr<void> navigateToChangePasswordEvent(
      NavigateToChangePasswordEvent event, Emitter<SettingsState> emit) {
    emit(NavigateToUpdatePasswordState());
  }

  FutureOr<void> changePaswordEvent(
      ChangePaswordEvent event, Emitter<SettingsState> emit) async {
    String uri = 'http://localhost:9000/auth/changePassword';
    final url = Uri.parse(uri);
    final secureStorage = SecureStorage().secureStorage;
    final token = await secureStorage.read(key: 'token');
    final body = {
      "oldPassword": event.oldPassword,
      "newPassword": event.newPassword
    };
    final jsonBody = jsonEncode(body);
    final headers = {
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token'
    };

    final res = await http.patch(url, headers: headers, body: jsonBody);
    print(res.body);
    if (res.statusCode == 200) {
      emit(ChangePasswordSuccessState());
    } else {
      final decodedBody = jsonDecode(res.body);
      var error = decodedBody["message"];
      if (decodedBody["message"] is! String) {
        error = decodedBody["message"][0];
      }
      emit(ChangePasswordErrorState(error: error));
    }
  }

  FutureOr<void> deleteAccountEvent(
      DeleteAccountEvent event, Emitter<SettingsState> emit) async {
    final secureStorage = SecureStorage().secureStorage;
    final token = await secureStorage.read(key: 'token');
    String uri = 'http://localhost:9000/auth/deleteAccount';
    final url = Uri.parse(uri);
    final headers = {
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token'
    };
    final res = await http.delete(url, headers: headers);
    print(res.body);
    await secureStorage.deleteAll();
  }
}
