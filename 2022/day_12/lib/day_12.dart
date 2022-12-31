import 'dart:io';

class Position {
  int row;
  int col;
  int height;
  int? distance;
  String letter; // delete this
  Position(this.row, this.col, this.height, this.letter);

  @override
  bool operator ==(Object other) {
    if (other is Position) return other.col == col && other.row == row;
    return false;
  }

  @override
  int get hashCode => row.hashCode ^ col.hashCode;

  @override
  String toString() {
    return "Position($row,$col)";
  }
}

final sCode = "S".codeUnitAt(0);
final eCode = "E".codeUnitAt(0);
final beforeACode = "a".codeUnitAt(0);
final afterZCode = "z".codeUnitAt(0);

extension GetCodeForPosition on String {
  int getCode(int index) {
    int val = codeUnitAt(index);

    if (sCode == val) return beforeACode;
    if (eCode == val) return afterZCode;

    return val;
  }
}

class Grid {
  final data = <List<Position>>[];
  late int lastRow;
  late int lastCol;

  Grid(List<String> lines) {
    int row = -1;
    for (var line in lines) {
      ++row;
      data.add([]);
      for (int i = 0; i < line.length; ++i) {
        data[data.length - 1]
            .add(Position(row, i, line.getCode(i), line.substring(i, i + 1)));
      }
    }

    lastRow = data.length;
    lastCol = data[0].length;
  }

  @override
  String toString() {
    String str = "-----------------------------------------";
    for (var row in data) {
      str += "\n${row.map((e) {
        if (null == e.distance) return "..";

        if (e.distance! > 10) return "${e.distance}(${e.letter})";
        return " ${e.distance}(${e.letter})";
        // if (e.distance! > 10) return "${e.distance}";
        // return " ${e.distance}";
      }).reduce((value, element) => "$value, $element")}";
    }
    str += "\n-----------------------------------------";
    return str;
  }

  Position getFirstPosOf(String s) {
    for (var row in data) {
      for (var pos in row) {
        if (pos.letter == s) return pos;
      }
    }

    throw "Should never get here but was looking for a value for $s";
  }

  List<Position> getAllPosOfHeight(String s) {
    final height = s.getCode(0);
    final allMatches = <Position>[];

    for (var row in data) {
      allMatches.addAll(row.where((element) => element.height == height));
    }

    return allMatches;
  }

  List<Position> validDirections(Position p) {
    final acceptableHeight = data[p.row][p.col].height + 1;

    final directions = <Position>[];

    _addPosIfValid(
        p.row, p.col + 1, acceptableHeight, p.distance! + 1, directions);
    _addPosIfValid(
        p.row, p.col - 1, acceptableHeight, p.distance! + 1, directions);
    _addPosIfValid(
        p.row + 1, p.col, acceptableHeight, p.distance! + 1, directions);
    _addPosIfValid(
        p.row - 1, p.col, acceptableHeight, p.distance! + 1, directions);

    return directions;
  }

  Position? _getPosition(int row, int col) {
    if (row < 0 || col < 0 || lastCol <= col || lastRow <= row) return null;

    return data[row][col];
  }

  void _addPosIfValid(int row, int col, int acceptableHeight, int nextDistance,
      List<Position> directions) {
    final pos = _getPosition(row, col);
    // print("pos $pos for row: $row and col: $col");
    if (null != pos && pos.distance == null && acceptableHeight >= pos.height) {
      pos.distance = nextDistance;
      directions.add(pos);
    }
  }
}

void calculate() {
  final lines = File("./lib/data").readAsLinesSync();

  part1(lines);
  part2(lines);
}

void part1(List<String> lines) {
  final grid = Grid(lines);

  final startPos = grid.getFirstPosOf("S");
  final endPos = grid.getFirstPosOf("E");

  startPos.distance = 0;

  calcNextDistances(grid, [startPos], endPos);

  print("Part1: ${endPos.distance}");
}

void part2(List<String> lines) {
  final grid = Grid(lines);

  final startPos = grid.getAllPosOfHeight("S");
  final endPos = grid.getFirstPosOf("E");

  for (var pos in startPos) {
    pos.distance = 0;
  }

  calcNextDistances(grid, startPos, endPos);

  print("Part2: ${endPos.distance}");
}

void calcNextDistances(Grid grid, List<Position> positions, Position endPos) {
  List<Position> nextPositions = [];

  for (var pos in positions) {
    nextPositions.addAll(grid.validDirections(pos));
  }

  // print(nextPositions.length);
  // print(grid);

  if (endPos.distance != null) return;

  if (nextPositions.isNotEmpty) calcNextDistances(grid, nextPositions, endPos);
}
