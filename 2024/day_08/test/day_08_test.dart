import 'package:day_02/day_08.dart';
import 'package:test/test.dart';

void main() {
  test('part 1 sample data', () {
    expect(part1(useSample: true), 14);
  });

  test('part 1 actual data', () {
    expect(part1(useSample: false), 336); //329); //361
  });

  test('part 2 sample data', () {
    expect(part2(useSample: true), 34);
  });

  test('part 2 actual data', () {
    expect(part2(useSample: false), 1131);
  });
}
