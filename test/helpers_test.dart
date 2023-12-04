import 'dart:math';

import 'package:bandart/src/helpers.dart';

import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

// Generate a Model that we can control to test how ThompsonSampling Behaves
@GenerateNiceMocks([MockSpec<Random>()])
import 'helpers_test.mocks.dart';

void main() {
  final mockRandom = MockRandom();
  final random = Random();

  test('weighted random picking', () {
    expect(weightedRandom([1, 0, 0], random), 0);
    expect(weightedRandom([0, 1, 0], random), 1);
    expect(weightedRandom([0, 0, 1], random), 2);
  });

  test('weighted random with mocks', () {
    when(mockRandom.nextDouble()).thenReturn(0.5);
    expect(weightedRandom([10, 2, 1], mockRandom), 0);
    expect(weightedRandom([1, 1, 1], mockRandom), 1);
    expect(weightedRandom([0.1, 1, 1], mockRandom), 1);
    expect(weightedRandom([3, 1, 5], mockRandom), 2);
    expect(weightedRandom([1, 0, 10], mockRandom), 2);
  });

  test('weighted random throws on empty input', () {
    expect(() => weightedRandom([], random), throwsA(anything));
  });
}
