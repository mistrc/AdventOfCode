import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'dart:math';

enum DeviceType {
  sensor,
  beacon,
  empty,
  unknown,
}

class Position {
  int x;
  int y;
  DeviceType type;

  Position(this.x, this.y, this.type) {
    // print("x:$x, y:$y, type:$type");
  }

  @override
  String toString() {
    return "Position(x:$x, y:$y, type:$type)";
  }

  @override
  bool operator ==(Object other) {
    if (other is! Position) return false;

    return other.x == x && other.y == y; // ignoring the type
  }

  @override
  int get hashCode => x.hashCode ^ y.hashCode;
}

class DevicePair {
  Position sensor;
  Position beacon;
  int separation;

  DevicePair(this.sensor, this.beacon)
      : separation = (sensor.x - beacon.x).abs() + (sensor.y - beacon.y).abs() {
    // print("Creating device pair for $sensor and $beacon");
  }

  int get minX => sensor.x - separation;
  int get maxX => sensor.x + separation;

  int get minY => sensor.y - separation;
  int get maxY => sensor.y + separation;

  Range? getRangeOnLine(int y, bool includeBeacon) {
    if ((y - sensor.y).abs() > separation) return null;

    final minVal = sensor.x - (separation - (y - sensor.y).abs());
    final maxVal = sensor.x + (separation - (y - sensor.y).abs());

    if (!includeBeacon) {
      if (minVal == maxVal && beacon.y == y) return null;

      if (beacon.y == y) {
        if (minVal == beacon.x) return Range(minVal + 1, maxVal);

        return Range(minVal, maxVal - 1);
      }
      return Range(minVal, maxVal);
    } else {
      return Range(
          (0 > minVal) ? 0 : minVal, (maxVal > 4000000) ? 4000000 : maxVal);
    }
  }
}

class Range {
  int minX;
  int maxX;
  Range(this.minX, this.maxX);

  bool doesOverlap(Range other) {
    return !(other.maxX < minX || maxX < other.minX);
  }

  Range operator +(Range other) {
    if (!doesOverlap(other)) {
      throw "Should never get here as $this and $other do not overlap";
    }

    return Range(min(minX, other.minX), max(maxX, other.maxX));
  }

  @override
  String toString() => "Range(minX:$minX, maxX:$maxX)";
}

class GridLimits {
  int minX;
  int minY;
  int maxX;
  int maxY;
  GridLimits(this.minX, this.minY, this.maxX, this.maxY);

  bool isWithinBounds(Position pos) {
    return minX <= pos.x && pos.x <= maxX && minY <= pos.y && pos.y <= maxY;
  }

  @override
  String toString() => "GridLimits(min[$minX, $minY] max[$maxX, $maxY])";
}

void calculate() {
  final lines = File("./lib/data").readAsLinesSync();

  final devices = <DevicePair>[];

  for (var line in lines) {
    final parts = line.split(" ");

    final sensor = createSensor(parts[2], parts[3]);

    final beacon = createBeacon(parts[8], parts[9]);

    devices.add(DevicePair(sensor, beacon));
  }

  final gridLimits = getGridLimits(devices);
  print(gridLimits);

  part1(devices);
  part2(devices);
}

void part1(List<DevicePair> devices) {
  final emptiesOnLine = getCountOfEmpties(devices, 2000000);

  print("Part1: number of empties on line $emptiesOnLine");
}

void part2(List<DevicePair> devices) {
  // final emptiesOnLine = getCountOfEmpties(devices, 2000000);
  finalBeacon(devices);

  // print("Part2: number of empties on line $emptiesOnLine");
}

int getCountOfEmpties(List<DevicePair> devices, int line) {
  SplayTreeSet<Range> ranges = SplayTreeSet<Range>(((a, b) {
    if (a.minX != b.minX) return a.minX - b.minX;
    return a.maxX - b.maxX;
  }));

  for (var device in devices) {
    final range = device.getRangeOnLine(line, false);
    if (null != range) {
      ranges.add(range);
    }
  }

  final iter = ranges.iterator;
  iter.moveNext();
  final listOfRanges = reduceRange(iter.current, iter);
  return listOfRanges
      .map((e) => e.maxX - e.minX + 1)
      .reduce((value, element) => value + element);
}

void finalBeacon(List<DevicePair> devices) {
  for (int y = 0; y <= 4000000; ++y) {
    SplayTreeSet<Range> ranges = SplayTreeSet<Range>(((a, b) {
      if (a.minX != b.minX) return a.minX - b.minX;
      return a.maxX - b.maxX;
    }));

    for (var device in devices) {
      final range = device.getRangeOnLine(y, true);
      if (null != range) {
        ranges.add(range);
      }
    }

    final iter = ranges.iterator;
    iter.moveNext();
    final listOfRanges = reduceRange(iter.current, iter);
    int occupiedCellCount = listOfRanges
        .map((e) => e.maxX - e.minX + 1)
        .reduce((value, element) => value + element);

    if (occupiedCellCount < 4000001) {
      print("$occupiedCellCount found for line $y for ${listOfRanges.length}");

      for (var range in listOfRanges) {
        print(range);
      }

      print((2889605 * 4000000) + y);

      /// TODO given the hack of a solution above
      /// 1. turn the create Sensor/Beacon functions into factories on Position class
      /// 2. change the type returned from reduceRange to being a sorted set
      /// 3. refactor reduceRange to accepting a function so that it can be used for
      /// 3.1. as is currently, i.e. replacing ranges from the overlap between ranges
      /// 3.2. new capability to return the gap/positions between neighboring ranges
    }
  }
}

List<Range> reduceRange(Range previousValue, Iterator<Range> iter) {
  if (!iter.moveNext()) {
    List<Range> newRanges = [previousValue];
    return newRanges;
  }

  final current = iter.current;

  if (previousValue.doesOverlap(current)) {
    return reduceRange(previousValue + current, iter);
  } else {
    final newRanges = reduceRange(current, iter);
    newRanges.add(previousValue);
    return newRanges;
  }
}

GridLimits getGridLimits(List<DevicePair> devices) {
  int minX = devices[0].sensor.x;
  int maxX = devices[0].sensor.x;
  int minY = devices[0].sensor.y;
  int maxY = devices[0].sensor.y;
  for (var device in devices) {
    if (minX > device.minX) minX = device.minX;
    if (maxX < device.maxX) maxX = device.maxX;

    if (minY > device.minY) minY = device.minY;
    if (maxY < device.maxY) maxY = device.maxY;
  }
  return GridLimits(minX, minY, maxX, maxY);
}

Position createSensor(String part2, String part3) {
  String X = part2.substring(2).split(",").first;
  String Y = part3.substring(2).split(":").first;

  return Position(int.parse(X), int.parse(Y), DeviceType.sensor);
}

Position createBeacon(String part8, String part9) {
  String X = part8.substring(2).split(",").first;
  String Y = part9.trim().substring(2);

  return Position(int.parse(X), int.parse(Y), DeviceType.beacon);
}
