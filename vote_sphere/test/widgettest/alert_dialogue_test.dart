import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart'; // Import mocktail for mocking
import 'package:vote_sphere/presentation/widgets/alertdialog.dart';

// Import the widget to be tested

import 'package:vote_sphere/application/blocs/home_bloc.dart';

class MockHomeBloc extends Mock implements HomeBloc {}

void main() {
  late MockHomeBloc homeBloc;

  setUp(() {
    homeBloc = MockHomeBloc(); // Create a mock instance of HomeBloc
  });

  Widget buildTestableWidget(Widget widget) {
    return MaterialApp(
      home: Scaffold(body: widget),
    );
  }

  testWidgets('MyAlertDialog displays correctly and interacts with HomeBloc',
      (WidgetTester tester) async {
    // Pump the MyAlertDialog widget wrapped with necessary providers
    await tester.pumpWidget(
      BlocProvider.value(
        value: homeBloc,
        child: buildTestableWidget(MyAlertDialog()),
      ),
    );

    // Verify that the AlertDialog is shown with the correct title
    expect(find.text('Create Group'), findsOneWidget);

    // Simulate entering text into the TextField
    await tester.enterText(find.byType(TextField), 'Test Group');

    // Tap the "Create Group" button
    await tester.tap(find.text('Create Group'));
    await tester.pump(); // Rebuild the widget after the button tap

    // Verify that homeBloc.add was called with CreateGroup event
    verify(() => homeBloc.add(CreateGroup(groupName: 'Test Group'))).called(1);

    // Add a delay to observe the widget interaction in the test output
    await Future.delayed(Duration(seconds: 1));

    // Additional debug statements to print widget tree and state
    // Uncomment these for debugging purposes if needed
    // debugDumpApp();

    // Check for any uncaught errors during widget test
    final errors = tester.takeException();
    if (errors != null) {
      print('Widget test failed with exception: $errors');
    }

    // Assert that there are no errors
    expect(errors, isNull);
  });
}
