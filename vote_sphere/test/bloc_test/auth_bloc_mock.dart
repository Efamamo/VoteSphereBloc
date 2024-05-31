import 'package:flutter_bloc/flutter_bloc.dart';

// Define the states
abstract class AuthState {}

class AuthInitial extends AuthState {}

class LoginNavigateToSignupState extends AuthState {}

class SignupNavigateToLoginState extends AuthState {}

class LogInSuccessState extends AuthState {}

class LogInErrorState extends AuthState {
  final String error;
  LogInErrorState({required this.error});
}

class SignUpSuccessState extends AuthState {}

class SignupError extends AuthState {
  final String error;
  SignupError({required this.error});
}

class SignoutState extends AuthState {}

// Define the events
abstract class AuthEvent {}

class NavigateToSignup extends AuthEvent {}

class NavigateToLogin extends AuthEvent {}

class LogIn extends AuthEvent {
  final String username;
  final String password;
  LogIn({required this.username, required this.password});
}

class SignUp extends AuthEvent {
  final String username;
  final String password;
  final String email;
  final String role;
  SignUp({
    required this.username,
    required this.password,
    required this.email,
    required this.role,
  });
}

class Signout extends AuthEvent {}

// Define the bloc
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<NavigateToSignup>((event, emit) {
      emit(LoginNavigateToSignupState());
    });

    on<NavigateToLogin>((event, emit) {
      emit(SignupNavigateToLoginState());
    });

    on<LogIn>((event, emit) {
      if (event.username == 'username' && event.password == 'password') {
        emit(LogInSuccessState());
      } else {
        emit(LogInErrorState(error: 'error'));
      }
    });

    on<SignUp>((event, emit) {
      if (event.username == 'username' &&
          event.password == 'password' &&
          event.email == 'email' &&
          event.role == 'role') {
        emit(SignUpSuccessState());
      } else {
        emit(SignupError(error: 'error'));
      }
    });

    on<Signout>((event, emit) {
      emit(SignoutState());
    });
  }
}
