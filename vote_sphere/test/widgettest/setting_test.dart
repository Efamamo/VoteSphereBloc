import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:vote_sphere/application/blocs/settings_bloc.dart';
import 'package:vote_sphere/presentation/screens/settings.dart';

void main() {
  group('Settings Page Tests', () {
    testWidgets('Verify presence of image, list tiles, and row widgets',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Settings(),
      ));

      expect(find.byType(Image), findsOneWidget);
      expect(find.byType(ListTile), findsNWidgets(2));
      expect(find.byType(Row), findsOneWidget);
    });

    testWidgets('Verify correct display of username and email',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Settings(),
      ));

      expect(find.text('username'), findsOneWidget);
      expect(find.text('email'), findsOneWidget);
    });
  });

  testWidgets('Verify presence of logout button', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Settings(),
    ));
    expect(find.byType(ElevatedButton), findsOneWidget);
  });

  testWidgets('Verify presence of dark mode switch',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Settings(),
    ));
    expect(find.byType(Switch), findsOneWidget);
  });

  testWidgets('Verify presence of language dropdown',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Settings(),
    ));
    expect(find.byType(DropdownButton), findsOneWidget);
  });
}
