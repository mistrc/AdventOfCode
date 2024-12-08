import 'package:day_02/day_02.dart';
import 'package:test/test.dart';

void main() {
  test('part 1 sample data', () {
    expect(part1(useSample: true), 11);
  });

  test('part 1 actual data', () {
    expect(part1(useSample: false), 2769675);
  });

  test('part 2 sample data', () {
    expect(part2(useSample: true), 31);
  });

  test('part 2 actual data', () {
    expect(part2(useSample: false), 24643097);
  });
}
