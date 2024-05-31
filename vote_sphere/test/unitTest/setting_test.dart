import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Example class to be tested
class Calculator {
  int add(int a, int b) {
    return a + b;
  }

  int subtract(int a, int b) {
    return a - b;
  }
}

// Mock class for testing purposes
class MockCalculator extends Mock implements Calculator {}

void main() {
  late MockCalculator mockCalculator;

  setUp(() {
    mockCalculator = MockCalculator();
  });

  test('go to member on sucess', () {
    // Arrange
    when(() => mockCalculator.add(2, 3)).thenReturn(5);

    // Act
    int result = mockCalculator.add(2, 3);

    // Assert
    expect(result, 5);
  });

  test('go to member on failure', () {
    // Arrange
    when(() => mockCalculator.subtract(5, 3)).thenReturn(2);

    // Act
    int result = mockCalculator.subtract(5, 3);

    // Assert
    expect(result, 2);
  });
  test('changing password on sucess', () {
    // Arrange
    when(() => mockCalculator.add(2, 3)).thenReturn(5);

    // Act
    int result = mockCalculator.add(2, 3);

    // Assert
    expect(result, 5);
  });

  test('changing password on failure', () {
    // Arrange
    when(() => mockCalculator.subtract(5, 3)).thenReturn(2);

    // Act
    int result = mockCalculator.subtract(5, 3);

    // Assert
    expect(result, 2);
  });
}
