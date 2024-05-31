import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vote_sphere/application/blocs/settings_bloc.dart';
import 'package:vote_sphere/infrastructure/repositories/settings_repository.dart';

class MockSettingsRepository extends Mock implements SettingsRepository {
  Future<Map<String, String>> loadSetting(String userId) async {
    return {"username": "testUser", "email": "test@example.com"};
  }

  Future<String> changePassword(String currentPassword, String newPassword) async {
    return "success";
  }

  Future<bool> deleteAccount() async {
    return true;
  }
}

// New event class
// New event class
class ChangePasswordEvent extends SettingsBloc{
  final String currentPassword;
  final String newPassword;

  ChangePasswordEvent({required this.currentPassword, required this.newPassword});
}

void main() {
  group('SettingsBloc', () {
    late SettingsBloc bloc;
    late MockSettingsRepository mockSettingsRepository;

    setUp(() {
      mockSettingsRepository = MockSettingsRepository();
      bloc = SettingsBloc();
    });

    tearDown(() {
      bloc.close();
    });

    test('initial state is SettingsInitial', () {
      expect(bloc.state, SettingsInitial());
    });

    group('LoadSettingEvent', () {
      blocTest<SettingsBloc, SettingsState>(
        'emits [SettingsLoadedState] when successful',
        build: () {
          when(() => mockSettingsRepository.loadSetting(any()))
         .thenAnswer((_) async => {"username": "testUser", "email": "test@example.com"});
          return bloc;
        },
        act: (bloc) => bloc.add(LoadSettingEvent()),
        expect: () => [SettingsLoadedState(username: "testUser", email: "test@example.com", role: null)],
      );
    });

    group('NavigateToChangePasswordEvent', () {
      blocTest<SettingsBloc, SettingsState>(
        'emits [NavigateToUpdatePasswordState] when successful',
        build: () => bloc,
        act: (bloc) => bloc.add(NavigateToChangePasswordEvent()),
        expect: () => [NavigateToUpdatePasswordState()],
      );
    });

    group('DeleteAccountEvent', () {
      blocTest<SettingsBloc, SettingsState>(
        'emits [DeleteAccountState] when successful',
        build: () {
          when(() => mockSettingsRepository.deleteAccount()).thenAnswer((_) async => true);
          return bloc;
        },
        act: (bloc) => bloc.add(DeleteAccountEvent()),
        expect: () => [DeleteAccountState()],
      );

      blocTest<SettingsBloc, SettingsState>(
        'emits [ChangePasswordErrorState] when unsuccessful',
        build: () {
          when(() => mockSettingsRepository.deleteAccount()).thenAnswer((_) async => false);
          return bloc;
        },
        act: (bloc) => bloc.add(DeleteAccountEvent()),
        expect: () => [ChangePasswordErrorState(error: "cant delete the account now")],
      );
    });
  });
}