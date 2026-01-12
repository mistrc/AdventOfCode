import 'dart:io';

import 'package:utils/utils.dart';

int calculate() {
  return 6 * 7;
}

final at = '@'.codeUnits.first;
final dot = '.'.codeUnits.first;

int part1(bool useSample) {
  usingSample = useSample;

  final lines = useSample
      ? File("data/sampleData").readAsLinesSync()
      : File("data/data").readAsLinesSync();

  final grid = Grid(lines);

  int counter = 0;

  for (var cell in grid) {
    if (at == cell.val) {
      final adjacentCells = grid.adjacentCells(cell.p);

      final bob = adjacentCells.map((e) => e.p);

      final filtered = adjacentCells.where((t) => t.val == at);

      myPrint(
        '${cell.p} returns ${bob.length} adjacent cells, with ${filtered.length} passing filter',
      );

      if (filtered.length < 4) ++counter;
    }
  }

  return counter;
}

int part2(bool useSample) {
  usingSample = useSample;

  final lines = useSample
      ? File("data/sampleData").readAsLinesSync()
      : File("data/data").readAsLinesSync();

  final grid = Grid(lines);

  int total = 0;
  int counter = 0;
  int failsafe = 0;

  do {
    counter = 0;
    for (var cell in grid) {
      if (at == cell.val) {
        final adjacentCells = grid.adjacentCells(cell.p);

        final bob = adjacentCells.map((e) => e.p);

        final filtered = adjacentCells.where((t) => t.val == at);

        myPrint(
          '${cell.p} returns ${bob.length} adjacent cells, with ${filtered.length} passing filter',
        );

        if (filtered.length < 4) {
          ++counter;
          grid.setCell(cell.p, dot);
        }
      }
    }
    total += counter;
    failsafe++;
  } while (counter > 0 && failsafe < 2000);

  print('failsafe = $failsafe');

  return total;
}
