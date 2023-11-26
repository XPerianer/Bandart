import 'dart:math';

import 'package:bandart/models/model.dart';
import 'package:bandart/helpers.dart' as helpers;

abstract class SamplingModel extends Model {
  // array of floats
  Random random;
  int sampleSize;
  List<List<double>> _samples = [];

  SamplingModel({required numberOfInterventions, required this.random, this.sampleSize = 5000})
      : super(numberOfInterventions);

  get samples => _samples;
  set samples(samples) => _samples = samples;

  void sample([Map? context]);

  List<double> getSampleProbabilities({bool max = true}) {
    if (samples.isEmpty) {
      return List.filled(numberOfInterventions, 1 / numberOfInterventions);
    }
    int factor = max ? 1 : -1;
    List<double> winningCounts = List.filled(numberOfInterventions, 0.0);
    for (int i = 0; i < sampleSize; i++) {
      List<double> sampledValues = [];
      for (int intervention = 0;
          intervention < numberOfInterventions;
          intervention++) {
        sampledValues.add(samples[intervention][i] * factor);
      }
      winningCounts[helpers.argMax(sampledValues)] += 1;
    }
    // do the winning percentage calculation
    return winningCounts.map((e) => e / sampleSize).toList();
  }

  List<double> maxProbabilities() {
    return getSampleProbabilities(max: true);
  }
  List<double> minProbabilities() {
    return getSampleProbabilities(max: false);
  }
  List<double> interventionMeans() {
    List<double> meanInterventionEffect = [];
    for (int intervention = 0;
        intervention < numberOfInterventions;
        intervention++) {
      meanInterventionEffect.add(helpers.mean(samples[intervention]));
    }
    return meanInterventionEffect;
  }

}
