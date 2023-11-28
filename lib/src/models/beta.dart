import 'package:bandart/bandart.dart';

import 'package:data/data.dart';

import 'package:bandart/src/helpers.dart' as helpers;

/// BetaModel is a SamplingModel that models the data under each intervention after a Beta distribution.
///
/// Each Beta Variable models the probability of an intervention beeing a success.
/// A success is defined as an outcome that is greater than the average outcome.
/// For example if the outcomes for an intervention are [1, 2, 3], then the average outcome is 2, and the last two outcomes are successes.
class BetaModel extends SamplingModel {
  final double _a, _b;

  BetaModel(
      {required numberOfInterventions,
      required random,
      a = 1.0,
      b = 1.0,
      sampleSize = 5000})
      : _a = a,
        _b = b,
        super(
            numberOfInterventions: numberOfInterventions,
            random: random,
            sampleSize: sampleSize);

  @override
  void sample([Map? context]) {
    double? averageRating;

    if (history == null) {
      return;
    }
    if (history?.shape[1] == 0) {
      return;
    }

    var outcomes = history!["outcome"];
    if (outcomes.isEmpty) {
      return;
    }
    averageRating = helpers.mean(history!["outcome"]);
    // Model Code inspired by Self-E Implementation https://github.com/brownhci/self-e/blob/master/lib/backend/data.dart
    final groupedByIntervention = history?.groupBy("intervention", "outcome");
    final parametersByIntervention = [];
    for (int intervention = 0;
        intervention < numberOfInterventions;
        intervention++) {
      int numberOfSucesses = groupedByIntervention![intervention]!
          .where((outcome) => outcome >= averageRating!)
          .length;
      int numberOfFailures =
          groupedByIntervention[intervention]!.length - numberOfSucesses;
      parametersByIntervention.add([numberOfSucesses, numberOfFailures]);
    }

    var betas = [];
    for (var parameters in parametersByIntervention) {
      final alpha = parameters[0];
      final beta = parameters[1];
      betas.add([alpha.toDouble() + _a, beta.toDouble() + _b]);
    }

    List<List<double>> sampledValues = [];
    for (int intervention = 0;
        intervention < numberOfInterventions;
        intervention++) {
      sampledValues.add([]);
      final beta = betas[intervention];
      for (int i = 0; i < sampleSize; i++) {
        double randomExperimentValue =
            ibetaInv(random.nextDouble(), beta[0], beta[1]);
        sampledValues[intervention].add(randomExperimentValue);
      }
    }

    samples = sampledValues;
  }
}
