import 'dart:io';

class Item {
  BigInt worryLevel;
  Item(this.worryLevel);

  @override
  String toString() => worryLevel.toString();
}

class Monkey {
  List<Item> items;
  void Function(Item i) operation;
  void Function(Item i) testAndThrow;

  Monkey(this.items, this.operation, this.testAndThrow);

  int inspections = 0;
  List<int> inspectionHistory = [];
  void inspect(bool allowDistress) {
    int previousVal = inspections;
    for (var item in items) {
      operation(item);

      if (allowDistress) {
        item.worryLevel = (item.worryLevel ~/ BigInt.from(3));
      }

      testAndThrow(item);
      ++inspections;
    }
    inspectionHistory.add(inspections - previousVal);

    items.clear();
  }

  void catchItem(Item i) {
    items.add(i);
  }
}

void calculate() {
  final lines = File("./lib/data").readAsLinesSync();

  final monkeys = <Monkey>[];

  final monkeyTitles =
      lines.where((line) => line.contains(RegExp("^Monkey [0-9]+:")));

  for (var monkeyTitle in monkeyTitles) {
    final startLine = lines.indexOf(monkeyTitle);
    final itemLevels = lines[startLine + 1].substring(18).split(", ");
    final operations = lines[startLine + 2].substring(19).split(" ");
    final tests = lines[startLine + 3].substring(8).split(" ");
    final trueMonkey = int.parse(lines[startLine + 4].split((" ")).last);
    final falseMonkey = int.parse(lines[startLine + 5].split((" ")).last);

    monkeys.add(generateMonkey(
        monkeys, itemLevels, operations, tests, trueMonkey, falseMonkey));
  }

  // runModel(monkeys, true, 20); // part 1
  runModel(monkeys, false, 500); // part 2
}

void runModel(List<Monkey> monkeys, bool allowDistress, int numberOfRounds) {
  for (int round = 0; round < numberOfRounds; ++round) {
    for (var monkey in monkeys) {
      monkey.inspect(allowDistress);
    }
  }

  print("");

  print("After $numberOfRounds rounds");

  for (int i = 0; i < 500; ++i) {
    print(
        "${monkeys[0].inspectionHistory[i] + monkeys[1].inspectionHistory[i]}, ${monkeys[2].inspectionHistory[i]}, ${monkeys[3].inspectionHistory[i]}, ");
  }

  final mostInspections = <int>[0, 0];
  for (int i = 0; monkeys.length > i; ++i) {
    if (mostInspections[0] < monkeys[i].inspections) {
      if (mostInspections[1] < monkeys[i].inspections) {
        mostInspections[0] = mostInspections[1];
        mostInspections[1] = monkeys[i].inspections;
      } else {
        mostInspections[0] = monkeys[i].inspections;
      }
    }
    // print("Monkey $i inspected items ${monkeys[i].inspectionHistory} times.");
  }

  print("");
  // print("Level of monkey business ${mostInspections[0] * mostInspections[1]}");
}

Monkey generateMonkey(
    List<Monkey> monkeys,
    List<String> worryLevels,
    List<String> operations,
    List<String> tests,
    int trueMonkey,
    int falseMonkey) {
  final items = <Item>[];
  for (var worryLevel in worryLevels) {
    if (worryLevel.isNotEmpty) items.add(Item(BigInt.parse(worryLevel)));
  }

  void Function(Item i) operation = createOperation(operations);

  void Function(Item i) test =
      createTest(monkeys, tests, trueMonkey, falseMonkey);

  return Monkey(items, operation, test);
}

void Function(Item i) createTest(
    List<Monkey> monkeys, List<String> parts, int trueMonkey, int falseMonkey) {
  if (parts[0] == "divisible" && parts[1] == "by") {
    int denominator = int.parse(parts[2]);

    return ((i) =>
        i.worryLevel.remainder(BigInt.from(denominator)) == BigInt.from(0)
            ? monkeys[trueMonkey].catchItem(i)
            : monkeys[falseMonkey].catchItem(i));
  }

  return ((i) {});
}

void Function(Item i) createOperation(List<String> parts) {
  final operator = parts[1];

  // final lhs = parts[0] == "old" ? i.worryLevel : int.parse(parts[0]);

  switch (operator) {
    case "*":
      return ((i) =>
          i.worryLevel = getValue(i, parts[0]) * getValue(i, parts[2]));

    case "/":
      return ((i) =>
          i.worryLevel = getValue(i, parts[0]) ~/ getValue(i, parts[2]));

    case "+":
      return ((i) =>
          i.worryLevel = getValue(i, parts[0]) + getValue(i, parts[2]));

    case "-":
      return ((i) =>
          i.worryLevel = getValue(i, parts[0]) - getValue(i, parts[2]));
  }

  return ((i) => {});
}

BigInt getValue(Item i, String part) {
  return part == "old" ? i.worryLevel : BigInt.parse(part);
}
