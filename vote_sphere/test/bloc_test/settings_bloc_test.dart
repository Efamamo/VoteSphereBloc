import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:bloc_test/bloc_test.dart';
import './settings_mock.dart';

class MockSettingsBloc extends MockBloc<SettingsEvent, SettingsState>
    implements SettingsBloc {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MockSettingsBloc mockSettingsBloc = MockSettingsBloc();

  setUp(() {
    mockSettingsBloc = MockSettingsBloc();
  });

  tearDown(() {
    mockSettingsBloc.close();
  });

  blocTest<MockSettingsBloc, SettingsState>(
    'SettingsBloc emits [SettingsLoading, ChangePasswordSuccess] when ChangePasswordEvent is successful',
    build: () {
      whenListen(
        mockSettingsBloc,
        Stream.fromIterable([
          SettingsLoading(),
          ChangePasswordSuccess(),
        ]),
      );
      return mockSettingsBloc;
    },
    act: (bloc) => bloc.add(const ChangePasswordEvent('newPassword')),
    expect: () => [
      SettingsLoading(),
      ChangePasswordSuccess(),
    ],
  );

  blocTest<MockSettingsBloc, SettingsState>(
    'SettingsBloc emits [SettingsLoading, ChangePasswordFailure] when ChangePasswordEvent fails',
    build: () {
      whenListen(
        mockSettingsBloc,
        Stream.fromIterable([
          SettingsLoading(),
          ChangePasswordFailure('Failed to change password'),
        ]),
      );
      return mockSettingsBloc;
    },
    act: (bloc) => bloc.add(ChangePasswordEvent('newPassword')),
    expect: () => [
      SettingsLoading(),
      ChangePasswordFailure('Failed to change password'),
    ],
  );

  blocTest<MockSettingsBloc, SettingsState>(
    'SettingsBloc emits [SettingsLoading, DeleteAccountSuccess] when DeleteAccountEvent is successful',
    build: () {
      whenListen(
        mockSettingsBloc,
        Stream.fromIterable([
          SettingsLoading(),
          DeleteAccountSuccess(),
        ]),
      );
      return mockSettingsBloc;
    },
    act: (bloc) => bloc.add(DeleteAccountEvent()),
    expect: () => [
      SettingsLoading(),
      DeleteAccountSuccess(),
    ],
  );

  blocTest<MockSettingsBloc, SettingsState>(
    'SettingsBloc emits [SettingsLoading, DeleteAccountFailure] when DeleteAccountEvent fails',
    build: () {
      whenListen(
        mockSettingsBloc,
        Stream.fromIterable([
          SettingsLoading(),
          DeleteAccountFailure('Failed to delete account'),
        ]),
      );
      return mockSettingsBloc;
    },
    act: (bloc) => bloc.add(DeleteAccountEvent()),
    expect: () => [
      SettingsLoading(),
      DeleteAccountFailure('Failed to delete account'),
    ],
  );
}
