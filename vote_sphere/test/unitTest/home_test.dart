import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';
import 'package:vote_sphere/application/blocs/auth_bloc.dart';
import 'package:vote_sphere/application/blocs/home_bloc.dart';
import 'auth_test.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Define the PollDeletedState class
class PollDeletedState {
  final int pollId;

  PollDeletedState({required this.pollId});
}

void main() {
  group('HomeBloc', () {
    HomeBloc homeBloc;
    MockSecureStorage secureStorage;

    final List<Map<String, dynamic>> polls = [
      {'id': 1, 'question': 'Question 1', 'options': ['Option 1', 'Option 2']},
      {'id': 2, 'question': 'Question 2', 'options': ['Option 3', 'Option 4']}
    ];

    setUp(() {
      secureStorage = MockSecureStorage();
      homeBloc = HomeBloc();
    });

    test('LoadHomeEvent should emit HomeWithPollState', () async {
      // Mock the necessary dependencies
      MockSecureStorage secureStorage = MockSecureStorage();
      when(secureStorage.read(key: 'group')).thenAnswer((_) async => 'group1');
      when(secureStorage.read(key: 'role')).thenAnswer((_) async => 'admin');
      when(secureStorage.read(key: 'username')).thenAnswer((_) async => 'user1');
      when(secureStorage.read(key: 'token')).thenAnswer((_) async => 'token1');
      when(secureStorage.read(key: 'email')).thenAnswer((_) async => 'email1');

      // Mock the HTTP response
      final polls = [
        {'id': 1, 'question': 'Question 1', 'options': ['Option 1', 'Option 2']},
        {'id': 2, 'question': 'Question 2', 'options': ['Option 3', 'Option 4']}
      ];
      when(http.get(Uri.parse('http://localhost:9000/polls'), headers: anyNamed('headers')))
        .thenAnswer((_) async => Response(jsonEncode(polls), 200));

      // Add the LoadHomeEvent to the bloc
      HomeBloc homeBloc = HomeBloc();
      homeBloc.add(LoadHomeEvent());

      // Expect the HomeWithPollState to be emitted
      expectLater(homeBloc, emitsInOrder([
        isA<HomeWithPollState>().having((state) => state.group, 'group', 'group1'),
        isA<HomeWithPollState>().having((state) => state.username, 'username', 'user1'),
        isA<HomeWithPollState>().having((state) => state.polls, 'polls', polls),
        isA<HomeWithPollState>().having((state) => state.role, 'role', 'admin'),
        isA<HomeWithPollState>().having((state) => state.email, 'email', 'email1'),
        isA<HomeWithPollState>().having((state) => state.token, 'token', 'token1'),
      ]));

      // Run the test
      await homeBloc.close();
    });

    test('DeletePollEvent should emit PollDeletedState', () async {
      // Mock the necessary dependencies
      MockSecureStorage secureStorage = MockSecureStorage();
      when(secureStorage.read(key: 'group')).thenAnswer((_) async => 'group1');
      when(secureStorage.read(key: 'token')).thenAnswer((_) async => 'token1');

      // Mock the HTTP response
      when(http.delete(Uri.parse('http://localhost:9000/polls/1'), headers: anyNamed('headers')))
        .thenAnswer((_) async => Response('', 200));

      // Add the DeletePollEvent to the bloc
      HomeBloc homeBloc = HomeBloc();
      homeBloc.add(DeletePollEvent(pollId: 1));

      // Expect the PollDeletedState to be emitted
      expectLater(homeBloc, emitsInOrder([
        isA<HomeWithPollState>().having((state) => state.group, 'group', 'group1'),
        isA<HomeWithPollState>().having((state) => state.username, 'username', 'user1'),
        isA<HomeWithPollState>().having((state) => state.polls, 'polls', polls),
        isA<HomeWithPollState>().having((state) => state.role, 'role', 'admin'),
        isA<HomeWithPollState>().having((state) => state.email, 'email', 'email1'),
        isA<HomeWithPollState>().having((state) => state.token, 'token', 'token1'),
        isA<PollDeletedState>().having((state) => state.pollId, 'pollId', 1),
      ]));

      // Run the test
      await homeBloc.close();
    });
  });
}