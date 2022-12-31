import 'dart:io';
import 'dart:math';

int SnafuToInt(String s) {
  switch (s) {
    case "=":
      return -2;

    case "-":
      return -1;

    default:
      return int.parse(s);
  }
}

// String IntToSnafu(int i){
// }

void calculate() {
  final lines = File("./lib/data").readAsLinesSync();

  List<int> allElements = decimalTotalPerOrdinal(lines);

  print(allElements);
  print("-------------");

  int total = calculateTotal(allElements);
  print(total);

  final maxPower = (log(total) / log(5)).floor();

  print("maxPower: $maxPower");
  print("-------------");

  List<int> coeffs = getCoefficients(total, maxPower);

  print(coeffs);

  List<String> snafuTotal = getSnafuArray(coeffs);

  print(snafuTotal.reversed);

  printOutAsString(snafuTotal.reversed);
}

List<int> decimalTotalPerOrdinal(List<String> lines) {
  final allElements = <int>[];

  for (var line in lines) {
    // iterate over line in reverse order, so can lengthen allElements as needed
    for (int i = line.length - 1; i >= 0; --i) {
      if (allElements.length < (line.length - i)) {
        allElements.add(0);
      }

      // when on last char of line --> first element in allElements
      // when on first char of line --> last element in allElements
      allElements[line.length - i - 1] += SnafuToInt(line[i]);
    }
  }
  return allElements;
}

void printOutAsString(Iterable<String> snafuTotal) {
  // print(snafuTotal.reversed.reduce((a, b) => "$a$b"));

  for (var char in snafuTotal) {
    stdout.write(char);
  }

  stdout.write("\n");
}

List<String> getSnafuArray(List<int> coeffs) {
  final snafuTotal = <String>[];
  bool carryTheOne = false;

  for (var element in coeffs.reversed) {
    final value = (carryTheOne) ? element + 1 : element;
    switch (value) {
      case 5:
        {
          carryTheOne = true;
          snafuTotal.add("0");
        }
        break;

      case 4:
        {
          carryTheOne = true;
          snafuTotal.add("-");
        }
        break;

      case 3:
        {
          carryTheOne = true;
          snafuTotal.add("=");
        }
        break;

      default:
        {
          snafuTotal.add(value.toString());
          carryTheOne = false;
        }
    }
  }

  if (carryTheOne) {
    snafuTotal.add("1");
  }
  return snafuTotal;
}

List<int> getCoefficients(int total, int maxPower) {
  final coeffs = <int>[];
  int remainder = total;
  for (int i = maxPower; i >= 0; --i) {
    coeffs.add((remainder / pow(5, i)).floor());
    remainder = remainder % pow(5, i).floor();
  }
  return coeffs;
}

int calculateTotal(List<int> allElements) {
  int total = 0;
  for (int ordinal = 0; ordinal < allElements.length; ++ordinal) {
    total += allElements[ordinal] * pow(5, ordinal).round();
  }
  return total;
}
