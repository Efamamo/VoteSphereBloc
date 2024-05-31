import 'package:mockito/mockito.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:test/test.dart';
import 'package:vote_sphere/presentation/screens/auth/bloc/auth_bloc.dart';
import 'package:vote_sphere/local_storage/secure_storage.dart';

class MockAuthBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc {}
class MockSecureStorage extends Mock implements SecureStorage {}

void main() {
  group('AuthBloc', () {
    AuthBloc authBloc;
    SecureStorage secureStorage;

    setUp(() {
      secureStorage = MockSecureStorage();
      authBloc = AuthBloc(secureStorage: secureStorage);
    });

    tearDown(() {
      authBloc?.close();
    });

    // Add your bloc tests here
  });
}