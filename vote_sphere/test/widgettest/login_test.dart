import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vote_sphere/presentation/screens/auth/login.dart';

void main() {
  testWidgets('LoginPage should render correctly', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: LoginPage()));
    // Verify that the login text is displayed
    expect(find.text('Login'), findsOneWidget);
    // Verify that the username field is displayed
    expect(find.byKey( ValueKey('usernameField')), findsOneWidget);
    // Verify that the password field is displayed
    expect(find.byKey( ValueKey('passwordField')), findsOneWidget);
    // Verify that the login button is displayed
    expect(find.byKey( ValueKey('loginButton')), findsOneWidget);
    // Verify that the sign up text is displayed
    expect(find.text("Don't you have an account"), findsOneWidget);
  });

  testWidgets('LoginPage should show error message on login failure', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: LoginPage()));
    // Enter invalid username and password
    await tester.enterText(find.byKey(const ValueKey('usernameField')), 'invalid_username');
    await tester.enterText(find.byKey(const ValueKey('passwordField')), 'invalid_password');
    // Tap on the login button
    await tester.tap(find.byKey(const ValueKey('loginButton')));
    await tester.pump();
    // Verify that the error message is displayed
    expect(find.text('Invalid username or password'), findsOneWidget);
  });

  testWidgets('LoginPage should navigate to signup page on sign up text tap', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: LoginPage()));
    // Tap on the sign up text
    await tester.tap(find.text("Don't you have an account"));
    await tester.pump();
    // Verify that the signup page is navigated to
    expect(find.text('Sign up'), findsOneWidget);
  });

}