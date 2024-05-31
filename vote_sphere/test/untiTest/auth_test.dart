import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vote_sphere/presentation/screens/auth/bloc/auth_bloc.dart';
import 'package:vote_sphere/local_storage/secure_storage.dart';

class MockSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  group('AuthBloc', () {
    late AuthBloc authBloc;
    late MockSecureStorage mockSecureStorage;

    setUp(() {
      mockSecureStorage = MockSecureStorage();
      when(() => mockSecureStorage.write(key: captureAny(), value: captureAny())).thenAnswer((_) async => null);
      when(() => mockSecureStorage.deleteAll()).thenAnswer((_) async => null);

      authBloc = AuthBloc()..add(LogInEvent(username: 'test', password: 'test'));
    });

    tearDown(() {
      authBloc.close();
    });

    test('initial state is AuthInitial', () {
      expect(authBloc.state, equals(AuthInitial()));
    });

blocTest<AuthBloc, AuthState>(
  'emits [LogInSuccessState] when LogInEvent is added',
  build: () {
    when(() => mockSecureStorage.write(key: captureAny(), value: captureAny())).thenAnswer((_) async {});
    return AuthBloc()..add(LogInEvent(username: 'test', password: 'test'));
  },
  act: (AuthBloc bloc) => bloc.add(LogInEvent(username: 'test', password: 'test')),
  expect: () => [LogInSuccessState()],
  verify: (_) {
    verify(() => mockSecureStorage.write(key: captureAny(), value: captureAny())).called(5);
  },
);

    blocTest<AuthBloc, AuthState>(
      'emits [LogInErrorState] when LogInEvent is added with invalid credentials',
      build: () {
        when(() => mockSecureStorage.write(key: captureAny(), value: captureAny())).thenAnswer((_) async => null);
        return AuthBloc()..add(LogInEvent(username: 'invalid', password: 'invalid'));
      },
      act: (AuthBloc bloc) => bloc.add(LogInEvent(username: 'invalid', password: 'invalid')),
      expect: () => [LogInErrorState(error: 'Invalid username or password.')],
      verify: (_) {
        verifyNever(() => mockSecureStorage.write(key: any(named: 'key'), value: any(named: 'value')));
      },
    );

  });
}