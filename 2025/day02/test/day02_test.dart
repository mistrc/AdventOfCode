import 'dart:math';

import 'package:day02/day02.dart' as lib;
import 'package:test/test.dart';

void main() {
  test('calculate', () {
    expect(lib.calculate(), 42);
  });

  group('test calculating how many digits', () {
    final inputData = <(int, int)>[
      (1, 1),
      (9, 1),
      (10, 2),
      (11, 2),
      (99, 2),
      (100, 3),
      (101, 3),
      (999, 3),
      (1000, 4),
      (1001, 4),
      (9999, 4),
      (10000, 5),
      (10001, 5),
      (99999, 5),
      (100000, 6),
      (100001, 6),
      (999999, 6),
      (1000000, 7),
      (10000000, 8),
      (100000000, 9),
      (1000000000, 10),
    ];

    for (var data in inputData) {
      final number = data.$1;
      final digitCount = data.$2;

      test('number of digits in $number', () {
        // Arrange
        final logOfNumber = log(number);
        final logOf10 = log(10);
        final ratio = logOfNumber / logOf10;

        // Act
        // final numberOfDigits = (ratio).floor() + 1;
        final numberOfDigits = lib.numberOfDigits(number);

        print('$number =>  numberOfDigits=$numberOfDigits');

        // Assert
        expect(numberOfDigits, digitCount);
      });
    }
  });
}
