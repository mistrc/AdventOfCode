import 'dart:io';

List<String> getData(bool useSample) {
  return useSample
      ? File("data/sampleData").readAsLinesSync()
      : File("data/data").readAsLinesSync();
}

int part1({required bool useSample}) {
  final lines = getData(useSample);

  for (var line in lines) {
    // impl here
  }

  return 0;
}

int part2({required bool useSample}) {
  final lines = getData(useSample);

  for (var line in lines) {
    // impl here
  }

  return 0;
}
