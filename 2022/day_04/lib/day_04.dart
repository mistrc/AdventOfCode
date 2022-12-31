import 'dart:io';

extension _OnString on String {
  List<int> get range {
    return this.split("-").map((e) => int.parse(e)).toList();
  }
}

void calculate() {
  final lines = File("./lib/data").readAsLinesSync();
  part1(lines);
  part2(lines);
}

void part1(List<String> lines) {
  int total = 0;

  for (var line in lines) {
    final parts = line.split(",");

    final left = parts[0].range;
    final right = parts[1].range;

    if (left[0] <= right[0] && right[1] <= left[1]) {
      ++total;
    } else if (right[0] <= left[0] && left[1] <= right[1]) {
      ++total;
    }
  }

  print("Part1: number of groups fond ${total}");
}

void part2(List<String> lines) {
  int total = 0;

  for (var line in lines) {
    final parts = line.split(",");

    final left = parts[0].range;
    final right = parts[1].range;

    if (!(left[0] > right[1] || right[0] > left[1])) {
      ++total;
    }
  }

  print("Part2: number of groups fond ${total}");
}
