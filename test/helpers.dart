import 'package:bandart/dataframe.dart';

bool listAlmostEquals<T extends num>(List<T>? a, List<T>? b, epsilon) {
  if (a == null) {
    return b == null;
  }
  if (b == null || a.length != b.length) {
    return false;
  }
  if (identical(a, b)) {
    return true;
  }
  for (int index = 0; index < a.length; index += 1) {
    if ((a[index] - b[index]).abs() > epsilon) {
      return false;
    }
  }
  return true;
}


DataFrame createDataFrame(Map<int, List<double>> interventionToOutcomes) {
  List<int> interventionSeries = [];
  List<double> outcomeSeries = [];
  interventionToOutcomes.forEach((intervention, outcomes) {
    for (var outcome in outcomes) {
      interventionSeries.add(intervention);
      outcomeSeries.add(outcome);
    }
  });
  return DataFrame({'intervention': interventionSeries, 'outcome': outcomeSeries});
}