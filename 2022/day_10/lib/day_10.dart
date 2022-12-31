import 'dart:io';

void calculate() {
  final lines = File("./lib/data").readAsLinesSync();

  int x = 1;
  int cycle = 0;
  int total = 0;

  final screen = <List<String>>[];
  for (int i = 0; i < 10; ++i) {
    screen.add(getPixelArray(40));
  }

  for (var line in lines) {
    if ("noop" != line) {
      final parts = line.split(" ");
      int increment = int.parse(parts[1]);

      ++cycle;
      selPixels(screen[((cycle - 1) / 40).floor()], x, cycle);
      if (isWantedCycle(cycle)) {
        total += cycle * x;
      }

      ++cycle;
      selPixels(screen[((cycle - 1) / 40).floor()], x, cycle);
      if (isWantedCycle(cycle)) {
        total += cycle * x;
      }

      x += increment;
    } else {
      ++cycle;
      selPixels(screen[((cycle - 1) / 40).floor()], x, cycle);
      if (isWantedCycle(cycle)) {
        total += cycle * x;
      }
    }
  }

  print("Total: $total");
  for (int i = 0; i < 9; ++i) {
    print(screen[i].reduce((value, element) => value + element));
  }
}

void selPixels(List<String> pixels, int position, int cycle) {
  // print("${(cycle - 1) % 40} $position");

  final mod = (cycle - 1) % 40;

  if (mod == (position - 1) || mod == position || mod == (position + 1)) {
    pixels[(cycle - 1) % 40] = "#";

    final temp = getPixelArray(40);
    temp[(cycle - 1) % 40] = "#";
    // print(
    //     "${temp.reduce((value, element) => value + element)} $cycle, ${((cycle - 1) / 40).floor()}, $mod, $position");
    // } else {
    //   print("$cycle, ${((cycle - 1) / 40).floor()}, $mod, $position");
  }
}

List<String> getPixelArray(int size) {
  final pixels = <String>[];
  for (int i = 0; i < size; ++i) {
    pixels.add(".");
  }

  return pixels;
}

bool isWantedCycle(int cycle) {
  if (cycle < 20) return false;

  if (cycle == 20) return true;

  if (((cycle - 20) % 40) == 0) return true;

  return false;
}
