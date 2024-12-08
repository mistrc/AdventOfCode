import 'package:day_02/day_04.dart';
import 'package:test/test.dart';

void main() {
  test('part 1 sample data', () {
    expect(part1(useSample: true), 18);
  });

  test('part 1 actual data', () {
    expect(part1(useSample: false), 2543);
  });

  test('part 2 sample data', () {
    expect(part2(useSample: true), 9);
  });

  test('part 2 actual data', () {
    expect(part2(useSample: false), 1930);
  });
}
