part of '../../application/blocs/landing_bloc.dart';

@immutable
sealed class LandingState {}

abstract class LandingActionState extends LandingState {}

final class LandingInitial extends LandingState {}

class LandingNavigateToLogin extends LandingActionState {}

class LandingNavigateToSignup extends LandingActionState {}
