import 'package:day_02/day_11.dart';
import 'package:test/test.dart';

void main() {
  test('part 1 sample data', () {
    expect(part1(useSample: true), 55312);
  });

  test('part 1 actual data', () {
    expect(part1(useSample: false), 190865);
  });

  test('part 2 sample data', () {
    expect(part2(useSample: true), 65601038650482);
  });

  test('part 2 actual data', () {
    expect(part2(useSample: false), 225404711855335);
  });
}
