import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import './auth_bloc_mock.dart'; // Update this path accordingly

void main() {
  late AuthBloc authBloc;

  setUp(() {
    authBloc = AuthBloc();
  });

  tearDown(() {
    authBloc.close();
  });

  group('AuthBloc Tests', () {
    test('initial state is AuthInitial', () {
      expect(authBloc.state, isA<AuthInitial>());
    });

    blocTest<AuthBloc, AuthState>(
      'emits [LoginNavigateToSignupState] when NavigateToSignup is added',
      build: () => authBloc,
      act: (bloc) => bloc.add(NavigateToSignup()),
      expect: () => [isA<LoginNavigateToSignupState>()],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [SignupNavigateToLoginState] when NavigateToLogin is added',
      build: () => authBloc,
      act: (bloc) => bloc.add(NavigateToLogin()),
      expect: () => [isA<SignupNavigateToLoginState>()],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [LogInSuccessState] when LogIn with correct credentials is added',
      build: () => authBloc,
      act: (bloc) =>
          bloc.add(LogIn(username: 'username', password: 'password')),
      expect: () => [isA<LogInSuccessState>()],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [LogInErrorState] when LogIn with incorrect credentials is added',
      build: () => authBloc,
      act: (bloc) =>
          bloc.add(LogIn(username: 'wrongusername', password: 'wrongpassword')),
      expect: () => [isA<LogInErrorState>()],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [SignUpSuccessState] when SignUp with correct details is added',
      build: () => authBloc,
      act: (bloc) => bloc.add(SignUp(
        username: 'username',
        password: 'password',
        email: 'email',
        role: 'role',
      )),
      expect: () => [isA<SignUpSuccessState>()],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [SignupError] when SignUp with incorrect details is added',
      build: () => authBloc,
      act: (bloc) => bloc.add(SignUp(
        username: 'wrongusername',
        password: 'wrongpassword',
        email: 'wrongemail',
        role: 'wrongrole',
      )),
      expect: () => [isA<SignupError>()],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [SignoutState] when Signout is added',
      build: () => authBloc,
      act: (bloc) => bloc.add(Signout()),
      expect: () => [isA<SignoutState>()],
    );
  });
}
