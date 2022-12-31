import 'dart:io';

class Dir {
  int _size = 0;
  final subDir = <Dir>[];
  final String name;
  final Dir? parent;
  Dir(this.name, this.parent);

  Dir getDir(String dirName) {
    final iter = subDir.where((element) => element.name == dirName);
    if (iter.isEmpty) {
      final item = Dir(dirName, this);
      subDir.add(item);
      return item;
    } else {
      return iter.first;
    }
  }

  void incrementSize(int increment) {
    _size += increment;

    if (null != parent) {
      parent!.incrementSize(increment);
    }
  }

  @override
  String toString() {
    return "$name:$_size $subDir";
  }

  int gotTotalUnder(int limit) {
    int runningTotal = (_size <= limit) ? _size : 0;

    for (var child in subDir) {
      runningTotal += child.gotTotalUnder(limit);
    }

    return runningTotal;
  }

  int getSmallestOver(int limit) {
    int valueOverThreshold = (_size >= limit) ? _size : 0;

    for (var child in subDir) {
      final childVal = child.getSmallestOver(limit);
      if (0 < childVal && childVal < valueOverThreshold) {
        valueOverThreshold = childVal;
      }
    }

    return valueOverThreshold;
  }
}

void calculate() {
  final lines = File("./lib/data").readAsLinesSync();

  final root = Dir("root", null);
  Dir current = root;

  for (var line in lines) {
    final parts = line.split(" ");
    if ("\$" == parts[0]) {
      if ("cd" == parts[1]) {
        if ("/" == parts[2]) {
          current = root;
        } else if (".." == parts[2]) {
          current = current.parent!;
        } else {
          current = current.getDir(parts[2]);
        }
      }
    } else {
      if ("dir" != parts[0]) {
        current.incrementSize(int.parse(parts[0]));
      }
    }
  }

  print(root);

  part1(root);
  part2(root);
}

void part1(Dir root) {
  print("Part1: ${root.gotTotalUnder(100000)}");
}

void part2(Dir root) {
  print("Part2: ${root.getSmallestOver(30000000 - (70000000 - root._size))}");
}
