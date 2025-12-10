import 'dart:collection';
import 'dart:io';
import 'dart:math';

import 'package:utils/utils.dart';

int calculate() {
  return 6 * 7;
}

class Range {
  final int start;
  final int end;

  const Range(this.start, this.end);

  bool overlaps(Range other) {
    return !(end < other.start || other.end < start);
  }

  Range join(Range other) {
    assert(overlaps(other));

    return Range(min(start, other.start), max(end, other.end));
  }

  @override
  String toString() => 'Range($start-$end)';
}

int rangeCompare(Range lhs, Range rhs) {
  if (lhs.overlaps(rhs)) return 0;

  return lhs.start.compareTo(rhs.start);
}

void _addToRange(Set<Range> ranges, Range range) {
  final existing = ranges.lookup(range);
  if (null == existing) {
    myPrint('Adding in range $range');
    ranges.add(range);
  } else {
    final newRange = existing.join(range);
    myPrint('Mergine $range into $existing, producing $newRange');
    ranges.remove(existing);

    _addToRange(ranges, newRange);
  }
}

int part1(bool useSample) {
  usingSample = useSample;

  final lines = useSample
      ? File("data/sampleData").readAsLinesSync()
      : File("data/data").readAsLinesSync();

  bool readingFreshIds = true;
  final ranges = SplayTreeSet<Range>(rangeCompare);
  int counter = 0;

  for (var line in lines) {
    if (line.isEmpty) {
      readingFreshIds = false;
    } else if (readingFreshIds) {
      final digits = line.split('-').map((e) => int.parse(e)).toList();

      assert(digits.length == 2);

      final range = Range(digits[0], digits[1]);

      _addToRange(ranges, range);

      myPrint('$ranges');
    } else {
      final productId = int.parse(line);
      final product = Range(productId, productId);

      if (ranges.contains(product)) {
        counter++;
        myPrint('$productId found in ranges');
      } else {
        myPrint('$productId NOT found in ranges');
      }
    }
  }

  return counter;
}

int part2(bool useSample) {
  usingSample = useSample;

  final lines = useSample
      ? File("data/sampleData").readAsLinesSync()
      : File("data/data").readAsLinesSync();

  bool readingFreshIds = true;
  final ranges = SplayTreeSet<Range>(rangeCompare);

  for (var line in lines) {
    if (line.isEmpty) {
      readingFreshIds = false;
    } else if (readingFreshIds) {
      final digits = line.split('-').map((e) => int.parse(e)).toList();

      assert(digits.length == 2);

      final range = Range(digits[0], digits[1]);

      _addToRange(ranges, range);

      myPrint('$ranges');
    }
  }

  int counter = 0;

  for (var range in ranges) {
    counter += 1 + range.end - range.start;
  }

  return counter;
}
