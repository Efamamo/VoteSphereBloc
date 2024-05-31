import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vote_sphere/presentation/screens/home/bloc/home_bloc.dart';
import 'package:vote_sphere/presentation/screens/home/home.dart';
import 'package:vote_sphere/presentation/screens/home/no_polls.dart';
import 'package:vote_sphere/presentation/screens/home/no_group.dart';
import 'package:vote_sphere/presentation/screens/home/my_polls.dart';
import 'package:mockito/mockito.dart';

class MockHomeBloc extends Mock implements HomeBloc {}

void main() {
  group('Home Widget Tests', () {
    MockHomeBloc mockHomeBloc;

    setUp(() {
      mockHomeBloc = MockHomeBloc();
    });

    tearDown(() {
      mockHomeBloc = MockHomeBloc();
      mockHomeBloc.close();
    });

    testWidgets('should be created', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(
        BlocProvider<HomeBloc>(
          create: (context) {
            mockHomeBloc = MockHomeBloc();
            return mockHomeBloc;
          },
          child: MaterialApp(
            home: Home(),
          ),
        ),
      );
      // Verify that Home widget is created.
      expect(find.byType(Home), findsOneWidget);
    });

    testWidgets('should show CircularProgressIndicator when in LoadingState', (WidgetTester tester) async {
      // Mock the HomeBloc to return a LoadingState
      MockHomeBloc mockHomeBloc = MockHomeBloc();
      when(mockHomeBloc.state).thenReturn(LoadingState());

      // Build our app and trigger a frame.
      await tester.pumpWidget(
        BlocProvider<HomeBloc>.value(
          value: mockHomeBloc,
          child: MaterialApp(
            home: Home(),
          ),
        ),
      );

      // Verify that CircularProgressIndicator is displayed
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should show NoGroup widget when in NoGroupState', (WidgetTester tester) async {
      // Mock the HomeBloc to return a NoGroupState
      MockHomeBloc mockHomeBloc = MockHomeBloc();
      when(mockHomeBloc.state).thenReturn(NoGroupState(role: 'admin', group: '', token: '', username: '', email: ''));

      // Build our app and trigger a frame.
      await tester.pumpWidget(
        BlocProvider<HomeBloc>.value(
          value: mockHomeBloc,
          child: MaterialApp(
            home: Home(),
          ),
        ),
      );

      // Verify that NoGroup widget is displayed
      expect(find.byType(NoGroup), findsOneWidget);
    });

    testWidgets('should show NoPoll widget when in HomeWithPollState with empty polls list', (WidgetTester tester) async {
      // Mock the HomeBloc to return a HomeWithPollState with empty polls list
      MockHomeBloc mockHomeBloc = MockHomeBloc();
      when(mockHomeBloc.state).thenReturn(HomeWithPollState(polls: [], group: 'Group 1', role: 'user', username: '', email: '', token: ''));

      // Build our app and trigger a frame.
      await tester.pumpWidget(
        BlocProvider<HomeBloc>.value(
          value: mockHomeBloc,
          child: MaterialApp(
            home: Home(),
          ),
        ),
      );

      // Verify that NoPoll widget is displayed
      expect(find.byType(NoPoll), findsOneWidget);
    });

    testWidgets('should show MyPolls widget when in HomeWithPollState with non-empty polls list', (WidgetTester tester) async {
      // Mock the HomeBloc to return a HomeWithPollState with non-empty polls list
      MockHomeBloc mockHomeBloc = MockHomeBloc(); // Initialize the mockHomeBloc variable
      when(mockHomeBloc.state).thenReturn(HomeWithPollState(polls: ['Poll 1', 'Poll 2'], group: 'Group 1', role: 'user', username: '', email: '', token: ''));

      // Build our app and trigger a frame.
      await tester.pumpWidget(
        BlocProvider<HomeBloc>.value(
          value: mockHomeBloc,
          child: MaterialApp(
            home: Home(),
          ),
        ),
      );

      // Verify that MyPolls widget is displayed
      expect(find.byType(MyPolls), findsOneWidget);
    });
  });
}
