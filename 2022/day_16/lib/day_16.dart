import 'dart:collection';
import 'dart:io';

extension OnString on String {
  String subPart(int start, String endString) {
    final index = indexOf(endString);

    if (-1 == index) return substring(start);

    return substring(start, index);
  }
}

class Valve {
  String name;
  int pressureReleaseRate;

  Iterable<String> connectors;

  Valve(this.name, this.pressureReleaseRate, this.connectors);

  Valve.fromParts(
      String part1, String part4, Iterable<String> connectionStrings)
      : this(part1, int.parse(part4.subPart(5, ";")),
            connectionStrings.map((e) => e.subPart(0, ",")));

  @override
  String toString() => "Valve(name:$name, rate:$pressureReleaseRate)";
}

class PressureRelease {
  Valve valve;
  int time;
  PressureRelease(this.valve, this.time);

  int get total => valve.pressureReleaseRate * time;

  @override
  String toString() =>
      "PressureRelease(name:${valve.name}, time:$time, pressureReleased:$total)";
}

class PressureReleaseSet {
  List<PressureRelease> _data = [];

  PressureRelease get current => _data.last;

  List<String> get visitedValves => _data.map((e) => e.valve.name).toList();

  void add(PressureRelease p) => _data.add(p);

  PressureReleaseSet extendBy(PressureRelease result) {
    final toReturn = PressureReleaseSet();
    toReturn._data.addAll([..._data, result]);
    return toReturn;
  }

  int get total => _data.map((e) => e.total).reduce((a, b) => a + b);

  @override
  String toString() {
    final description = <String>[];
    for (var item in _data) {
      description.add(
          "{name:${item.valve.name}, time:${item.time}, total:${item.total}}");
    }

    return "PressureReleaseSet(total:$total from ${description.reduce((a, b) => "$a, $b")})";
  }
}

class Valves {
  List<Valve> valves = [];

  void add(Valve valve) {
    valves.add(valve);
  }

  Valve _getValve(String name) =>
      valves.singleWhere((element) => element.name == name);

  Iterable<PressureRelease> getNextValveStats(
      PressureRelease startValve, List<String> ignoredValves) {
    final nextValves = SplayTreeSet<Valve>((a, b) => a.name.compareTo(b.name));
    final valveStatsToReturn =
        SplayTreeSet<PressureRelease>((a, b) => b.total - a.total);

    nextValves.add(startValve.valve);
    int step = 0;

    while (nextValves.isNotEmpty && step < startValve.time) {
      final currentValves = [...nextValves];
      nextValves.clear();
      ++step;

      for (var valve in currentValves) {
        for (var nextValveName in valve.connectors) {
          final nextValve = _getValve(nextValveName);

          if (valveStatsToReturn.where((e) => e.valve == nextValve).isEmpty) {
            if (!ignoredValves.contains(nextValveName)) {
              valveStatsToReturn.add(
                  PressureRelease(nextValve, startValve.time - (step + 1)));
            }

            nextValves.add(nextValve);
          }
        }
      }

      currentValves.clear();
    }

    return valveStatsToReturn.where((e) => e.valve.pressureReleaseRate > 0);
  }
}

void calculate() {
  final lines = File("./lib/data").readAsLinesSync();

  final valves = Valves();

  for (var line in lines) {
    final parts = line.split(" ");
    valves.add(Valve.fromParts(parts[1], parts[4], parts.skip(9)));
  }

  bool stopSearching = false;
  int loopCount = 0;
  int maxPressureReleased = 0;

  List<PressureReleaseSet> listResults = [];
  PressureRelease bob = PressureRelease(valves._getValve("AA"), 30);
  PressureReleaseSet bobSet = PressureReleaseSet();
  bobSet.add(bob);
  listResults.add(bobSet);

  do {
    SplayTreeSet<PressureReleaseSet> nextListResults =
        SplayTreeSet<PressureReleaseSet>((a, b) => a.total - b.total);

    for (var element in listResults) {
      final resultsInOrder =
          valves.getNextValveStats(element.current, element.visitedValves);

      for (var result in resultsInOrder) {
        nextListResults.add(element.extendBy(result));
      }
    }

    listResults.clear();
    if (nextListResults.isEmpty) {
      stopSearching = true;
    } else {
      listResults.addAll(nextListResults);

      for (var item in listResults) {
        // print("Option returned $item");
        if (maxPressureReleased < item.total) {
          maxPressureReleased = item.total;
        }
      }

      print("Best option so far is ${listResults.last}");
      print("Number of options for this loop is ${listResults.length}");
    }

    print(
        "loop ${loopCount + 1} completed ----------------- stopSearching:$stopSearching");

    ++loopCount;
  } while (!stopSearching && loopCount < 11);

  print("Max pressure released is $maxPressureReleased");
}
