import 'dart:io';

List<String> getData(bool useSample) {
  populateCodeToNumber();

  return useSample
      ? File("data/sampleData").readAsLinesSync()
      : File("data/data").readAsLinesSync();
}

List<int> getAceptedCodes() {
  return 'mul(0123456789,)'.codeUnits;
}

List<int> startSequence = 'mul('.codeUnits;
int delimiter = ','.codeUnits[0];
int end = ')'.codeUnits[0];

final codeToNumber = <int, int>{};
void populateCodeToNumber() {
  for (var i = 0; i < 10; i++) {
    codeToNumber.putIfAbsent('$i'.codeUnitAt(0), () => i);
  }
}

(int, int) getNextNumber(List<int> list, int pos) {
  int i = 0;
  while (i < startSequence.length &&
      pos < list.length &&
      list[pos] == startSequence[i]) {
    ++i;
    ++pos;
  }

  if (i < startSequence.length) return (i, 0);

  int num1 = 0;
  while (pos < list.length && codeToNumber.containsKey(list[pos])) {
    num1 = (num1 * 10) + codeToNumber[list[pos]]!;

    ++i;
    ++pos;
  }

  if (pos >= list.length || delimiter != list[pos]) return (i, 0);

  ++i;
  ++pos;

  int num2 = 0;
  while (pos < list.length && codeToNumber.containsKey(list[pos])) {
    num2 = (num2 * 10) + codeToNumber[list[pos]]!;

    ++i;
    ++pos;
  }

  if (pos >= list.length || end != list[pos]) return (i, 0);

  ++i;
  ++pos;

  print('we have $num1 * $num2 = ${num1 * num2}');

  return (i, num1 * num2);
}

int part1({required bool useSample}) {
  final lines = getData(useSample);

  int total = 0;

  for (var line in lines) {
    final list = line.codeUnits;

    int i = 0;
    while (i < list.length) {
      if (startSequence[0] == list[i]) {
        final (offset, product) = getNextNumber(list, i);

        total += product;
        i += offset;
      } else {
        ++i;
      }
    }
  }

  return total;
}

List<int> doSection = 'do()'.codeUnits;
List<int> dontSection = 'don\'t()'.codeUnits;

bool sequenceMatch(List<int> toMatchWith, List<int> list, int pos) {
  for (var i = 0; i < toMatchWith.length && pos < list.length; i++, pos++) {
    if (toMatchWith[i] != list[pos]) return false;
  }

  return pos < list.length;
}

int part2({required bool useSample}) {
  final lines = getData(useSample);

  int total = 0;

  bool inDoSection = true;

  for (var line in lines) {
    final list = line.codeUnits;

    int i = 0;
    while (i < list.length) {
      if (sequenceMatch(doSection, list, i)) {
        inDoSection = true;
        i += doSection.length;
      } else if (sequenceMatch(dontSection, list, i)) {
        inDoSection = false;
        i += dontSection.length;
      }

      if (inDoSection && startSequence[0] == list[i]) {
        final (offset, product) = getNextNumber(list, i);

        total += product;
        i += offset;
      } else {
        ++i;
      }
    }
  }

  return total;
}
