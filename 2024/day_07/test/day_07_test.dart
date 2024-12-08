import 'package:day_02/day_07.dart';
import 'package:test/test.dart';

void main() {
  test('part 1 sample data', () {
    expect(part1(useSample: true), 3749);
  });

  test('part 1 actual data', () {
    expect(part1(useSample: false), 5702958180383);
  });

  test('part 2 sample data', () {
    expect(part2(useSample: true), 11387);
  });

  test('part 2 actual data', () {
    expect(part2(useSample: false), 92612386119138);
  });
}
