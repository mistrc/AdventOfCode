import 'dart:io';

List<List<int>> grid = [];
int maxX = 0;
int maxY = 0;

class Position {
  final int x;
  final int y;

  Position({required this.x, required this.y});

  bool get isValid => (0 <= x && x < maxX && 0 <= y && y < maxY);

  @override
  int get hashCode => Object.hash(x, y);

  @override
  bool operator ==(Object other) {
    if (other is Position) {
      return x == other.x && y == other.y;
    }
    return false;
  }
}

Map<int, List<Position>> antenas = {};

const dot = 46; // '.'.codeUnits[0]

void getData(bool useSample) {
  antenas.clear();

  final lines = useSample
      ? File("data/sampleData").readAsLinesSync()
      : File("data/data").readAsLinesSync();

  grid = lines.map((e) => e.codeUnits).toList();

  maxY = grid.length;
  maxX = grid[0].length;

  int y = 0;
  for (var row in grid) {
    int x = 0;
    for (var cell in row) {
      if (dot != cell) {
        antenas.update(cell, (value) {
          value.add(Position(x: x, y: y));
          return value;
        }, ifAbsent: () => [Position(x: x, y: y)]);
      }
      ++x;
    }
    ++y;
  }
}

bool forPart1 = true;
List<Position> calcAntiNodes(Position a, Position b) {
  final xDiff = a.x - b.x;
  final yDiff = a.y - b.y;

  if (forPart1) {
    final one = Position(x: a.x + xDiff, y: a.y + yDiff);
    final two = Position(x: b.x - xDiff, y: b.y - yDiff);

    return [if (one.isValid) one, if (two.isValid) two];
  } else {
    final toReturn = <Position>[];

    Position last = a;

    do {
      toReturn.add(last);
      last = Position(x: last.x + xDiff, y: last.y + yDiff);
    } while (last.isValid);

    last = b;

    do {
      toReturn.add(last);
      last = Position(x: last.x - xDiff, y: last.y - yDiff);
    } while (last.isValid);

    return toReturn;
  }
}

int part1({required bool useSample}) {
  forPart1 = true;
  getData(useSample);

  final antiNodes = <Position>{};

  for (var antenaType in antenas.values) {
    final nodes = [...antenaType];

    while (nodes.length > 1) {
      final aNode = nodes.removeLast(); // more efficient than removeAt(0)

      for (var antena in nodes) {
        final returnedNodes = calcAntiNodes(aNode, antena);

        antiNodes.addAll(returnedNodes);
      }
    }
  }

  return antiNodes.length;
}

int part2({required bool useSample}) {
  forPart1 = false;
  getData(useSample);

  final antiNodes = <Position>{};

  for (var antenaType in antenas.values) {
    final nodes = [...antenaType];

    while (nodes.length > 1) {
      final aNode = nodes.removeLast(); // more efficient than removeAt(0)

      for (var antena in nodes) {
        final returnedNodes = calcAntiNodes(aNode, antena);

        antiNodes.addAll(returnedNodes);
      }
    }
  }

  return antiNodes.length;
}
