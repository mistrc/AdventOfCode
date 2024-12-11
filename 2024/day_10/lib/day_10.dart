import 'dart:io';

List<List<int>> grid = [];
int maxX = 0;
int maxY = 0;

class Position {
  final int x;
  final int y;

  Position({required this.x, required this.y});

  @override
  int get hashCode => Object.hash(x, y);

  Position get up => Position(x: x, y: y - 1);
  Position get down => Position(x: x, y: y + 1);
  Position get left => Position(x: x - 1, y: y);
  Position get right => Position(x: x + 1, y: y);

  bool get isValid => 0 <= x && x < maxX && 0 <= y && y < maxY;

  int get value => isValid ? grid[y][x] : -1;

  Iterable<Position> findPositionsWithValue(int value) {
    final list = [up, down, left, right];

    return list.where((e) => e.isValid && e.value == value);
  }

  @override
  bool operator ==(Object other) {
    if (other is Position) {
      return x == other.x && y == other.y;
    }
    return false;
  }
}

void getData(bool useSample) {
  final lines = useSample
      ? File("data/sampleData").readAsLinesSync()
      : File("data/data").readAsLinesSync();

  grid = lines.map((e) => e.codeUnits.map((f) => f - 48).toList()).toList();

  maxY = grid.length;
  maxX = grid[0].length;
}

List<Position> findANine({required Position pos, required int currentValue}) {
  final found = pos.findPositionsWithValue(currentValue + 1);

  if (currentValue == 8) {
    return found.toList();
  }

  List<Position> count = [];
  for (var next in found) {
    count.addAll(findANine(pos: next, currentValue: currentValue + 1));
  }
  return count;
}

int part1({required bool useSample}) {
  getData(useSample);

  int total = 0;

  int y = 0;
  for (var row in grid) {
    int x = 0;
    for (var cell in row) {
      if (0 == cell) {
        final value =
            findANine(pos: Position(x: x, y: y), currentValue: 0).toSet();

        print('position x: $x, y: $y with value ${value.length}');

        total += value.length;
      }

      ++x;
    }

    ++y;
  }

  return total;
}

int part2({required bool useSample}) {
  getData(useSample);

  int total = 0;

  int y = 0;
  for (var row in grid) {
    int x = 0;
    for (var cell in row) {
      if (0 == cell) {
        final value = findANine(pos: Position(x: x, y: y), currentValue: 0);

        print('position x: $x, y: $y with value ${value.length}');

        total += value.length;
      }

      ++x;
    }

    ++y;
  }

  return total;
}
