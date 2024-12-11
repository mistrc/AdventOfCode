import 'package:day_02/day_09.dart';
import 'package:test/test.dart';

void main() {
  test('part 1 sample data', () {
    expect(part1(useSample: true), 1928);
  });

  test('part 1 actual data', () {
    expect(part1(useSample: false), 6378826667552);
  });

  test('part 2 sample data', () {
    expect(part2(useSample: true), 2858);
  });

  test('part 2 actual data', () {
    expect(part2(useSample: false),
        15353392287118); // 15353392287118 is too high, BUT WWWWHHHYYYYYY????!!!!!!
  });
}
