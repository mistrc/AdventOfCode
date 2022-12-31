import 'dart:collection';
import 'dart:io';

enum LineType {
  lhs,
  rhs,
}

// void calculate() {
//   final lhs = createList("[1,1,3,1,1]", 1);
//   final rhs = createList("[[1],[2,3,4]]", 1);

//   print(isRightWayRound(lhs, rhs));
// }

void calculate() {
  final lines = File("./lib/data").readAsLinesSync();

  part1(lines);
  part2(lines);
}

void part1(List<String> lines) {
  List<dynamic> lhs = [];
  List<dynamic> rhs = [];
  LineType lineType = LineType.lhs;
  int total = 0;
  int count = 1;

  for (var line in lines) {
    if (line.trim().isNotEmpty) {
      if (lineType == LineType.lhs) {
        lhs = createList(line, 1).first;
        lineType = LineType.rhs;
      } else if (lineType == LineType.rhs) {
        rhs = createList(line, 1).first;
        lineType = LineType.lhs;

        // print("-----------------");
        // print(line);
        // print(rhs);

        final result = isRightWayRound(lhs, rhs);
        if (EIsRightWayRound.yes == result) {
          total += count;
          // } else {
          //   print("lhs: $lhs and rhs: $rhs resulted in $result");
        }
        ++count;
      }
    }
  }

  print("Part 1: Total is $total");
}

extension ToCpmpareValue on EIsRightWayRound {
  int compareResult() {
    switch (this) {
      case EIsRightWayRound.no:
        return 1;
      case EIsRightWayRound.undetermined:
        return 0;
      case EIsRightWayRound.yes:
        return -1;
    }
  }
}

void part2(List<String> lines) {
  final divider1AsStr = "[[2]]";
  final divider2AsStr = "[[6]]";
  final clonedLines = [...lines, divider1AsStr, divider2AsStr];

  final set = SplayTreeSet<List<dynamic>>(
      ((lhs, rhs) => isRightWayRound(lhs, rhs).compareResult()));

  for (var line in clonedLines) {
    if (line.trim().isNotEmpty) {
      final arr = createList(line, 1).first;
      set.add(arr);
    }
  }

  final divider1 = createList(divider1AsStr, 1).last;
  final divider2 = createList(divider2AsStr, 1).last;

  int index = 1;
  int total = 1;

  for (var item in set) {
    if (EIsRightWayRound.undetermined == isRightWayRound(item, divider1) ||
        EIsRightWayRound.undetermined == isRightWayRound(item, divider2)) {
      total *= index;
    }

    ++index;
  }
  print("Part 2: Total is $total");
}

enum EIsRightWayRound { yes, no, undetermined }

EIsRightWayRound isRightWayRound(List lhs, List rhs) {
  // print("isRightWayRound called with lhs: $lhs and rhs: $rhs");

  for (int i = 0; i < lhs.length && i < rhs.length; ++i) {
    final lElement = lhs[i];
    final rElement = rhs[i];

    if (lElement is int && rElement is int) {
      if (lElement < rElement) return EIsRightWayRound.yes;
      if (lElement > rElement) return EIsRightWayRound.no;
    } else if (null == lElement && null == rElement) {
      return EIsRightWayRound.undetermined;
    } else if (null == lElement) {
      return EIsRightWayRound.yes;
    } else if (null == rElement) {
      return EIsRightWayRound.no;
    } else if (lElement is! int && rElement is! int) {
      final wayRound = isRightWayRound(lElement, rElement);
      if (wayRound != EIsRightWayRound.undetermined) return wayRound;
    } else if (lElement is int) {
      final wayRound = isRightWayRound([lElement], rElement);
      if (wayRound != EIsRightWayRound.undetermined) return wayRound;
    } else if (rElement is int) {
      final wayRound = isRightWayRound(lElement, [rElement]);
      if (wayRound != EIsRightWayRound.undetermined) return wayRound;
    } else {
      throw "Should never get here: index is $i for lhs=$lhs, rhs=$rhs";
    }
  }

  if (lhs.length == rhs.length) return EIsRightWayRound.undetermined;

  return (lhs.length < rhs.length) ? EIsRightWayRound.yes : EIsRightWayRound.no;
}

List<dynamic> createList(String text, int counter) {
  if (text.contains("[")) {
    final end = text.indexOf("]");
    final start = text.substring(0, end).lastIndexOf("[");
    final str = text.substring(start + 1, end);

    // print("str: $str");
    // print(str.split(","));
    final parts = str.split(",").map((e) {
      final val = int.tryParse(e);
      if (val != null) return val;
      if (e.isEmpty) return null;
      return e;
    }).toList();
    final key = "magicString$counter";

    final inner = text.replaceRange(start, end + 1, key);

    final arr = createList(inner, counter + 1);
    // print("Got back $arr should replace $key with $parts");

    replaceInArray(arr, key, parts);

    // print("returning $arr");
    return arr;
  }

  // print("text $text");
  return text.split(",").map(((e) {
    final val = int.tryParse(e);
    if (val != null) return val;
    return e;
  })).toList();
}

void replaceInArray(List<dynamic> arr, String key, List<Object?> parts) {
  for (int i = 0; i < arr.length; ++i) {
    if (arr[i] is List) {
      replaceInArray(arr[i], key, parts);
    } else if (arr[i] == key) {
      // print("going to replace ${arr[i]} with $parts");
      arr[i] = parts;
    }
  }
}
