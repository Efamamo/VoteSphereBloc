import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:vote_sphere/local_storage/secure_storage.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<NavigateSignUpEvent>(signUpEvent);
    on<LogInEvent>(logInEvent);
    on<NavigateToLoginEvent>(navigateToLoginEvent);
    on<SignupUserEvent>(signupUserEvent);
  }

  FutureOr<void> signUpEvent(
      NavigateSignUpEvent event, Emitter<AuthState> emit) {
    emit(LoginNavigateToSignupState());
  }

  FutureOr<void> logInEvent(LogInEvent event, Emitter<AuthState> emit) async {
    String uri = 'http://localhost:9000/auth/signin';
    final url = Uri.parse(uri);

    final body = {"username": event.username, "password": event.password};
    final jsonBody = jsonEncode(body);
    final headers = {"Content-Type": "application/json"};

    final res = await http.post(url, headers: headers, body: jsonBody);
    Map response = jsonDecode(res.body);
    if (response.containsKey('message')) {
      var error = response["message"];

      if (error is! String) {
        error = error[0];
      }
      emit(LogInErrorState(error: error));
    } else {
      final secureStorage = SecureStorage().secureStorage;

      await secureStorage.write(key: "role", value: response["role"]);
      await secureStorage.write(key: "token", value: response["accessToken"]);
      await secureStorage.write(key: "username", value: response["username"]);
      await secureStorage.write(key: "group", value: response["groupID"]);

      emit(LogInSuccessState());
    }
  }

  FutureOr<void> navigateToLoginEvent(
      NavigateToLoginEvent event, Emitter<AuthState> emit) {
    emit(SignupNavigateToLoginState());
  }

  FutureOr<void> signupUserEvent(
      SignupUserEvent event, Emitter<AuthState> emit) async {
    String uri = 'http://localhost:9000/auth/signup';
    final url = Uri.parse(uri);
    final body = {
      "username": event.username,
      "role": event.role,
      "email": event.email,
      "password": event.password
    };

    final jsonBody = jsonEncode(body);
    final headers = {"Content-Type": "application/json"};

    final res = await http.post(url, headers: headers, body: jsonBody);
    Map response = jsonDecode(res.body);
    if (response.containsKey('message')) {
      var error = response["message"];

      if (error is! String) {
        error = error[0];
      }
      emit(SignupError(error: error));
    } else {
      final secureStorage = SecureStorage().secureStorage;
      await secureStorage.write(key: "role", value: response["role"]);
      await secureStorage.write(key: "token", value: response["accessToken"]);
      await secureStorage.write(key: "username", value: response["username"]);
      await secureStorage.write(key: "group", value: response["groupID"]);

      emit(SignUpSuccessState());
    }
  }
}
