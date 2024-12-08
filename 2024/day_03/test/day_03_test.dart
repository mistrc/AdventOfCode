import 'package:day_02/day_03.dart';
import 'package:test/test.dart';

void main() {
  test('part 1 sample data', () {
    expect(part1(useSample: true), 161);
  });

  test('part 1 actual data', () {
    expect(part1(useSample: false), 181345830);
  });

  test('part 2 sample data', () {
    expect(part2(useSample: true), 48);
  });

  test('part 2 actual data', () {
    expect(part2(useSample: false), 98729041);
  });
}
