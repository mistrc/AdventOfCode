import 'dart:io';

enum EType {
  rock,
  paper,
  scissors,
}

enum EComparison {
  beats,
  draws_with,
  loses_to,
}

extension _TypeExtensions on EType {
  /// Note values used in comparesTo function,
  /// so make sure they are in sync if you change this
  int get value {
    switch (this) {
      case EType.rock:
        return 1;
      case EType.paper:
        return 2;
      case EType.scissors:
        return 3;
    }
  }

  EComparison comparesTo(EType other) {
    if (value == other.value) return EComparison.draws_with;

    // Edge case not handled by values
    if (other == EType.scissors && this == EType.rock) return EComparison.beats;
    if (other == EType.rock && this == EType.scissors)
      return EComparison.loses_to;

    if (other.value < value) return EComparison.beats;

    return EComparison.loses_to;
  }

  EType relativeAction(EComparison comparison) {
    switch (comparison) {
      case EComparison.draws_with:
        return this;

      case EComparison.beats:
        switch (this) {
          case EType.paper:
            return EType.rock;
          case EType.rock:
            return EType.scissors;
          case EType.scissors:
            return EType.paper;
        }

      case EComparison.loses_to:
        switch (this) {
          case EType.paper:
            return EType.scissors;
          case EType.rock:
            return EType.paper;
          case EType.scissors:
            return EType.rock;
        }
    }
  }
}

extension _ComparisonValue on EComparison {
  int get value {
    switch (this) {
      case EComparison.beats:
        return 6;
      case EComparison.draws_with:
        return 3;
      case EComparison.loses_to:
        return 0;
    }
  }
}

extension _ToEnumeration on String {
  EType get toType {
    if ("A" == this || "X" == this) return EType.rock;

    if ("B" == this || "Y" == this) return EType.paper;

    return EType.scissors;
  }

  EComparison get toComparison {
    if ("X" == this) return EComparison.beats;

    if ("Y" == this) return EComparison.draws_with;

    return EComparison.loses_to;
  }
}

void calculate() {
  final lines = File("./lib/data").readAsLinesSync();

  // part1(lines);
  part2(lines);
}

void part1(List<String> lines) {
  var total = 0;
  for (var line in lines) {
    final parts = line.trim().split(' ');
    final left = parts[0].toType;
    final right = parts[1].toType;

    print(
        "Comparison of ${left} and ${right} results in ${right.comparesTo(left)}");

    print(
        "${right.value}, ${right.comparesTo(left).value}, ${right.value + right.comparesTo(left).value}");
    total += (right.value + right.comparesTo(left).value);
  }
  print("the value is ${total}");
}

void part2(List<String> lines) {
  var total = 0;
  for (var line in lines) {
    final parts = line.trim().split(' ');
    final left = parts[0].toType;
    final comparison = parts[1].toComparison;
    final right = left.relativeAction(comparison);

    print(
        "Comparison of ${left} and ${right} results in ${right.comparesTo(left)}");

    print(
        "${right.value}, ${right.comparesTo(left).value}, ${right.value + right.comparesTo(left).value}");
    total += (right.value + right.comparesTo(left).value);
  }
  print("the value is ${total}");
}
