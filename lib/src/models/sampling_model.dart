import 'dart:math';

import 'package:bandart/src/models/model.dart';
import 'package:bandart/src/helpers.dart' as helpers;

/// A SamplingModel is an abstract representation of a model that uses sampling from a posterior distribution to analyze data.
///
/// Usually, after setting the history, one calls model.sample(), and then can use different calls to summarize the posterior distribution.
/// Example:
/// ```dart
/// var model = model
/// model.history = history
/// model.sample()
/// print(model.maxProbabilities())
/// ```
abstract class SamplingModel extends Model {
  /// Random number generator that can be used for seeding
  Random random;

  /// sampleSize is the number of samples drawn on `sample()`
  int sampleSize;
  List<List<double>> _samples = [];

  SamplingModel(
      {required numberOfInterventions,
      required this.random,
      this.sampleSize = 5000})
      : super(numberOfInterventions);

  /// Sample from the posterior distribution.
  /// This will be overwritten by calling sample().
  /// Getter can be used to access the samples in order to calculate custom metrics that are not available by default.
  get samples => _samples;
  set samples(samples) => _samples = samples;

  void sample([Map? context]);

  /// Calculates the probability that intervention is the best by taking an argMax over the samples.
  /// Output is an array of length numberOfInterventions, where each entry is the probability that the corresponding intervention is the best.
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

  /// Convenience Function. Calculates `getSampleProbabilities` with max:true
  List<double> maxProbabilities() {
    return getSampleProbabilities(max: true);
  }

  /// Convenience Function. Calculates `getSampleProbabilities` with max:false
  List<double> minProbabilities() {
    return getSampleProbabilities(max: false);
  }

  /// Calculates the mean of the samples for each intervention.
  /// Output is a List of size numberOfInterventions, where each entry is the mean of the samples for the corresponding intervention.
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
