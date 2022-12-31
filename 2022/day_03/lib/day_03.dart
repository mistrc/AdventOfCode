import 'dart:io';

extension OnString on String {
  Set<String> get set {
    final ret = <String>{};

    for (int i = 0; i < length; ++i) {
      ret.add(this[i]);
    }

    return ret;
  }

  int get priority {
    final val = codeUnitAt(0);

    // print("priority comes to ${val}");

    // lowercase letter
    if (0x61 <= val && val <= 0x7A) {
      return val - 0x61 + 1;
    }

    // uppercase letter
    if (0x41 <= val && val <= 0x5A) {
      return val - 0x41 + 27;
    }

    // someone messed up
    return 0;
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
    final numChars = (line.length / 2).floor();

    final left = line.substring(0, numChars).set;
    final right = line.substring(numChars).set;

    for (var lchar in left) {
      if (right.contains(lchar)) {
        final priority = lchar.priority;
        // print("Priority for ${lchar} is ${priority}");

        total += priority;
      }
    }
  }

  print("Total = ${total}");
}

void part2(List<String> lines) {
  int total = 0;
  final grouping = [<String>{}, <String>{}, <String>{}];
  int modulo = 0;

  for (var line in lines) {
    grouping[modulo] = line.set;

    if (modulo == 2) {
      for (var char in grouping[0]) {
        if (grouping[1].contains(char) && grouping[2].contains(char)) {
          total += char.priority;
        }
      }
    }

    modulo = (modulo + 1) % 3;
  }

  print("Total = ${total}");
}
