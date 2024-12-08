import 'package:day_02/day_05.dart';
import 'package:test/test.dart';

void main() {
  test('part 1 sample data', () {
    expect(part1(useSample: true), 143);
  });

  test('part 1 actual data', () {
    expect(part1(useSample: false), 5639);
  });

  test('part 2 sample data', () {
    expect(part2(useSample: true), 123);
  });

  test('part 2 actual data', () {
    expect(part2(useSample: false), 5273);
  });

  test('test name', () {
    populateRulesAndSequences(true);

    expect(sequencePasses([97, 13, 75, 29, 47], 0), (1, 4));
  });
}
