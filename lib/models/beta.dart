import 'package:bandart/dataframe.dart';

import 'package:grizzly_distuv/grizzly_distuv.dart';

import 'dart:math';
import 'model.dart';
import 'package:statistics/statistics.dart';

int argMax(List<double> list) {
  return list.asMap().entries.reduce((MapEntry<int, double> l, MapEntry<int, double> r) => l.value > r.value ? l : r).key;
}
class BetaModel implements Model {
  DataFrame? _history;
  int seed = 0;

  @override
  List<double> approximateProbabilites(Map context) {
    double? averageRating;

    if (_history?.shape[1] == 0) {
      return [0.5, 0.5];
    }

    averageRating = _history?["outcome"].mean;
    if (averageRating == null) {
      return [0.5, 0.5];
    }
    // Model Code inspired by Self-E Implementation https://github.com/brownhci/self-e/blob/master/lib/backend/data.dart
    final grouped_by_intervention =
        _history?.groupBy("intervention", "outcome");
    final parameters_by_intervention = [];
    for (int intervention = 0;
        intervention < numberOfInterventions;
        intervention++) {
      int numberOfSucesses = grouped_by_intervention![intervention]!
          .where((outcome) => outcome >= averageRating!)
          .length;
      int numberOfFailures =
          grouped_by_intervention[intervention]!.length - numberOfSucesses;
      parameters_by_intervention.add([numberOfSucesses, numberOfFailures]);
    }

    var betas = [];
    for (var parameters in parameters_by_intervention) {
      final alpha = parameters[0];
      final beta = parameters[1];
      betas.add(Beta(alpha.toDouble() + 1, beta.toDouble() + 1));
    }

    int trials = 40000;
    Random s = Random(seed);
    List<double> winningCounts = List.filled(numberOfInterventions, 0.0);
    for (int i = 0; i < trials; i++) {
      List<double> sampledValues = [];
      for (int intervention = 0;
          intervention < numberOfInterventions;
          intervention++) {
        final beta = betas[intervention];
        double randomExperimentValue = beta.ppf(s.nextDouble());
        sampledValues.add(randomExperimentValue);
      }
      winningCounts[argMax(sampledValues)] += 1;
    }
    // do the winning percentage calculation
    return winningCounts.map((e) => e / trials).toList();
  }

  @override
  List<double> meanInterventionEffect() {
    return [0.3, 0.5];
  }

  BetaModel(this.numberOfInterventions);

  @override
  int numberOfInterventions;

  @override
  set history(DataFrame newHistory) {
    _history = newHistory;
  }
}
