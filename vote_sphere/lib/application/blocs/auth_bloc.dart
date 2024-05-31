import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:vote_sphere/infrastructure/repositories/auth_repository.dart';
part '../../presentation/events/auth_event.dart';
part '../../presentation/states/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<NavigateSignUpEvent>(signUpEvent);
    on<LogInEvent>(logInEvent);
    on<NavigateToLoginEvent>(navigateToLoginEvent);
    on<SignupUserEvent>(signupUserEvent);
    on<SignoutEvent>(signoutEvent);
  }

  FutureOr<void> signUpEvent(
      NavigateSignUpEvent event, Emitter<AuthState> emit) {
    emit(LoginNavigateToSignupState());
  }

  FutureOr<void> logInEvent(LogInEvent event, Emitter<AuthState> emit) async {
    String res = await AuthRepository.login(event);
    if (res == "success") {
      emit(LogInSuccessState());
    } else {
      emit(LogInErrorState(error: res));
    }
  }

  FutureOr<void> navigateToLoginEvent(
      NavigateToLoginEvent event, Emitter<AuthState> emit) {
    emit(SignupNavigateToLoginState());
  }

  FutureOr<void> signupUserEvent(
      SignupUserEvent event, Emitter<AuthState> emit) async {
    String res = await AuthRepository.signUp(event);

    if (res == "success") {
      emit(SignUpSuccessState());
    } else {
      emit(SignupError(error: res));
    }
  }

  FutureOr<void> signoutEvent(
      SignoutEvent event, Emitter<AuthState> emit) async {
    await AuthRepository.signout();
    emit(SignoutState());
  }
}
