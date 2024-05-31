import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:vote_sphere/local_storage/secure_storage.dart';
import 'package:vote_sphere/presentation/screens/home/bloc/home_bloc.dart';

part 'landing_event.dart';
part 'landing_state.dart';

class LandingBloc extends Bloc<LandingEvent, LandingState> {
  LandingBloc() : super(LandingInitial()) {
    on<LoginPageButtonNavigateEvent>(loginPageButtonNavigateEvent);
    on<SignupPageButtonNavigateEvent>(signupPageButtonNavigateEvent);
  }

  FutureOr<void> loginPageButtonNavigateEvent(
      LoginPageButtonNavigateEvent event, Emitter<LandingState> emit) {
    emit(LandingNavigateToLogin());
  }

  FutureOr<void> signupPageButtonNavigateEvent(
      SignupPageButtonNavigateEvent event, Emitter<LandingState> emit) {
    emit(LandingNavigateToSignup());
  }
}
