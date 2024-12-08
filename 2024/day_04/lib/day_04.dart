import 'dart:io';

const X = 88; //'X'.codeUnitAt(0);
const M = 77; //'M'.codeUnitAt(0);
const A = 65; //'A'.codeUnitAt(0);
const S = 83; //'S'.codeUnitAt(0);

String numberToLetter(int i) {
  switch (i) {
    case X:
      return 'X';
    case M:
      return 'M';
    case A:
      return 'A';
    case S:
      return 'S';
  }

  return 'XXXXXXX';
}

int maxX = 0;
int maxY = 0;

class Position {
  final int x;
  final int y;

  Position({required this.x, required this.y});

  bool get isValid => 0 <= x && x < maxX && 0 <= y && y < maxY;
}

List<List<int>> getGrid(bool useSample) {
  final lines = useSample
      ? File("data/sampleData").readAsLinesSync()
      : File("data/data").readAsLinesSync();

  maxY = lines.length;
  maxX = lines[0].length;

  return lines.map((e) => e.codeUnits).toList();
}

List<Position Function({required int x, required int y})>
    getNeighbouringLocationFunctions() {
  List<Position Function({required int x, required int y})> locations = [
    ({required int x, required int y}) => Position(x: x - 1, y: y - 1),
    ({required int x, required int y}) => Position(x: x, y: y - 1),
    ({required int x, required int y}) => Position(x: x + 1, y: y - 1),
    ({required int x, required int y}) => Position(x: x - 1, y: y),
    ({required int x, required int y}) => Position(x: x + 1, y: y),
    ({required int x, required int y}) => Position(x: x - 1, y: y + 1),
    ({required int x, required int y}) => Position(x: x, y: y + 1),
    ({required int x, required int y}) => Position(x: x + 1, y: y + 1),
  ];

  return locations;
}

List<
    (
      Position Function({required int x, required int y}),
      Position Function({required int x, required int y})
    )> getNeighbouringXLocationFunctions() {
  List<
      (
        Position Function({required int x, required int y}),
        Position Function({required int x, required int y})
      )> locations = [
    (
      ({required int x, required int y}) => Position(x: x - 1, y: y - 1),
      ({required int x, required int y}) => Position(x: x + 1, y: y + 1)
    ),
    (
      ({required int x, required int y}) => Position(x: x + 1, y: y - 1),
      ({required int x, required int y}) => Position(x: x - 1, y: y + 1)
    ),
  ];

  return locations;
}

int getNextLetter(int current) {
  switch (current) {
    case X:
      return M;

    case M:
      return A;
    case A:
      return S;

    default:
      return -1;
  }
}

void getXmasCount(List<List<int>> grid, {required int x, required int y}) {
  final functions = getNeighbouringLocationFunctions();

  for (var func in functions) {
    final posM = func(x: x, y: y);
    if (posM.isValid && grid[posM.y][posM.x] == M) {
      // print(
      //     'letter ${numberToLetter(letter)} found at x: ${pos.x}, y: ${pos.y}');
      final posA = func(x: posM.x, y: posM.y);
      if (posA.isValid && grid[posA.y][posA.x] == A) {
        final posS = func(x: posA.x, y: posA.y);
        if (posS.isValid && grid[posS.y][posS.x] == S) {
          ++counter;
          // print('counter $counter');
        }
      }
    }
  }
}

int counter = 0;
int part1({required bool useSample}) {
  final grid = getGrid(useSample);

  counter = 0;

  int y = 0;
  for (var row in grid) {
    int x = 0;
    for (var cell in row) {
      if (cell == X) {
        getXmasCount(grid, x: x, y: y);
      }
      ++x;
    }

    ++y;
  }

  return counter;
}

void getMasCount(List<List<int>> grid, {required int x, required int y}) {
  final functions = getNeighbouringXLocationFunctions();

  int foundCount = 0;

  for (var funcs in functions) {
    final pos1 = funcs.$1(x: x, y: y);
    final pos2 = funcs.$2(x: x, y: y);

    if (pos1.isValid && pos2.isValid) {
      if (grid[pos1.y][pos1.x] == M && grid[pos2.y][pos2.x] == S) {
        foundCount++;
      } else if (grid[pos1.y][pos1.x] == S && grid[pos2.y][pos2.x] == M) {
        foundCount++;
      }
    }
  }

  if (2 == foundCount) counter++;
}

int part2({required bool useSample}) {
  final grid = getGrid(useSample);

  counter = 0;

  int y = 0;
  for (var row in grid) {
    int x = 0;
    for (var cell in row) {
      if (cell == A) {
        getMasCount(grid, x: x, y: y);
      }
      ++x;
    }

    ++y;
  }

  return counter;
}
