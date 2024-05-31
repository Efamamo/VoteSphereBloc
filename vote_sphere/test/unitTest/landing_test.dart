import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vote_sphere/presentation/screens/landing/bloc/landing_bloc.dart';

void main() {
  group('LandingBloc', () {
    LandingBloc? landingBloc;

    setUp(() {
      landingBloc = LandingBloc();
    });

    tearDown(() {
      landingBloc?.close();
    });

    test('initial state is LandingInitial', () {
      expect(landingBloc?.state, equals(LandingInitial()));
    });

    test('LoginPageButtonNavigateEvent navigates to Login page', () {
      expectLater(
        landingBloc,
        emitsInOrder([LandingInitial(), LandingNavigateToLogin()]),
      ).then((_) {
        landingBloc?.add(LoginPageButtonNavigateEvent());
      });
    });

    test('SignupPageButtonNavigateEvent navigates to Signup page', () {
      expectLater(
        landingBloc,
        emitsInOrder([LandingInitial(), LandingNavigateToSignup()]),
      ).then((_) {
        landingBloc?.add(SignupPageButtonNavigateEvent());
      });
    });
  });
}