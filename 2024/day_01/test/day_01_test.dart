import 'package:day_01/day_01.dart';
import 'package:test/test.dart';

void main() {
  test('calculate', () {
    expect(part1(useSample: true), 11);

    expect(part1(useSample: false), 2769675);

    expect(part2(useSample: true), 31);

    expect(part2(useSample: false), 24643097);
  });
}
