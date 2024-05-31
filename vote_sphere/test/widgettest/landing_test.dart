import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vote_sphere/presentation/screens/landing/bloc/landing_bloc.dart';
import 'package:vote_sphere/presentation/screens/landing/landing_page.dart';

class MockLandingBloc extends MockBloc<LandingEvent, LandingState> implements LandingBloc {}

void main() {
  LandingBloc landingBloc = MockLandingBloc(); // Initialize the landingBloc variable

  setUp(() {
    landingBloc = MockLandingBloc();
  });

  tearDown(() {
    landingBloc.close();
  });

  group('LandingPage Widget Tests', () {
    testWidgets('LandingPage should be created and rendered', (WidgetTester tester) async {
      await tester.pumpWidget(
        BlocProvider<LandingBloc>.value(
          value: landingBloc,
          child: MaterialApp(home: LandingPage()),
        ),
      );

      expect(find.byType(LandingPage), findsOneWidget);
      print('LandingPage should be created and rendered - Passed');
    });

    testWidgets('LandingPage should display a welcome message', (WidgetTester tester) async {
      await tester.pumpWidget(
        BlocProvider<LandingBloc>.value(
          value: landingBloc,
          child: MaterialApp(home: LandingPage()),
        ),
      );

      expect(find.text('Welcome to VoteSphere'), findsOneWidget);
      print('LandingPage should display a welcome message - Passed');
    });

    testWidgets('LandingPage should have a login button', (WidgetTester tester) async {
      await tester.pumpWidget(
        BlocProvider<LandingBloc>.value(
          value: landingBloc,
          child: MaterialApp(home: LandingPage()),
        ),
      );

      expect(find.byKey(Key('loginButton')), findsOneWidget);
      print('LandingPage should have a login button - Passed');
    });
  });
}