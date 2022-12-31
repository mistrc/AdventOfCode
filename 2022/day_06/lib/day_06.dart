import 'dart:io';

void calculate() {
  final lines = File("./lib/data").readAsLinesSync();

  part1(lines);
  part2(lines);
}

void part1(List<String> lines) {
  final chars = [0, 0, 0, 0];

  for (var line in lines) {
    print(line);
    for (int i = 0; i < line.length; ++i) {
      if (i < 3) {
        chars[i] = line.codeUnitAt(i);
      } else {
        chars[i % 4] = line.codeUnitAt(i);

        if (chars[0] == chars[1]) continue;
        if (chars[0] == chars[2]) continue;
        if (chars[0] == chars[3]) continue;

        if (chars[1] == chars[2]) continue;
        if (chars[1] == chars[3]) continue;

        if (chars[2] == chars[3]) continue;

        print("Part1: ${i + 1}");
        break;
      }
    }
  }
}

void part2(List<String> lines) {
  final chars = [];
  for (int i = 0; i < 14; ++i) {
    chars.add(0);
  }

  for (var line in lines) {
    for (int i = 0; i < line.length; ++i) {
      if (i < chars.length) {
        chars[i] = line.codeUnitAt(i);
      } else {
        chars[i % chars.length] = line.codeUnitAt(i);

        if (allAreDifferent(chars, 0)) {
          print("Part2: ${i + 1}");
          break;
        }
      }
    }
  }
}

bool allAreDifferent(List chars, int startPoint) {
  for (int i = startPoint; i < chars.length; ++i) {
    if (i != startPoint && chars[startPoint] == chars[i]) {
      return false;
    }
  }

  if ((startPoint + 2) == chars.length) {
    return true;
  }

  return allAreDifferent(chars, startPoint + 1);
}
