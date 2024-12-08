import 'dart:io';

int increment(int v) => v + 1;
int staySame(int v) => v;
int decrement(int v) => v - 1;

enum Direction {
  up(94, staySame, decrement), //'^'.codeUnitAt(0);
  right(62, increment, staySame), //'>'.codeUnitAt(0);
  down(118, staySame, increment), //'v'.codeUnitAt(0);
  left(60, decrement, staySame); //'<'.codeUnitAt(0);

  final int char;

  const Direction(this.char, this.moveX, this.moveY);

  final int Function(int x) moveX;
  final int Function(int y) moveY;
}

const int hash = 35; //'#'.codeUnitAt(0);

Direction changeDirection(Direction d) {
  switch (d) {
    case Direction.down:
      return Direction.left;
    case Direction.left:
      return Direction.up;
    case Direction.up:
      return Direction.right;
    case Direction.right:
      return Direction.down;
  }
}

class Moment {
  final int x;
  final int y;
  final Direction direction;

  static bool useSimpleCompare = true;

  Moment({required this.x, required this.y, required this.direction});

  Moment rotate() => Moment(x: x, y: y, direction: changeDirection(direction));

  Moment move() {
    final nextPos = Moment(
        x: direction.moveX(x), y: direction.moveY(y), direction: direction);

    if (hasHash(nextPos)) {
      return rotate()
          .move(); // wil do recursive calls and go back the way it came if needed
    }

    return nextPos;
  }

  bool get isValid => 0 <= x && x < maxX && 0 <= y && y < maxY;

  @override
  int get hashCode =>
      (useSimpleCompare) ? Object.hash(x, y) : Object.hash(x, y, direction);

  @override
  bool operator ==(Object other) {
    if (other is Moment) {
      if (useSimpleCompare) {
        return x == other.x && y == other.y;
      } else {
        return x == other.x && y == other.y && direction == other.direction;
      }
    }
    return false;
  }

  @override
  String toString() {
    return 'x=$x, y=$y, direction=$direction';
  }
}

List<List<int>> grid = [];
Moment currentPosition = Moment(x: -1, y: -1, direction: Direction.down);
int maxX = 0;
int maxY = 0;

// very hacky, but I no longer care, but note is only ised for part2
({int x, int y}) extraHash = (x: -10, y: -10);
bool hasHash(Moment m) {
  if (extraHash.x == m.x && extraHash.y == m.y) {
    return true;
  }

  return m.isValid ? grid[m.y][m.x] == hash : false;
}

void initialiseData(bool useSample) {
  final lines = useSample
      ? File("data/sampleData").readAsLinesSync()
      : File("data/data").readAsLinesSync();

  grid = lines.map((e) => e.codeUnits).toList();

  maxY = grid.length;
  maxX = grid[0].length;

  final dicrections = Direction.values.map((e) => e.char).toList();
  int y = 0;
  for (var row in grid) {
    int x = 0;
    for (var cell in row) {
      final index = dicrections.indexOf(cell);
      if (-1 != index) {
        currentPosition =
            Moment(x: x, y: y, direction: Direction.values[index]);
        return;
      }
      ++x;
    }
    ++y;
  }
}

int part1({required bool useSample}) {
  Moment.useSimpleCompare = true;
  initialiseData(useSample);

  final visitedLocations = <Moment>{};

  do {
    // print(currentPosition);
    visitedLocations.add(currentPosition);

    currentPosition = currentPosition.move();
  } while (currentPosition.isValid);

  return visitedLocations.length;
}

int part2({required bool useSample}) {
  Moment.useSimpleCompare = false;

  initialiseData(useSample);

  int obsticleLocationCount = 0;

  Moment startPos = currentPosition;

  int y = 0;
  for (var row in grid) {
    int x = 0;
    for (var cell in row) {
      if (cell != hash && (startPos.x != x || startPos.y != y)) {
        extraHash = (x: x, y: y);

        currentPosition = startPos;

        final visitedLocations = <Moment>{};

        bool addedNewLocation = true;

        do {
          // print(currentPosition);
          addedNewLocation = visitedLocations.add(currentPosition);

          currentPosition = currentPosition.move();
        } while (currentPosition.isValid && addedNewLocation);

        if (!addedNewLocation) ++obsticleLocationCount;

        extraHash = (x: -10, y: -10);
      }

      ++x;
    }

    ++y;
  }

  return obsticleLocationCount;
}
