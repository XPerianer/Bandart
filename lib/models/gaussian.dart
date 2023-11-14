
import 'package:statistics/statistics.dart';
import 'package:bandart/dataframe.dart';

import 'dart:math';

import 'model.dart';
import 'package:grizzly_distuv/grizzly_distuv.dart';

class GaussianModel implements Model {
  DataFrame? _history;
  int seed = 0;
  int numberOfInterventions;

  double mean, l, alpha, beta;
  GaussianModel(this.numberOfInterventions, this.mean, this.l, this.alpha, this.beta);

  List<num> outcomesByInterventions(int intervention) {
    return _history!.groupBy("intervention", "outcome")[intervention]!;
  }

  double variance(int intervention) {
    return (outcomesByInterventions(intervention) as List<double>).variance;
  }

  double meanUpdate (int intervention) {
    return (l * mean + n(intervention) * sampleMean(intervention)) / (l + n(intervention));
  }

  double lUpdate (int intervention) {
    return l + n(intervention);
  }

  double alphaUpdate (int intervention) {
    return alpha + n(intervention) / 2;
  }

  double betaUpdate (int intervention) {
    return beta + 0.5 * variance(intervention) + n(intervention) * l * pow(sampleMean(intervention) - mean, 2) / (l + n(intervention));
  }

  int n(int intervention) {
    return outcomesByInterventions(intervention).length;
  }

  double sampleMean(int intervention) {
    return outcomesByInterventions(intervention).mean;
  }

  List<List<double>> sampleNormalInverseGamma(mean, l, alpha, beta, sampleSize) {
    var gamma = Gamma(alpha, beta);
    Random s = Random(seed);
    List<List<double>> sigmaSquaredSamples = [];
    for (int intervention = 0; intervention < numberOfInterventions; intervention++) {
      sigmaSquaredSamples.add([]);
      for (int i = 0; i < sampleSize; i++) {
        sigmaSquaredSamples[intervention].add(1 / gamma.ppf(s.nextDouble()));
      }
    }
    List<List<double>> samples = [];
    for (int intervention = 0; intervention < numberOfInterventions; intervention++) {
      samples.add([]);
      for (int i = 0; i < sampleSize; i++) {
        samples[intervention].add(Normal(mean, sqrt(sigmaSquaredSamples[intervention][i])).ppf(s.nextDouble()));
      }
    }
    return samples;
  }

  @override
  List<double> approximateProbabilites(Map context) {
    // Calculate posterior parameters
    // See https://en.wikipedia.org/wiki/Conjugate_prior and then Normal with unkown mean and variance
 

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
