import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vote_sphere/presentation/screens/new_polls.dart';

void main() {
  group('NewPolls Widget Tests', () {
    testWidgets('NewPolls widget should contain TextEditingControllers', (WidgetTester tester) async {
      // Create the widget by telling the tester to build it.
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NewPolls(
              question: TextEditingController(),
              choice1: TextEditingController(),
              choice2: TextEditingController(),
              choice3: TextEditingController(),
              choice4: TextEditingController(),
              choice5: TextEditingController(),
              questionError: '',
            ),
          ),
        ),
      );

      // Create the Finders.
      final questionFinder = find.byType(TextEditingController);
      final choiceFinder = find.byType(TextEditingController);

      // Use the `findsWidgets` matcher to verify that the Text widgets appear exactly as expected in the widget tree.
      expect(questionFinder, findsOneWidget);
      expect(choiceFinder, findsNWidgets(5));
    });

    testWidgets('NewPolls widget should display question error message', (WidgetTester tester) async {
      // Create the widget by telling the tester to build it.
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NewPolls(
              question: TextEditingController(),
              choice1: TextEditingController(),
              choice2: TextEditingController(),
              choice3: TextEditingController(),
              choice4: TextEditingController(),
              choice5: TextEditingController(),
              questionError: 'Invalid question',
            ),
          ),
        ),
      );

      // Create the Finder.
      final errorFinder = find.text('Invalid question');

      // Use the `findsOneWidget` matcher to verify that the error message appears in the widget tree.
      expect(errorFinder, findsOneWidget);
    });
  });
}