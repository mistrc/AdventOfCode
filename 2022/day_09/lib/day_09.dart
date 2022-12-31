import 'dart:io';

class Position {
  final int x;
  final int y;

  Position(this.x, this.y);

  @override
  bool operator ==(Object other) {
    if (other is Position) {
      return x == other.x && y == other.y;
    }

    return false;
  }

  @override
  int get hashCode => x.hashCode ^ y.hashCode;
}

class End {
  final history = <Position>{};
  Position currentPosition;

  End(this.currentPosition) {
    history.add(currentPosition);
  }

  void move(Position Function(Position p1) move) {
    currentPosition = move(currentPosition);
    history.add(currentPosition);
  }

  void catchUp(Position other) {
    if ((currentPosition.x - other.x) > 1) {
      if ((currentPosition.y - other.y) > 1) {
        currentPosition =
            Position(currentPosition.x - 1, currentPosition.y - 1);
      } else if ((other.y - currentPosition.y) > 1) {
        currentPosition =
            Position(currentPosition.x - 1, currentPosition.y + 1);
      } else {
        currentPosition = Position(currentPosition.x - 1, other.y);
      }
      history.add(currentPosition);
    } else if ((other.x - currentPosition.x) > 1) {
      if ((currentPosition.y - other.y) > 1) {
        currentPosition =
            Position(currentPosition.x + 1, currentPosition.y - 1);
      } else if ((other.y - currentPosition.y) > 1) {
        currentPosition =
            Position(currentPosition.x + 1, currentPosition.y + 1);
      } else {
        currentPosition = Position(currentPosition.x + 1, other.y);
      }
      history.add(currentPosition);
    } else if ((currentPosition.y - other.y) > 1) {
      currentPosition = Position(other.x, currentPosition.y - 1);
      history.add(currentPosition);
    } else if ((other.y - currentPosition.y) > 1) {
      currentPosition = Position(other.x, currentPosition.y + 1);
      history.add(currentPosition);
    }
  }
}

void calculate() {
  final lines = File("./lib/data").readAsLinesSync();

  part1(lines);
  part2(lines);
}

void part1(List<String> lines) {
  final H = End(Position(0, 0));
  final T = End(Position(0, 0));

  for (var line in lines) {
    final parts = line.split(" ");
    Position Function(Position) move = getMoveFunction(parts[0]);

    int count = int.parse(parts[1]);

    for (int i = 0; i < count; ++i) {
      H.move(move);
      T.catchUp(H.currentPosition);
    }
  }

  print("number of positions occupied by Tail ${T.history.length}");
}

void part2(List<String> lines) {
  final H = End(Position(0, 0));
  final T1 = End(Position(0, 0));
  final T2 = End(Position(0, 0));
  final T3 = End(Position(0, 0));
  final T4 = End(Position(0, 0));
  final T5 = End(Position(0, 0));
  final T6 = End(Position(0, 0));
  final T7 = End(Position(0, 0));
  final T8 = End(Position(0, 0));
  final T9 = End(Position(0, 0));

  for (var line in lines) {
    final parts = line.split(" ");
    Position Function(Position) move = getMoveFunction(parts[0]);

    int count = int.parse(parts[1]);

    for (int i = 0; i < count; ++i) {
      H.move(move);
      T1.catchUp(H.currentPosition);
      T2.catchUp(T1.currentPosition);
      T3.catchUp(T2.currentPosition);
      T4.catchUp(T3.currentPosition);
      T5.catchUp(T4.currentPosition);
      T6.catchUp(T5.currentPosition);
      T7.catchUp(T6.currentPosition);
      T8.catchUp(T7.currentPosition);
      T9.catchUp(T8.currentPosition);
    }
  }

  print("number of positions occupied by Tail9 ${T9.history.length}");
}

Position Function(Position) getMoveFunction(String operator) {
  switch (operator) {
    case "L":
      return (Position p) => Position(p.x - 1, p.y);

    case "R":
      return (Position p) => Position(p.x + 1, p.y);

    case "U":
      return (Position p) => Position(p.x, p.y - 1);

    case "D":
    default: // should never get here
      return (Position p) => Position(p.x, p.y + 1);
  }
}
