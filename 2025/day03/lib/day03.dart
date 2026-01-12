import 'dart:io';
import 'dart:math';

int calculate() {
  return 6 * 7;
}

bool usingSample = false;

void myPrint(String str) {
  if (usingSample) print(str);
}

(int, int) maxDigit(String str) {
  int current = 0;

  for (var i = 0; i < str.length; i++) {
    current = max(current, int.parse(str[i]));
  }

  final position = str.indexOf('$current');

  return (current, position);
}

int part1(bool useSample) {
  usingSample = useSample;

  final lines = useSample
      ? File("data/sampleData").readAsLinesSync()
      : File("data/data").readAsLinesSync();

  int total = 0;

  for (var line in lines) {
    final first = line.substring(0, line.length - 1);

    final firstDigit = maxDigit(first);

    final second = line.substring(firstDigit.$2 + 1);

    final secondDigit = maxDigit(second);

    final joltage = 10 * firstDigit.$1 + secondDigit.$1;

    myPrint('Jolt=$joltage from line=$line');

    total += joltage;
  }

  myPrint('Total=$total');

  return total;
}

(int, int) digit(String line, int start, int id) {
  // myPrint('start=$start, id=$id, line=$line');
  final str = line.substring(start, line.length - (numberOfDigits - 1 - id));

  final found = maxDigit(str);
  // myPrint('Gives a values of ${found.$1} at position ${found.$2}');

  return (found.$1, found.$2 + start);
}

const numberOfDigits = 12;

int part2(bool useSample) {
  usingSample = useSample;

  final lines = useSample
      ? File("data/sampleData").readAsLinesSync()
      : File("data/data").readAsLinesSync();

  int total = 0;

  for (var line in lines) {
    int joltage = 0;
    int startPos = 0;
    for (var i = 0; i < numberOfDigits; i++) {
      final found = digit(line, startPos, i);

      startPos = found.$2 + 1;
      joltage = (10 * joltage) + found.$1;
    }

    myPrint('Jolt=$joltage from line=$line');

    total += joltage;
  }

  myPrint('Total=$total');

  return total;
}
