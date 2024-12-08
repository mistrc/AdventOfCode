import 'dart:io';

List<List<int>> grid = [];
int maxX = 0;
int maxY = 0;

class Position {
  final int x;
  final int y;

  Position({required this.x, required this.y});

  bool isValid(int allowedAntennaType) {
    if (0 <= x && x < maxX && 0 <= y && y < maxY) {
      final bob = dot == grid[y][x] || allowedAntennaType == grid[y][x];
      return bob;
    }

    return false;
  }

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

  for (var entry in antenas.entries) {
    final str = String.fromCharCode(entry.key);
    print('key: $str occours ${entry.value.length} times');
  }
}

List<Position> calcNodes(Position a, Position b) {
  final xDiff = a.x - b.x;
  final yDiff = a.y - b.y;

  final one = Position(x: a.x + xDiff, y: a.y + yDiff);
  final two = Position(x: b.x - xDiff, y: b.y - yDiff);

  return [
    if (one.isValid(grid[a.y][a.x])) one,
    if (two.isValid(grid[a.y][a.x])) two
  ];
}

int part1({required bool useSample}) {
  getData(useSample);

  int total = 0;

  for (var antenaType in antenas.values) {
    final nodes = [...antenaType];

    while (nodes.length > 1) {
      final aNode = nodes.removeLast(); // more efficient than removeAt(0)

      for (var antena in nodes) {
        final nodes = calcNodes(aNode, antena);
        total += nodes.length;
      }
    }
  }

  return total;
}

int part2({required bool useSample}) {
  getData(useSample);

  final antiNodes = <Position>{};
  int total = 0;

  for (var antenaType in antenas.values) {
    final nodes = [...antenaType];

    while (nodes.length > 1) {
      final aNode = nodes.removeLast(); // more efficient than removeAt(0)

      for (var antena in nodes) {
        final nodes = calcNodes(aNode, antena);
        total += nodes.length;
        antiNodes.addAll(nodes);
      }
    }
  }

  return total; //antiNodes.length;
}
