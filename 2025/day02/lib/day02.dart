import 'dart:io';
import 'dart:math';

int calculate() {
  return 6 * 7;
}

bool _showPrintOutput = false;
void _showDebugText(String str) {
  if (_showPrintOutput) print(str);
}

bool _hasEvenNumberOfDigits(String start) => start.length.isEven;

int numberOfDigits(int num) {
  int pow = 1;
  int checker = 10;

  while (checker <= num) {
    checker *= 10;
    ++pow;
  }

  return pow;
}

class _MyInvalidNum {
  int _val;
  int _myVal = 0;

  _MyInvalidNum._(this._val) {
    _showDebugText('----------Constructing using $_val');

    setMyVal();
  }

  /// Creates a MyNum instance from a string that contains a number\
  /// Will determine if the next viable number that is invalid
  factory _MyInvalidNum.next(String val) {
    if (!_hasEvenNumberOfDigits(val)) {
      /// 7 -> 11 --> 1 => 10 ((current digit count) + 1)/2
      /// 979 -> 1010 --> 10 => 1000 ==> 10 ((current digit count) + 1)/2
      return _MyInvalidNum._(pow(10, ((val.length + 1) / 2) - 1).toInt());
    }

    final half = val.length ~/ 2;

    final firstHalf = int.parse(val.substring(0, half));
    final endHalf = int.parse(val.substring(half));

    if (firstHalf < endHalf) return _MyInvalidNum._(firstHalf + 1);

    return _MyInvalidNum._(firstHalf);
  }

  void setMyVal() {
    final calcedNumberOfDigits = numberOfDigits(_val);

    _myVal = _val * pow(10, calcedNumberOfDigits).toInt() + _val;

    _showDebugText(
      'using _val=$_val, gave numberOfDigits=$numberOfDigits and _myVal=$_myVal',
    );
  }

  int get myVal => _myVal;

  bool operator <=(int other) => _myVal <= other;

  void next() {
    ++_val;
    setMyVal();
  }
}

int part1(bool useSample) {
  _showPrintOutput = useSample;

  final lines = useSample
      ? File("data/sampleData").readAsLinesSync()
      : File("data/data").readAsLinesSync();

  final ranges = lines.first.split((','));

  int counter = 0;

  for (var range in ranges) {
    final rangeLimits = range.split(('-'));
    final start = rangeLimits.first;
    final end = int.parse(rangeLimits.last);

    final invalidNum = _MyInvalidNum.next(start);

    while (invalidNum <= end) {
      counter += invalidNum.myVal;

      if (useSample) {
        _showDebugText(
          'For range: [$range] have start=$start, end=$end and value ${invalidNum.myVal}',
        );
      }

      invalidNum.next();
    }
  }

  return counter;
}

class _MyInvalidNum2 {
  int _val;
  int _myVal = 0;

  _MyInvalidNum2._(this._val) {
    _showDebugText('----------Constructing using $_val');

    setMyVal();
  }

  /// Creates a MyNum instance from a string that contains a number\
  /// Will determine if the next viable number that is invalid
  factory _MyInvalidNum2.next(String val, int groupSize) {
    final asInt = int.parse(val);

    if (0 == val.length % groupSize) {
      final startPoint = int.parse(val.substring(0, groupSize));

      int currentValue = startPoint;

      while (currentValue < asInt) {
        currentValue = currentValue * pow(10, groupSize).toInt() + startPoint;
      }
    }

    if (!_hasEvenNumberOfDigits(val)) {
      /// 7 -> 11 --> 1 => 10 ((current digit count) + 1)/2
      /// 979 -> 1010 --> 10 => 1000 ==> 10 ((current digit count) + 1)/2
      return _MyInvalidNum2._(pow(10, ((val.length + 1) / 2) - 1).toInt());
    }

    final half = val.length ~/ 2;

    final firstHalf = int.parse(val.substring(0, half));
    final endHalf = int.parse(val.substring(half));

    if (firstHalf < endHalf) return _MyInvalidNum2._(firstHalf + 1);

    return _MyInvalidNum2._(firstHalf);
  }

  void setMyVal() {
    final calcedNumberOfDigits = numberOfDigits(_val);

    _myVal = _val * pow(10, calcedNumberOfDigits).toInt() + _val;

    _showDebugText(
      'using _val=$_val, gave numberOfDigits=$numberOfDigits and _myVal=$_myVal',
    );
  }

  int get myVal => _myVal;

  bool operator <=(int other) => _myVal <= other;

  void next() {
    ++_val;
    setMyVal();
  }
}

int part2(bool useSample) {
  _showPrintOutput = useSample;

  final lines = useSample
      ? File("data/sampleData").readAsLinesSync()
      : File("data/data").readAsLinesSync();

  final ranges = lines.first.split((','));

  int counter = 0;

  for (var range in ranges) {
    final rangeLimits = range.split(('-'));
    final start = rangeLimits.first;
    final end = int.parse(rangeLimits.last);

    final invalidNum = _MyInvalidNum.next(start);

    while (invalidNum <= end) {
      counter += invalidNum.myVal;

      if (useSample) {
        _showDebugText(
          'For range: [$range] have start=$start, end=$end and value ${invalidNum.myVal}',
        );
      }

      invalidNum.next();
    }
  }

  return counter;
}
