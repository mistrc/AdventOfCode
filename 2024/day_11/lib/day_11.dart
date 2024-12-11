import 'dart:io';
import 'dart:math';

Iterable<int> getData(bool useSample) {
  final lines = useSample
      ? File("data/sampleData").readAsLinesSync()
      : File("data/data").readAsLinesSync();

  return lines[0].split(' ').map((e) => int.parse(e));
}

({int left, int right})? getDigits(int val) {
  final numberOfDigits = (log(val) / log(10)).toInt();

  if (numberOfDigits.isEven) return null;

  final half = (numberOfDigits + 1) ~/ 2;
  final splitter = pow(10, half).toInt();

  final right = val % splitter;
  final left = val ~/ splitter;

  return (left: left, right: right);
}

final memoised = <int, List<int>>{};
Iterable<int> blink(int entry) {
  if (0 == entry) return [1];

  if (memoised.containsKey(entry)) return memoised[entry]!;

  final digits = getDigits(entry);

  if (null != digits) {
    memoised[entry] = [digits.left, digits.right];
    return [digits.left, digits.right];
  }

  final toReturn = 2024 * entry;
  memoised[entry] = [toReturn];
  return [toReturn];
}

int func({required bool useSample, required int numberOfLoops}) {
  Iterable<int> data = getData(useSample);

  var numberOfUniqueNumbers = <int, int>{};
  for (var entry in data) {
    numberOfUniqueNumbers.update(entry, (value) => value + 1,
        ifAbsent: () => 1);
  }

  for (var i = 0; i < numberOfLoops; i++) {
    final nextArrangement = <int, int>{};
    for (var key in numberOfUniqueNumbers.keys) {
      final list = blink(key);
      for (var item in list) {
        nextArrangement.update(
            item, (value) => value + numberOfUniqueNumbers[key]!,
            ifAbsent: () => numberOfUniqueNumbers[key]!);
      }
    }

    numberOfUniqueNumbers = nextArrangement;
  }

  return numberOfUniqueNumbers.values.reduce((a, b) => a + b);
}

int part1({required bool useSample}) {
  return func(numberOfLoops: 25, useSample: useSample);
}

int part2({required bool useSample}) {
  return func(numberOfLoops: 75, useSample: useSample);
}
