import 'dart:io';

enum MaterialType { rock, sand, empty, source }

class Position {
  int x;
  int y;
  MaterialType material;
  bool isInBounds = true;
  Position(this.x, this.y, this.material);

  int _increment(int source, int destination) {
    if (source < destination) return 1;
    if (source > destination) return -1;
    return 0;
  }

  Position stepTowards(Position destination) {
    final newX = x + _increment(x, destination.x);
    final newY = y + _increment(y, destination.y);

    return Position(newX, newY, material);
  }

  @override
  String toString() => "Pos( x:$x, y:$y )";

  @override
  bool operator ==(Object other) {
    if (other is! Position) return false;

    return x == other.x && y == other.y;
  }

  @override
  int get hashCode => x.hashCode ^ y.hashCode;
}

class Grid {
  int maxX;
  int minX;
  int minY;
  int maxY;
  List<List<Position>> matrix;

  Grid(this.minX, this.maxX, this.minY, this.maxY, this.matrix);

  factory Grid.fromFormations(List<List<Position>> formations) {
    int minX = formations.first.first.x;
    int maxX = formations.first.first.x;
    int minY = 0; //formations.first.first.y;
    int maxY = formations.first.first.y;

    List<Position> rocksPositions = [];

    for (var formation in formations) {
      Position? lastPos;
      for (var pos in formation) {
        if (minX > pos.x) minX = pos.x;
        if (maxX < pos.x) maxX = pos.x;
        if (minY > pos.y) minY = pos.y;
        if (maxY < pos.y) maxY = pos.y;

        rocksPositions.add(pos);

        if (null != lastPos) {
          for (Position p = lastPos.stepTowards(pos);
              p != pos;
              p = p.stepTowards(pos)) {
            rocksPositions.add(p);
          }
        }

        lastPos = pos;
      }
    }

    List<List<Position>> matrix = [];
    for (int y = minY; y <= maxY; ++y) {
      List<Position> row = [];
      matrix.add(row);

      for (int x = minX; x <= maxX; ++x) {
        final pos = Position(x, y, MaterialType.empty);
        row.add(rocksPositions.contains(pos)
            ? rocksPositions.firstWhere((element) => element == pos)
            : pos);
      }
    }
    matrix[0][500 - minX].material = MaterialType.source;
    return Grid(minX, maxX, minY, maxY, matrix);
  }

  @override
  String toString() {
    List<String> str = [];
    for (var row in matrix) {
      for (var pos in row) {
        // switch (pos.material) {
        //   case MaterialType.empty:
        //     str.add(".,");
        //     break;
        //   case MaterialType.rock:
        //     str.add("#(${pos.x},${pos.y}),");
        //     break;
        //   case MaterialType.sand:
        //     str.add("o(${pos.x},${pos.y}),");
        //     break;
        //   case MaterialType.source:
        //     str.add("+");
        //     break;
        // }
        switch (pos.material) {
          case MaterialType.empty:
            str.add(".");
            break;
          case MaterialType.rock:
            str.add("#");
            break;
          case MaterialType.sand:
            str.add("o");
            break;
          case MaterialType.source:
            str.add("+");
            break;
        }
      }
      str.add("\n");
    }
    return str.reduce((value, element) => value + element);
  }

  bool _isWithinBounds(Position pos) =>
      minX <= pos.x && pos.x <= maxX && minY <= pos.y && pos.y <= maxY;

  bool _isEmpty(Position pos) =>
      matrix[pos.y - minY][pos.x - minX].material == MaterialType.empty ||
      matrix[pos.y - minY][pos.x - minX].material == MaterialType.source;

  bool putSandAt(int x, int y) {
    Position currentPos = Position(x, y, MaterialType.sand);

    if (!_isEmpty(currentPos)) {
      return false;
    }

    bool getNextPosition = true;

    final sandMotion = [
      (Position p) => Position(p.x, p.y + 1, p.material), // down
      (Position p) => Position(p.x - 1, p.y + 1, p.material), // down left
      (Position p) => Position(p.x + 1, p.y + 1, p.material), // down right
    ];

    while (getNextPosition) {
      // print("In loops with $currentPos");
      // matrix[currentPos.y - minY][currentPos.x - minX].material =
      //     MaterialType.sand;

      Position? result;

      for (var action in sandMotion) {
        final nextPos = _getNextPosition(action, currentPos);

        if (null != nextPos) {
          if (!nextPos.isInBounds) {
            getNextPosition = false;
          }
          result = nextPos;
          break;
        }
      }

      if (null == result) {
        break;
      } else {
        currentPos = result;
      }
    }

    if (currentPos.isInBounds) {
      // print("${currentPos.x - minX} and ${currentPos.y - minY}");
      // print("${currentPos.x} and ${currentPos.y}");
      matrix[currentPos.y - minY][currentPos.x - minX].material =
          MaterialType.sand;
    }

    // print("x:$minX-$maxX, y:$minY-$maxX with $currentPos");
    return currentPos.isInBounds;
  }

  Position? _getNextPosition(
      Position Function(Position p) action, Position currentPos) {
    Position nextPos = action(currentPos);
    if (!_isWithinBounds(nextPos)) {
      nextPos.isInBounds = false;
    } else if (!_isEmpty(nextPos)) {
      return null;
    }

    return nextPos;
  }
}

void calculate() {
  final lines = File("./lib/data").readAsLinesSync();

  part1(lines);
  part2(lines);
}

void part1(List<String> lines) {
  final formations = <List<Position>>[];

  for (var line in lines) {
    final vertices = line.split("->").map((e) => e.trim());

    final formation = <Position>[];
    formations.add(formation);

    for (var vertex in vertices) {
      final coordinates = vertex.split(",").map((e) => int.parse(e));
      formation.add(
          Position(coordinates.first, coordinates.last, MaterialType.rock));
    }
  }

  final grid = Grid.fromFormations(formations);
  print(grid);
  print("--------------");
  print("x:${grid.minX}-${grid.maxX}, y:${grid.minY}-${grid.maxY}");
  int count = 0;
  while (grid.putSandAt(500, 0)) {
    ++count;
  }

  print(grid);
  print("Part 1: total of $count runs");
}

void part2(List<String> lines) {
  final formations = <List<Position>>[];

  for (var line in lines) {
    final vertices = line.split("->").map((e) => e.trim());

    final formation = <Position>[];
    formations.add(formation);

    for (var vertex in vertices) {
      final coordinates = vertex.split(",").map((e) => int.parse(e));
      formation.add(
          Position(coordinates.first, coordinates.last, MaterialType.rock));
    }
  }

  final gridTemp = Grid.fromFormations(formations);

  final bottom = <Position>[];
  bottom.add(Position(
      500 - (gridTemp.maxY + 4), gridTemp.maxY + 2, MaterialType.rock));
  bottom.add(Position(
      500 + (gridTemp.maxY + 4), gridTemp.maxY + 2, MaterialType.rock));
  formations.add(bottom);

  final grid = Grid.fromFormations(formations);

  print(grid);
  print("--------------");
  print("x:${grid.minX}-${grid.maxX}, y:${grid.minY}-${grid.maxY}");
  int count = 0;
  while (grid.putSandAt(500, 0)) {
    ++count;
  }

  print(grid);
  print("Part 2: total of $count runs");
}
