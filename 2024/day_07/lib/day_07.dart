import 'dart:io';

final equations = <int, Iterable<int>>{};

void getData(bool useSample) {
  equations.clear();

  final lines = useSample
      ? File("data/sampleData").readAsLinesSync()
      : File("data/data").readAsLinesSync();

  for (var line in lines) {
    final parts = line.split(':');

    final target = int.parse(parts[0]);

    final inputs = parts[1].trim().split(' ').map((e) => int.parse(e));

    equations[target] = inputs;
  }
}

bool forPart1 = true;

bool canAchieveTarget(
    {required final int target,
    required final Iterator<int> iter,
    required Set<int> results}) {
  if (iter.moveNext()) {
    if (results.isEmpty) {
      return canAchieveTarget(
          target: target, iter: iter, results: {iter.current});
    } else {
      if (forPart1) {
        return canAchieveTarget(target: target, iter: iter, results: {
          ...results.map((e) => e + iter.current),
          ...results.map((e) => e * iter.current),
        });
      } else {
        return canAchieveTarget(target: target, iter: iter, results: {
          ...results.map((e) => e + iter.current),
          ...results.map((e) => e * iter.current),
          ...results.map((e) => int.parse('$e${iter.current}')),
        });
      }
    }
  } else {
    return results.contains(target);
  }
}

int part1({required bool useSample}) {
  getData(useSample);

  forPart1 = true;

  int total = 0;

  for (var equation in equations.entries) {
    if (canAchieveTarget(
        target: equation.key,
        iter: equation.value.iterator,
        results: {})) total += equation.key;
  }

  return total;
}

int part2({required bool useSample}) {
  getData(useSample);

  forPart1 = false;

  int total = 0;

  for (var equation in equations.entries) {
    if (canAchieveTarget(
        target: equation.key,
        iter: equation.value.iterator,
        results: {})) total += equation.key;
  }

  return total;
}
