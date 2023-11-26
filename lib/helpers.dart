library helpers;

import 'package:collection/collection.dart';

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
