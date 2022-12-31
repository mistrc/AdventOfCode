import 'dart:io';

Future<void> calculate() async {
  final lines = await File("./lib/data").readAsLines();

  part_1(lines);
  part_2(lines);
}

void part_1(List<String> lines) {
  int max = 0;
  int current = 0;
  for (var line in lines) {
    if (line.trim().isEmpty) {
      if (max < current) {
        max = current;
      }
      current = 0;
    } else {
      current += int.parse(line.trim());
    }
  }
  print("Part1: max caloroes = ${max}");
}

void part_2(List<String> lines) {
  List<int> big_uns = [0, 0, 0];
  int current = 0;

  for (var line in lines) {
    if (line.trim().isEmpty) {
      if (current > big_uns[0]) {
        if (big_uns[2] < current) {
          big_uns[0] = big_uns[1];
          big_uns[1] = big_uns[2];
          big_uns[2] = current;
        } else if (big_uns[1] < current) {
          big_uns[0] = big_uns[1];
          big_uns[1] = current;
        } else {
          big_uns[0] = current;
        }
      }

      current = 0;
    } else {
      current += int.parse(line.trim());
    }
  }
  print("Part2: top three come to = ${big_uns[0] + big_uns[1] + big_uns[2]}");
}
