import 'dart:ffi';
import 'dart:io';

enum Direction {
  left(-1),
  right(1);

  const Direction(this.multiplier);

  final int multiplier;

  static Direction get(String str) {
    final char = str.codeUnits[0];

    switch (char) {
      case 76:
        return left;

      case 82:
        return right;

      default:
        throw 'what';
    }
  }
}

int calculate() {
  return 6 * 7;
}

int part1(bool useSample) {
  final lines = useSample
      ? File("data/sampleData").readAsLinesSync()
      : File("data/data").readAsLinesSync();

  int currentPosition = 50;
  int counter = 0;

  for (var line in lines) {
    final direction = Direction.get(line);
    final distance = int.parse(line.substring(1));

    currentPosition =
        (currentPosition + (distance * direction.multiplier)) % 100;

    if (0 == currentPosition) ++counter;
  }

  return counter;
}

int part2(bool useSample) {
  final lines = useSample
      ? File("data/sampleData").readAsLinesSync()
      : File("data/data").readAsLinesSync();

  int currentPosition = 50;
  int counter = 0;

  for (var line in lines) {
    final direction = Direction.get(line);
    final distance = int.parse(line.substring(1));

    final newPosition = (direction == Direction.right)
        ? (currentPosition + distance)
        : (0 != currentPosition)
        ? (100 - currentPosition) + distance
        : distance;

    final pastZero = (newPosition / 100).floor();

    counter += pastZero;

    currentPosition =
        (currentPosition + (distance * direction.multiplier)) % 100;
  }

  return counter;
}


/// Below is working through the edge conditions for the above part 2 code

// start at 50

// 151 ==> 201/100 = 2
// 150 ==> 200/100 = 2
// 149 ==> 199/100 = 1

// -151 => -101/100 => -1.01 => 2
// -150 => -100/100 => -1.00 => 1 wrong
// -149 => - 99/100 => -0.99 => 1


// -151 => (100 - 50 ) + 151 = 201 => 201/100 => 2.01 => 2
// -150 => (100 - 50 ) + 150 = 200 => 200/100 => 2.00 => 2
// -149 => (100 - 50 ) + 149 = 199 => 199/100 => 1.99 => 1




// start at 0

// 151 ==> 151/100 = 1
// 150 ==> 150/100 = 1
// 149 ==> 149/100 = 1

// -151 => -151/100 => -1.51 => 2 wrong
// -150 => -150/100 => -1.50 => 2 wrong
// -149 => -149/100 => -1.49 => 2 wrong


// -151 => (100 - 0 ) + 151 = 251 => 251/100 => 2.51 => 2 wrong
// -150 => (100 - 0 ) + 150 = 250 => 250/100 => 2.50 => 2 wrong
// -149 => (100 - 0 ) + 149 = 249 => 249/100 => 2.49 => 2 wrong



// start at 0

// 201 ==> 201/100 = 2
// 200 ==> 200/100 = 2
// 199 ==> 199/100 = 1

// -201 => -201/100 => -2 => 3 wrong
// -200 => -200/100 => -2 => 2
// -199 => -199/100 => -2 => 2 wrong


// -201 => (100 - 0 ) + 201 = 301 => 301/100 => 3.01 => 3 wrong
// -200 => (100 - 0 ) + 200 = 300 => 300/100 => 3.00 => 3 wrong
// -199 => (100 - 0 ) + 199 = 299 => 299/100 => 2.99 => 2 wrong


