import 'dart:math';

import 'package:utils/utils.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
    final awesome = Awesome();

    setUp(() {
      // Additional setup goes here.
    });

    test('First Test', () {
      expect(awesome.isAwesome, isTrue);
    });
  });

  group('grid tests', () {
    group('getting adjacent cells', () {
      Grid grid = Grid(['abcde', 'fghij', 'klmno', 'pqrst', 'uvwxy']);
      setUp(() {
        grid = Grid(['abcde', 'fghij', 'klmno', 'pqrst']);
      });

      test('confirm dimentions', () {
        // Arrange

        // Act
        final xDimention = grid.limitX;
        final yDimention = grid.limitY;

        // Assert
        expect(xDimention, 5);
        expect(yDimention, 4);
      });

      test('adjacent to (0,0)', () {
        // Arrange

        // Act
        final neighbours = grid.adjacentCells(Point(0, 0));
        final neighbourPositions = neighbours.map((e) => e.p);

        // Assert
        expect(neighbours.length, 3);
        expect(neighbourPositions.contains(Point(0, 1)), true);
        expect(neighbourPositions.contains(Point(1, 1)), true);
        expect(neighbourPositions.contains(Point(1, 0)), true);
      });

      test('adjacent to (1,0)', () {
        // Arrange

        // Act
        final neighbours = grid.adjacentCells(Point(1, 0));
        final neighbourPositions = neighbours.map((e) => e.p);

        // Assert
        expect(neighbours.length, 5);
        expect(neighbourPositions.contains(Point(0, 0)), true);
        expect(neighbourPositions.contains(Point(2, 0)), true);
        expect(neighbourPositions.contains(Point(0, 1)), true);
        expect(neighbourPositions.contains(Point(1, 1)), true);
        expect(neighbourPositions.contains(Point(2, 1)), true);
      });

      test('adjacent to (2,0)', () {
        // Arrange

        // Act
        final neighbours = grid.adjacentCells(Point(2, 0));
        final neighbourPositions = neighbours.map((e) => e.p);

        // Assert
        expect(neighbours.length, 5);
        expect(neighbourPositions.contains(Point(1, 0)), true);
        expect(neighbourPositions.contains(Point(3, 0)), true);
        expect(neighbourPositions.contains(Point(1, 1)), true);
        expect(neighbourPositions.contains(Point(2, 1)), true);
        expect(neighbourPositions.contains(Point(3, 1)), true);
      });

      test('adjacent to (3,0)', () {
        // Arrange

        // Act
        final neighbours = grid.adjacentCells(Point(3, 0));
        final neighbourPositions = neighbours.map((e) => e.p);

        // Assert
        expect(neighbours.length, 5);
        expect(neighbourPositions.contains(Point(2, 0)), true);
        expect(neighbourPositions.contains(Point(4, 0)), true);
        expect(neighbourPositions.contains(Point(2, 1)), true);
        expect(neighbourPositions.contains(Point(3, 1)), true);
        expect(neighbourPositions.contains(Point(4, 1)), true);
      });

      test('adjacent to (4,0)', () {
        // Arrange

        // Act
        final neighbours = grid.adjacentCells(Point(4, 0));
        final neighbourPositions = neighbours.map((e) => e.p);

        // Assert
        expect(neighbours.length, 3);
        expect(neighbourPositions.contains(Point(3, 0)), true);
        expect(neighbourPositions.contains(Point(3, 1)), true);
        expect(neighbourPositions.contains(Point(4, 1)), true);
      });

      test('check the order of elements', () {
        // Arrange

        // Act
        final points = <Point>[];
        for (var cell in grid) {
          points.add(cell.p);
        }

        // Assert
        expect(points.length, 20);
        expect(points[0], Point(0, 0));
        expect(points[0 + 1], Point(1, 0));
        expect(points[0 + 2], Point(2, 0));
        expect(points[0 + 3], Point(3, 0));
        expect(points[0 + 4], Point(4, 0));
        expect(points[5], Point(0, 1));
        expect(points[5 + 1], Point(1, 1));
        expect(points[5 + 2], Point(2, 1));
        expect(points[5 + 3], Point(3, 1));
        expect(points[5 + 4], Point(4, 1));
        expect(points[10], Point(0, 2));
        expect(points[10 + 1], Point(1, 2));
        expect(points[10 + 2], Point(2, 2));
        expect(points[10 + 3], Point(3, 2));
        expect(points[10 + 4], Point(4, 2));
        expect(points[15], Point(0, 3));
        expect(points[15 + 1], Point(1, 3));
        expect(points[15 + 2], Point(2, 3));
        expect(points[15 + 3], Point(3, 3));
        expect(points[15 + 4], Point(4, 3));
      });
    });
  });
}
