import 'package:day_02/day_02.dart';
import 'package:test/test.dart';

void main() {
  test('part 1 sample data', () {
    expect(part1(useSample: true), 2);
  });

  test('part 1 actual data', () {
    expect(part1(useSample: false), 230);
  });

  test('part 2 sample data', () {
    expect(part2(useSample: true), 4);
  });

  test('part 2 actual data', () {
    expect(part2(useSample: false), 301);
  });

  final testCases = <(List<int>, bool)>[
    // ([1, 2, 3, 4, 5], true),
    // ([1, 4, 7, 10, 13], true),
    // ([10, 4, 7, 10, 13], true),
    // ([4, 4, 7, 10, 13], true),
    // ([1, 4, 4, 7, 10], true),
    // ([1, 4, 7, 7, 10], true),
    // ([1, 4, 7, 10, 10], true),
    ([1, 4, 7, 5, 6], true),
    // ([10, 4, 7, 10, 13], true),
    // ([1, 4, 7, 10, 16], true),
  ];

  for (var testCase in testCases) {
    test('test name', () {
      bool isSafe = false;

      final parts = testCase.$1;

      if (checkIfSafe(parts)) {
        isSafe = true;
        ;
      } else {
        for (var i = 0; i < parts.length; i++) {
          final lessParts = [...parts];
          lessParts.removeAt(i);

          if (checkIfSafe(lessParts)) {
            isSafe = true;
            break;
          }
        }
      }

      expect(isSafe, testCase.$2,
          reason: testCase.$1.map((e) => '$e').reduce((a, b) => '$a, $b'));
    });
  }
}
