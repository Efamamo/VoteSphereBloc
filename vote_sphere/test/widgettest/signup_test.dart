import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:vote_sphere/presentation/screens/auth/signUp.dart'; // replace with your actual app name

void main() {
  testWidgets('SignUp Widget Test', (WidgetTester tester) async {
     // Import the file that defines 'SignUp'

    await tester.pumpWidget(MaterialApp(home: SignUpPage()));

    // Verify that SignUp widget is shown
    expect(find.byType(SignUpPage), findsOneWidget);

    // Enter text into the TextFields
    await tester.enterText(find.byType(TextField).first, 'test@example.com');
    await tester.enterText(find.byType(TextField).at(1), 'password');

    // Tap the 'Sign Up' button and trigger a frame.
    await tester.tap(find.widgetWithText(ElevatedButton, 'Sign Up'));
    await tester.pump();

    // Check that there is a 'Loading' indicator after the button is pressed
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
  testWidgets('SignUp Widget Test - Invalid Email', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: SignUpPage()));
    
    // Enter an invalid email address
    await tester.enterText(find.byType(TextField).first, 'invalidemail');
    await tester.enterText(find.byType(TextField).at(1), 'password');
    
    await tester.tap(find.widgetWithText(ElevatedButton, 'Sign Up'));
    await tester.pump();
    
    // Verify that an error message is displayed
    expect(find.text('Invalid email address'), findsOneWidget);
  });

  testWidgets('SignUp Widget Test - Weak Password', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: SignUpPage()));
    
    // Enter a weak password
    await tester.enterText(find.byType(TextField).first, 'test@example.com');
    await tester.enterText(find.byType(TextField).at(1), 'weak');
    
    await tester.tap(find.widgetWithText(ElevatedButton, 'Sign Up'));
    await tester.pump();
    
    // Verify that an error message is displayed
    expect(find.text('Password is too weak'), findsOneWidget);
  });

}