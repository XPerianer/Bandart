import 'package:bandart/src/helpers.dart' as helpers;
import 'package:bandart/src/models/sampling_model.dart';

import 'package:data/data.dart';

import 'dart:math';

/// GaussianModel is a SamplingModel that models the data under each intervention after a Gaussian distribution with unknown mean and variance
///
/// The model is based on the Normal-Inverse-Gamma distribution.
/// See https://en.wikipedia.org/wiki/Normal-inverse-gamma_distribution for details.
/// The formulas used to update the priors can be found under https://en.wikipedia.org/wiki/Conjugate_prior
/// under "Normal with unknown mean and variance"
/// The distribution is model as follows:
/// $outcome \sim N(\mu, \sigma^2 / l)$
/// $\sigma^2 \sim IG(\alpha, \beta)$
class GaussianModel extends SamplingModel {
  final double _mean, _l, _alpha, _beta;

  /// Initalizes a GaussianModel
  ///
  /// mean, l, alpha, beta are the priors for the Normal-Inverse-Gamma distribution.
  GaussianModel(
      {required numberOfInterventions,
      required mean,
      required l,
      required random,
      sampleSize = 10000,
      alpha = 1.0,
      beta = 1.0})
      : _l = l,
        _mean = mean,
        _alpha = alpha,
        _beta = beta,
        super(
            numberOfInterventions: numberOfInterventions,
            random: random,
            sampleSize: 5000);

  List<num> outcomesByInterventions(int intervention) {
    if (history == null) {
      return [];
    }
    var groupBy = history!.groupBy("intervention", "outcome");
    if (!groupBy.containsKey(intervention)) {
      return [];
    }
    return history!.groupBy("intervention", "outcome")[intervention]!;
  }

  double variance(int intervention) {
    return helpers.variance(outcomesByInterventions(intervention));
  }

  double meanUpdate(int intervention) {
    return (_l * _mean + n(intervention) * sampleMean(intervention)) /
        (_l + n(intervention));
  }

  double lUpdate(int intervention) {
    return _l + n(intervention);
  }

  double alphaUpdate(int intervention) {
    return _alpha + n(intervention) / 2;
  }

  double betaUpdate(int intervention) {
    return _beta +
        0.5 * variance(intervention) +
        n(intervention) *
            _l *
            pow(sampleMean(intervention) - _mean, 2) /
            (_l + n(intervention));
  }

  int n(int intervention) {
    return outcomesByInterventions(intervention).length;
  }

  double sampleMean(int intervention) {
    return helpers.mean(outcomesByInterventions(intervention));
  }

  List<List<double>> sampleNormalInverseGamma(List<double> mean, List<double> l,
      List<double> alpha, List<double> beta, sampleSize) {
    var gammas = [];
    for (int i = 0; i < numberOfInterventions; i++) {
      gammas.add(InverseGammaDistribution(alpha[i], beta[i]));
    }

    List<List<double>> sigmaSquaredSamples = [];
    for (int intervention = 0;
        intervention < numberOfInterventions;
        intervention++) {
      sigmaSquaredSamples.add([]);
      for (int i = 0; i < sampleSize; i++) {
        sigmaSquaredSamples[intervention]
            .add(gammas[intervention].sample(random: random));
      }
    }
    List<List<double>> samples = [];
    for (int intervention = 0;
        intervention < numberOfInterventions;
        intervention++) {
      samples.add([]);
      for (int i = 0; i < sampleSize; i++) {
        samples[intervention].add(NormalDistribution(mean[intervention],
                sqrt(sigmaSquaredSamples[intervention][i] / l[intervention]))
            .sample(random: random));
      }
    }
    return samples;
  }

  @override
  void sample([Map? context]) {
    List<double> mean = [], l = [], beta = [], alpha = [];

    for (int intervention = 0;
        intervention < numberOfInterventions;
        intervention++) {
      mean.add(meanUpdate(intervention));
      l.add(lUpdate(intervention));
      alpha.add(alphaUpdate(intervention));
      beta.add(betaUpdate(intervention));
    }

    samples = sampleNormalInverseGamma(mean, l, alpha, beta, sampleSize);
  }
}
