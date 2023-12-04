library helpers;

import 'dart:math';

import 'package:collection/collection.dart';

/// Returns the index of the largest element in the list
int argMax<T extends num>(List<T> list) {
  return list
      .asMap()
      .entries
      .reduce(
          (MapEntry<int, T> l, MapEntry<int, T> r) => l.value > r.value ? l : r)
      .key;
}

double mean(List<num> a, [double defaultValue = 0]) {
  if (a.isEmpty) {
    return defaultValue;
  }
  return a.average;
}

double variance(List<num> a, [double defaultValue = 0]) {
  if (a.isEmpty) {
    return defaultValue;
  }
  double m = mean(a);
  return a.map((e) => (e - m) * (e - m)).average;
}

/// Returns a number between [0, weights.length) with probability proportional to the weights
int weightedRandom(List<double> weights, Random random) {
  assert(weights.isNotEmpty);

  List<num> cumulativeWeights = weights;
  for (int i = 1; i < weights.length; i++) {
    cumulativeWeights[i] += cumulativeWeights[i - 1];
  }

  // Instead of normalizing, we just use the sum (last cumulative weight) as a factor
  double r = random.nextDouble() * cumulativeWeights.last;
  for (int i = 0; i < weights.length; i++) {
    if (r <= cumulativeWeights[i]) {
      return i;
    }
  }
  return weights.length - 1;
}
