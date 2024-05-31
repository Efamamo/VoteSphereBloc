part of '../../application/blocs/landing_bloc.dart';

@immutable
sealed class LandingEvent {}

class SignupPageButtonNavigateEvent extends LandingEvent {}

class LoginPageButtonNavigateEvent extends LandingEvent {}
