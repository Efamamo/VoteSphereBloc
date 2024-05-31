import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vote_sphere/presentation/screens/home/bloc/home_bloc.dart';
import 'package:vote_sphere/presentation/screens/member.dart';
import 'package:mockito/mockito.dart';

class MockHomeBloc extends Mock implements HomeBloc {}

void main() {
  group('Members Widget', () {
    HomeBloc? homeBloc;

    setUp(() {
      homeBloc = MockHomeBloc();
    });

    tearDown(() {
      homeBloc?.close();
    });

    testWidgets('renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        BlocProvider<HomeBloc>.value(
          value: homeBloc!,
          child: MaterialApp(home: Members()),
        ),
      );

      expect(find.byType(AppBar), findsOneWidget);
    });
  });

  testWidgets('renders AppBar with correct title', (WidgetTester tester) async {
    await tester.pumpWidget(
      BlocProvider<HomeBloc>.value(
        value: MockHomeBloc(),
        child: MaterialApp(home: Members()),
      ),
    );

    expect(find.text('Members'), findsOneWidget);
  });

  testWidgets('renders CircularProgressIndicator when loading members', (WidgetTester tester) async {
    HomeBloc? homeBloc;

    when(homeBloc!.state).thenReturn(MembersLoadingState());

    await tester.pumpWidget(
      BlocProvider<HomeBloc>.value(
        value: homeBloc!,
        child: MaterialApp(home: Members()),
      ),
    );

    final circularProgressFinder = find.byType(CircularProgressIndicator);
    expect(circularProgressFinder, findsOneWidget);
  });

  testWidgets('renders Add Member button when user is an admin', (WidgetTester tester) async {
    HomeBloc? homeBloc;

    when(homeBloc!.state).thenReturn(MembersLoadedState(role: 'Admin', members: []));

    await tester.pumpWidget(
      BlocProvider<HomeBloc>.value(
        value: homeBloc!,
        child: MaterialApp(home: Members()),
      ),
    );

    final addMemberButtonFinder = find.text('Add Member');
    expect(addMemberButtonFinder, findsOneWidget);
  });



}