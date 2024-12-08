import 'dart:io';

List<List<int>> getData(bool useSample) {
  final textStrings = useSample
      ? File("data/sampleData").readAsLinesSync()
      : File("data/data").readAsLinesSync();

  return textStrings
      .map((e) => e.split(' ').map((e) => int.parse(e)).toList())
      .toList();
}

/// [diff] is left val - right val
bool increaseing(int diff) => -3 <= diff && diff <= -1;
bool decreaseing(int diff) => 1 <= diff && diff <= 3;
bool bad(int diff) => false;

bool Function(int) _getComparisonFunction(int fisrtVal, int secondVal) {
  final diff = fisrtVal - secondVal;

  if (increaseing(diff)) return increaseing;

  if (decreaseing(diff)) return decreaseing;

  return bad;
}

bool checkIfSafe(List<int> parts) {
  final fisrtVal = parts[0];
  int lastVal = parts[1];

  final func = _getComparisonFunction(fisrtVal, lastVal);

  final iter = parts.skip(2).iterator;

  while (iter.moveNext()) {
    final val = iter.current;

    if (!func(lastVal - val)) return false;

    lastVal = val;
  }

  return true;
}

int part1({required bool useSample}) {
  final lines = getData(useSample);

  int safeCount = 0;
  for (var parts in lines) {
    final isSafe = checkIfSafe(parts);

    if (isSafe) ++safeCount;
  }

  return safeCount;
}

/// Need for the first 4 elements to determine what is our function
///
/// Then we need to keep hold of 4 elements in order
/// to determine which is the bad element
int part2({required bool useSample}) {
  final lines = getData(useSample);

  int safeCount = 0;
  for (var parts in lines) {
    final isSafe = checkIfSafe(parts);

    if (isSafe) {
      ++safeCount;
    } else {
      for (var i = 0; i < parts.length; i++) {
        final lessParts = [...parts];
        lessParts.removeAt(i);

        if (checkIfSafe(lessParts)) {
          ++safeCount;
          break;
        }
      }
    }
  }

  return safeCount;
}
