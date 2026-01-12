import 'dart:io';

List<int> getData(bool useSample) {
  final lines = useSample
      ? File("data/sampleData").readAsLinesSync()
      : File("data/data").readAsLinesSync();

  return lines[0].codeUnits;
}

void addToMemory(
    {required List<int?> memoryMap, required int length, required int? id}) {
  memoryMap.addAll(List.filled(length, id));
}

void writeOutMemory() {
  print(memoryMap.map((e) => null == e ? ' ' : '$e').join());
}

List<int?> memoryMap = [];
int forward = 0;
int reverse = 0;

bool findEmptyMemory() {
  while (forward < memoryMap.length && memoryMap[forward] != null) {
    ++forward;
  }

  return forward < memoryMap.length;
}

bool findNonEmptyMemory() {
  while (0 <= reverse && memoryMap[reverse] == null) {
    --reverse;
  }

  return 0 <= reverse;
}

bool movePastCurrentId(int currentId) {
  if (memoryMap[reverse] != null) {
    while (0 <= reverse && memoryMap[reverse] == currentId) {
      --reverse;
    }
  }

  return 0 <= reverse;
}

void populateMemoryMap(List<int> line) {
  int fileID = 0;

  memoryMap.clear();

  bool isFile = true;
  for (var char in line) {
    if (isFile) {
      addToMemory(memoryMap: memoryMap, length: char - 48, id: fileID);
      ++fileID;
    } else {
      addToMemory(memoryMap: memoryMap, length: char - 48, id: null);
    }

    isFile = !isFile;
  }
}

int checksum() {
  int total = 0;
  for (var i = 0; i < memoryMap.length && i < 10000; i++) {
    if (null != memoryMap[i]) {
      total += i * memoryMap[i]!;
      // print('$i\t${memoryMap[i]}\t$total');
    }
  }

  return total;
}

int part1({required bool useSample}) {
  final line = getData(useSample);

  populateMemoryMap(line);

  // defrag

  forward = 0;
  reverse = memoryMap.length - 1;

  while (findEmptyMemory() && findNonEmptyMemory() && forward < reverse) {
    final temp = memoryMap[forward];
    memoryMap[forward] = memoryMap[reverse];
    memoryMap[reverse] = temp;
  }

  return checksum();
}

({int spaceNeeded, int currentId}) getSpaceNeeded() {
  int reverseCopy = reverse;

  int currentId = memoryMap[reverseCopy]!;

  int spaceNeeded = 0;

  while (0 <= reverseCopy && memoryMap[reverseCopy] == currentId) {
    --reverseCopy;
    ++spaceNeeded;
  }

  return (spaceNeeded: spaceNeeded, currentId: currentId);
}

({int spaceAvailable, int pos}) findAvailableSpace(int requiredSpace) {
  int pos = 0;
  int spaceAvailable = 0;

  do {
    while (pos < memoryMap.length && null != memoryMap[pos]) {
      ++pos;
    }

    spaceAvailable = 0;

    while (pos < memoryMap.length &&
        memoryMap[pos] == null &&
        spaceAvailable < requiredSpace) {
      ++pos;
      ++spaceAvailable;
    }
  } while (spaceAvailable < requiredSpace && pos < memoryMap.length);

  return (spaceAvailable: spaceAvailable, pos: pos - 1);
}

void swapData(int a, int b, int size) {
  for (var i = 0; i < size; i++) {
    final temp = memoryMap[a - i];
    memoryMap[a - i] = memoryMap[b - i];
    memoryMap[b - i] = temp;
  }
}

int part2({required bool useSample}) {
  final line = getData(useSample);

  populateMemoryMap(line);

  // writeOutMemory();

  // defrag

  int loopCount = 0;

  reverse = memoryMap.length - 1;
  while (loopCount < 100 && findNonEmptyMemory() && 0 < reverse) {
    final fromSpaceCheck = getSpaceNeeded();
    final result = findAvailableSpace(fromSpaceCheck.spaceNeeded);

    if (result.pos < reverse &&
        result.spaceAvailable == fromSpaceCheck.spaceNeeded) {
      // print(spaceNeeded);
      // print(result);
      swapData(result.pos, reverse, fromSpaceCheck.spaceNeeded);
      // writeOutMemory();
    } else {
      movePastCurrentId(fromSpaceCheck.currentId);
    }

    ++loopCount;
  }

  return checksum();
}
