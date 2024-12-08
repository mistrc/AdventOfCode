import 'dart:io';

final rules = <int, Set<int>>{};
final sequences = <List<int>>[];

void populateRulesAndSequences(bool useSample) {
  rules.clear();
  sequences.clear();

  final lines = useSample
      ? File("data/sampleData").readAsLinesSync()
      : File("data/data").readAsLinesSync();

  for (var line in lines) {
    if (line.contains('|')) {
      final parts = line.split('|').map((e) => int.parse(e)).toList();

      rules.update(parts[1], (value) {
        value.add(parts[0]);
        return value;
      }, ifAbsent: () => {parts[0]});
    } else if (line.contains(',')) {
      final parts = line.split(',').map((e) => int.parse(e)).toList();
      sequences.add(parts);
    }
  }
}

/// Returns either
/// * null - indicating that the sequence passes the rules, or
/// * two numbers where the left is the number that breaks a rule and the rightmost digit that it should be on the right of
(int, int)? sequencePasses(List<int> sequence, int leftDigit) {
  // print('testing $sequence');
  final key = sequence.removeAt(0);

  if (rules.containsKey(key)) {
    final rulesSet = rules[key]!;

    // print('key $key has found ruleset $rulesSet');
    int i = 0;
    for (var element in sequence.reversed) {
      if (rulesSet.contains(element)) {
        return (leftDigit, leftDigit + sequence.length - i);
      }

      ++i;
    }
  }

  if (sequence.length > 1) {
    final result = sequencePasses(sequence, leftDigit + 1);

    if (null != result) return result;
  }

  return null;
}

int part1({required bool useSample}) {
  populateRulesAndSequences(useSample);

  int total = 0;

  for (var sequence in sequences) {
    if (null == sequencePasses([...sequence], 0)) {
      print('passed $sequence');
      final len = (sequence.length - 1) / 2;
      total += sequence[len.toInt()];
    }
  }

  return total;
}

int part2({required bool useSample}) {
  populateRulesAndSequences(useSample);

  int total = 0;

  for (var sequence in sequences) {
    var checkResult = sequencePasses([...sequence], 0);

    if (null != checkResult) {
      // assuming no infinate loops, i.e. rules are not bogus
      do {
        final toMove = sequence.removeAt(checkResult!.$1);
        // insertion point is now correct as left item was removed
        sequence.insert(checkResult.$2, toMove);

        checkResult = sequencePasses([...sequence], 0);
      } while (null != checkResult);

      print('reordered $sequence');
      final len = (sequence.length - 1) / 2;
      total += sequence[len.toInt()];
    }
  }

  return total;
}
