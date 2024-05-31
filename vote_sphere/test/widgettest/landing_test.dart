import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vote_sphere/application/blocs/landing_bloc.dart';
import 'package:vote_sphere/presentation/screens/landing_page.dart';

class MockLandingBloc extends MockBloc<LandingEvent, LandingState>
    implements LandingBloc {}

void main() {
  LandingBloc landingBloc =
      MockLandingBloc(); // Initialize the landingBloc variable

  setUp(() {
    landingBloc = MockLandingBloc();
  });

  tearDown(() {
    landingBloc.close();
  });

  group('LandingPage Widget Tests', () {
    testWidgets('LandingPage should be created and rendered',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        BlocProvider<LandingBloc>.value(
          value: landingBloc,
          child: MaterialApp(home: LandingPage()),
        ),
      );

      expectLater(find.byType(LandingPage), findsOneWidget,
          reason: 'LandingPage should be created and rendered');
    });

    testWidgets('LandingPage should display a welcome message',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        BlocProvider<LandingBloc>.value(
          value: landingBloc,
          child: MaterialApp(home: LandingPage()),
        ),
      );

      expectLater(find.text('Welcome to VoteSphere'), findsOneWidget,
          reason: 'LandingPage should display a welcome message');
    });

    testWidgets('LandingPage should have a login button',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        BlocProvider<LandingBloc>.value(
          value: landingBloc,
          child: MaterialApp(home: LandingPage()),
        ),
      );

      expectLater(find.byKey(Key('loginButton')), findsOneWidget,
          reason: 'LandingPage should have a login button');
    });
  });
}
