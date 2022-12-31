import 'dart:io';

class Tree {
  final int row;
  final int col;
  final int height; // as UTC 16 code
  bool visibleFromTop = false;
  bool visibleFromBottom = false;
  bool visibleFromLeft = false;
  bool visibleFromRight = false;
  bool isEdgeTree = false;

  bool get isVisible =>
      visibleFromBottom ||
      visibleFromLeft ||
      visibleFromRight ||
      visibleFromTop ||
      isEdgeTree;

  Tree(this.row, this.col, this.height);

  int scenicScore(List<List<Tree>> grid) {
    int left = col;
    int right = grid[0].length - col - 1;
    int up = row;
    int down = grid.length - row - 1;
    for (int i = row - 1; i > -1; --i) {
      final other = grid[i][col];
      if (other.height >= height) {
        up = row - other.row;
        break;
      }
    }
    for (int i = col - 1; i > -1; --i) {
      final other = grid[row][i];
      if (other.height >= height) {
        left = col - other.col;
        break;
      }
    }
    for (int i = row + 1; i < grid.length; ++i) {
      final other = grid[i][col];
      if (other.height >= height) {
        down = other.row - row;
        break;
      }
    }
    for (int i = col + 1; i < grid[0].length; ++i) {
      final other = grid[row][i];
      if (other.height >= height) {
        right = other.col - col;
        break;
      }
    }

    print(
        "scenic score for $row, $col is ${left * right * up * down} made of left:$left right:$right top:$up down:$down");
    return left * right * up * down;
  }

  @override
  String toString() {
    return "Tree row:$row col:$col visibility: $visibleFromTop, $visibleFromLeft, $visibleFromRight, $visibleFromBottom, $isEdgeTree";
  }
}

enum TraversalDirection { left, right, down, up }

void calculate() {
  final lines = File("./lib/data").readAsLinesSync();

  int row = 0;
  final grid = <List<Tree>>[];

  for (var line in lines) {
    grid.add(<Tree>[]);
    for (int i = 0; i < line.length; ++i) {
      // UTC 16 code maintains the same relative difference between the numbers
      grid[row].add(Tree(row, i, line.codeUnitAt(i)));
    }
    ++row;
  }

  part1(grid);
  part2(grid);
}

void part1(List<List<Tree>> grid) {
  setVisibility(grid, TraversalDirection.down);
  setVisibility(grid, TraversalDirection.up);
  setVisibility(grid, TraversalDirection.left);
  setVisibility(grid, TraversalDirection.right);

  int numberOfVisibleTrees = 0;
  for (var row in grid) {
    for (var tree in row) {
      if (tree.isVisible) {
        ++numberOfVisibleTrees;
      }
    }
  }

  print("number of visible trees: $numberOfVisibleTrees");
}

void part2(List<List<Tree>> grid) {
  int maxScenicScore = 0;

  for (int row = 1; row < grid.length - 1; ++row) {
    for (int col = 1; col < grid[0].length - 1; ++col) {
      final tree = grid[row][col];
      final treeScenicScore = tree.scenicScore(grid);
      if (maxScenicScore < treeScenicScore) {
        maxScenicScore = treeScenicScore;
      }
    }
  }

  print("max scenic score is $maxScenicScore");
}

void setVisibility(List<List<Tree>> grid, TraversalDirection direction) {
  final numberOfRows = grid.length;
  final numberOfCols = grid[0].length;

  switch (direction) {
    case TraversalDirection.down:
      final treesAtTop = grid[0];
      traverseTreesSettingVisibility(
          treeLine: treesAtTop,
          endRowValue: numberOfRows - 1,
          grid: grid,
          nextRow: increment,
          nextCol: keep);
      break;

    case TraversalDirection.left:
      final treesOnRight = grid.map((e) => e[numberOfCols - 1]);
      traverseTreesSettingVisibility(
          treeLine: treesOnRight,
          endColValue: 1,
          grid: grid,
          nextRow: keep,
          nextCol: decrement);
      break;

    case TraversalDirection.right:
      final treesOnLeft = grid.map((e) => e[0]);
      traverseTreesSettingVisibility(
          treeLine: treesOnLeft,
          endColValue: numberOfCols - 1,
          grid: grid,
          nextRow: keep,
          nextCol: increment);
      break;

    case TraversalDirection.up:
      final treesAtBottom = grid[numberOfRows - 1];
      traverseTreesSettingVisibility(
          treeLine: treesAtBottom,
          endRowValue: 1,
          grid: grid,
          nextRow: decrement,
          nextCol: keep);
      break;
  }
}

int increment(int i) => i + 1;
int decrement(int i) => i - 1;
int keep(int i) => i;

void traverseTreesSettingVisibility(
    {required Iterable<Tree> treeLine,
    int? endRowValue,
    int? endColValue,
    required List<List<Tree>> grid,
    required int Function(int) nextRow,
    required int Function(int) nextCol}) {
  for (var tree in treeLine) {
    tree.isEdgeTree = true;

    int row = tree.row;
    int col = tree.col;

    Tree currentTree = grid[row][col];

    do {
      final nextTree = grid[nextRow(row)][nextCol(col)];

      if (currentTree.height < nextTree.height) {
        nextTree.visibleFromTop = true;
        currentTree = nextTree;
      }

      col = nextCol(col);
      row = nextRow(row);
    } while (continueLoop(row, endRowValue) || continueLoop(col, endColValue));
  }
}

bool continueLoop(int counter, int? limitingValue) {
  return (null == limitingValue) ? false : counter != limitingValue;
}
