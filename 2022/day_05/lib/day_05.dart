import 'dart:io';

void calculate() {
  final lines = File("./lib/data").readAsLinesSync();

  final cargoLines = <String>[];
  int numberOfStacks = 0;
  final instructionLines = <String>[];

  for (var line in lines) {
    if (line.contains("[")) {
      cargoLines.add(line);
    } else if (line.contains("move")) {
      instructionLines.add(line);
    } else if (!line.trim().isEmpty) {
      numberOfStacks = int.parse(line.trim().split(" ").last);
    }
  }

  part1(numberOfStacks, cargoLines, instructionLines);
  part2(numberOfStacks, cargoLines, instructionLines);
}

void part1(int numberOfStacks, List<String> cargoLines,
    List<String> instructionLines) {
  // Create the stacks
  List<List<String>> cargo = [];
  for (int i = 0; i < numberOfStacks; ++i) {
    cargo.add(<String>[]);
  }

  // put lines into stacks
  putLinesIntoCargo(cargoLines.reversed, cargo);

  processInstructionsOnBlockAtATime(instructionLines, cargo);

  // print out the result
  String result = "";
  for (int i = 0; i < numberOfStacks; ++i) {
    result += cargo[i].last;
  }
  print("Part1: ${result}");
}

void part2(int numberOfStacks, List<String> cargoLines,
    List<String> instructionLines) {
  // Create the stacks
  List<List<String>> cargo = [];
  for (int i = 0; i < numberOfStacks; ++i) {
    cargo.add(<String>[]);
  }

  // put lines into stacks
  putLinesIntoCargo(cargoLines.reversed, cargo);

  processInstructionsMultipleBlocksAtATime(instructionLines, cargo);

  // print out the result
  String result = "";
  for (int i = 0; i < numberOfStacks; ++i) {
    result += cargo[i].last;
  }
  print("Part2: ${result}");
}

void processInstructionsOnBlockAtATime(
    List<String> instructionLines, List<List<String>> cargo) {
  for (var instruction in instructionLines) {
    final parts = instruction.split(" ");
    final numberToMove = int.parse(parts[1]);
    final sourceStack = int.parse(parts[3]) - 1;
    final destinationStack = int.parse(parts[5]) - 1;

    for (int i = 0; i < numberToMove; ++i) {
      cargo[destinationStack].add(cargo[sourceStack].removeLast());
    }
  }
}

void processInstructionsMultipleBlocksAtATime(
    List<String> instructionLines, List<List<String>> cargo) {
  for (var instruction in instructionLines) {
    final parts = instruction.split(" ");
    final numberToMove = int.parse(parts[1]);
    final sourceStack = int.parse(parts[3]) - 1;
    final destinationStack = int.parse(parts[5]) - 1;

    cargo[destinationStack].addAll(cargo[sourceStack].getRange(
        cargo[sourceStack].length - numberToMove, cargo[sourceStack].length));
    cargo[sourceStack].removeRange(
        cargo[sourceStack].length - numberToMove, cargo[sourceStack].length);
  }
}

void putLinesIntoCargo(
    Iterable<String> reversedCargoLines, List<List<String>> cargo) {
  final numberOfStacks = cargo.length;

  for (var line in reversedCargoLines) {
    for (int i = 0; i < numberOfStacks; ++i) {
      final crate = line.substring(1 + 4 * i, 2 + 4 * i);
      if (crate.trim().isNotEmpty) {
        cargo[i].add(crate);
      }
    }
  }
}
