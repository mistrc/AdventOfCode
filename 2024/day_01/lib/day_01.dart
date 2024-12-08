import 'dart:io';
import 'dart:math';

List<String> getData(bool useSample) {
  return useSample
      ? File("data/sampleData").readAsLinesSync()
      : File("data/data").readAsLinesSync();
}

int part1({required bool useSample}) {
  final lines = getData(useSample);

  final left = <int>[];
  final right = <int>[];

  for (var line in lines) {
    final re = RegExp(r' +');
    final parts = line.split(re);

    assert(parts.length == 2);

    left.add(int.parse(parts[0]));

    right.add(int.parse(parts[1]));
  }

  left.sort();
  right.sort();

  final leftIter = left.iterator;
  final rightIter = right.iterator;

  int total = 0;

  while (leftIter.moveNext() && rightIter.moveNext()) {
    total += max<int>(leftIter.current, rightIter.current) -
        min<int>(leftIter.current, rightIter.current);
  }

  return total;
}

int part2({required bool useSample}) {
  final lines = getData(useSample);

  final left = <int>[];
  final right = <int, int>{};

  for (var line in lines) {
    final re = RegExp(r' +');
    final parts = line.split(re);

    assert(parts.length == 2);

    left.add(int.parse(parts[0]));

    final rightNum = int.parse(parts[1]);

    right.update(rightNum, (value) => value + 1, ifAbsent: () => 1);
  }

  int total = 0;

  for (var leftVal in left) {
    if (right.containsKey(leftVal)) {
      total += (leftVal * right[leftVal]!);
    }
  }

  return total;
}
