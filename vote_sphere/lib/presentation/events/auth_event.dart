part of '../../application/blocs/auth_bloc.dart';

@immutable
sealed class AuthEvent {}

class LogInEvent extends AuthEvent {
  final String username;
  final String password;

  LogInEvent({required this.username, required this.password});
}

class NavigateSignUpEvent extends AuthEvent {}

class NavigateToLoginEvent extends AuthEvent {}

class SignupUserEvent extends AuthEvent {
  final String username;
  final String password;
  final String email;
  final String role;

  SignupUserEvent(
      {required this.username,
      required this.password,
      required this.email,
      required this.role});
}

class SignoutEvent extends AuthEvent {}
