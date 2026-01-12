import 'dart:math';

class Cell {
  final Point<int> p;
  final int val;

  Cell._(this.p, this.val);
}

class Grid implements Iterable<Cell> {
  final List<List<Cell>> _data;

  final int _limitX;
  final int _limitY;

  int get limitX => _limitX;
  int get limitY => _limitY;

  Grid._(this._limitX, this._limitY, this._data);

  factory Grid(List<String> lines) {
    final dataValues = lines.map((e) => e.codeUnits).toList();

    final maxY = dataValues.length;
    final maxXIter = dataValues.map((e) => e.length);

    final maxX = maxXIter.first;

    assert(maxXIter.every((t) => t == maxX));

    final List<List<Cell>> data = [];

    for (var rowValues in dataValues.indexed) {
      List<Cell> row = [];
      data.add(row);
      for (var cellValue in rowValues.$2.indexed) {
        final cell = Cell._(Point(cellValue.$1, rowValues.$1), cellValue.$2);

        row.add(cell);
      }
    }

    return Grid._(maxX, maxY, data);
  }

  Cell? _fromCoordinate(int x, int y) {
    if (0 > x) return null;
    if (0 > y) return null;

    if (x >= _limitX) return null;
    if (y >= _limitY) return null;

    return _data[y][x];
  }

  Cell? _fromPoint(Point<int> p) {
    return _fromCoordinate(p.x, p.y);
  }

  List<Cell> adjacentCells(Point<int> p) {
    final found = <Cell>[];

    for (var x = p.x - 1; x <= (p.x + 1); x++) {
      for (var y = p.y - 1; y <= (p.y + 1); y++) {
        final cell = _fromCoordinate(x, y);

        if (null != cell && p != cell.p) found.add(cell);
      }
    }

    return found;
  }

  @override
  bool any(bool Function(Cell element) test) {
    for (var cell in this) {
      if (test(cell)) return true;
    }
    return false;
  }

  @override
  Iterable<R> cast<R>() {
    // TODO: implement cast
    throw UnimplementedError();
  }

  @override
  bool contains(Object? element) {
    if (null == element) return false;
    if (element is! Cell) return false;

    final atlocation = _fromPoint(element.p);

    return atlocation == element;
  }

  @override
  Cell elementAt(int index) {
    if (index < 0 || (_limitX * _limitY) <= index)
      throw 'Index is out of bounds';

    final x = index % _limitX;
    final y = (index / _limitX).floor();

    return _fromCoordinate(x, y)!;
  }

  @override
  bool every(bool Function(Cell element) test) {
    for (var cell in this) {
      if (!test(cell)) return false;
    }
    return true;
  }

  @override
  Iterable<T> expand<T>(Iterable<T> Function(Cell element) toElements) sync* {
    for (var value in this) {
      yield* toElements(value);
    }
  }

  @override
  Cell get first => _data.first.first;

  @override
  Cell firstWhere(bool Function(Cell element) test, {Cell Function()? orElse}) {
    for (var cell in this) {
      if (test(cell)) return cell;
    }

    if (null != orElse) return orElse();

    throw 'No item found';
  }

  @override
  T fold<T>(T initialValue, T Function(T previousValue, Cell element) combine) {
    var value = initialValue;
    for (var cell in this) {
      value = combine(value, cell);
    }
    return value;
  }

  @override
  Iterable<Cell> followedBy(Iterable<Cell> other) sync* {
    // TODO: implement followedBy
    throw UnimplementedError();
  }

  @override
  void forEach(void Function(Cell element) action) {
    for (var cell in this) {
      action(cell);
    }
  }

  @override
  bool get isEmpty => _data.first.isEmpty;

  @override
  bool get isNotEmpty => _data.first.isNotEmpty;

  @override
  Iterator<Cell> get iterator => _GridIter(this);

  @override
  String join([String separator = ""]) {
    // TODO: implement join
    throw UnimplementedError();
  }

  @override
  // TODO: implement last
  Cell get last => throw UnimplementedError();

  @override
  Cell lastWhere(bool Function(Cell element) test, {Cell Function()? orElse}) {
    // TODO: implement lastWhere
    throw UnimplementedError();
  }

  @override
  // TODO: implement length
  int get length => throw UnimplementedError();

  @override
  Iterable<T> map<T>(T Function(Cell e) toElement) {
    // TODO: implement map
    throw UnimplementedError();
  }

  @override
  Cell reduce(Cell Function(Cell value, Cell element) combine) {
    // TODO: implement reduce
    throw UnimplementedError();
  }

  @override
  // TODO: implement single
  Cell get single => throw UnimplementedError();

  @override
  Cell singleWhere(
    bool Function(Cell element) test, {
    Cell Function()? orElse,
  }) {
    // TODO: implement singleWhere
    throw UnimplementedError();
  }

  @override
  Iterable<Cell> skip(int count) {
    // TODO: implement skip
    throw UnimplementedError();
  }

  @override
  Iterable<Cell> skipWhile(bool Function(Cell value) test) {
    // TODO: implement skipWhile
    throw UnimplementedError();
  }

  @override
  Iterable<Cell> take(int count) {
    // TODO: implement take
    throw UnimplementedError();
  }

  @override
  Iterable<Cell> takeWhile(bool Function(Cell value) test) {
    // TODO: implement takeWhile
    throw UnimplementedError();
  }

  @override
  List<Cell> toList({bool growable = true}) {
    // TODO: implement toList
    throw UnimplementedError();
  }

  @override
  Set<Cell> toSet() {
    // TODO: implement toSet
    throw UnimplementedError();
  }

  @override
  Iterable<Cell> where(bool Function(Cell element) test) {
    // TODO: implement where
    throw UnimplementedError();
  }

  @override
  Iterable<T> whereType<T>() {
    // TODO: implement whereType
    throw UnimplementedError();
  }

  void setCell(Point<int> p, int val) {
    final cell = _fromPoint(p);

    if (null != cell) {
      final newCell = Cell._(p, val);
      _data[p.y][p.x] = newCell;
    }
  }
}

class _GridIter implements Iterator<Cell> {
  final Grid grid;

  Iterator<List<Cell>>? outer;
  Iterator<Cell>? inner;

  _GridIter(this.grid);

  @override
  Cell get current {
    if (null == inner) throw 'iter not initalised';

    return inner!.current;
  }

  @override
  bool moveNext() {
    if (null == outer) {
      // expect to come here the first time round
      outer = grid._data.iterator;
      if (!outer!.moveNext()) return false;
    }

    if (null == inner) {
      // again expect to come here the first time only
      inner = outer!.current.iterator;
      return inner!.moveNext();
    }

    if (inner!.moveNext()) return true;

    if (!outer!.moveNext()) return false;

    inner = outer!.current.iterator;

    return inner!.moveNext();
  }
}
