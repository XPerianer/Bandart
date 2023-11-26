
import 'dart:math';

import 'package:bandart/models/gaussian.dart';
import 'package:flutter_test/flutter_test.dart';


import '../helpers.dart';

final testEpsilon = 0.01;


void main() {
  late GaussianModel gaussianModel;

  setUp(() => {
    gaussianModel = GaussianModel(numberOfInterventions: 2, mean: 1.0, l: 1.0, random: Random(0))
  });

  test('Equal outcomes should lead to around 50% chance', () {
    final List<double> outcomes = [1, 2, 3, 4, 5, 3, 2, 1, 2, 3, 4, 5, 4, 3, 2, 1];
    gaussianModel.history = createDataFrame({0: outcomes, 1: outcomes});
    expect(listAlmostEquals(gaussianModel.maxProbabilities(), [0.5, 0.5], testEpsilon), true);
  });


  test('Empty records should lead to 50% chance', () {
    // Not setting a history
    expect(listAlmostEquals(gaussianModel.maxProbabilities(), [0.5, 0.5], testEpsilon), true);

    // Setting an empty history
    gaussianModel.history = createDataFrame({});
    expect(listAlmostEquals(gaussianModel.maxProbabilities(), [0.5, 0.5], testEpsilon), true);
  });

  test('Probabilities should be symmetric', () {
    final List<double> outcomesOne = [1, 2, 3, 4, 5];
    final List<double> outcomesTwo = [2, 3, 2, 3, 2];
    gaussianModel.history = createDataFrame({0: outcomesOne, 1: outcomesTwo});
    final probability = gaussianModel.maxProbabilities();
    gaussianModel.history = createDataFrame({1: outcomesOne, 0: outcomesTwo});
    final probabilitySwapped = gaussianModel.maxProbabilities();
    expect(probability[0], closeTo(probabilitySwapped[1], testEpsilon));
    expect(probability[1], closeTo(probabilitySwapped[0], testEpsilon));
  });


  test('Numerical example', () {
    gaussianModel = GaussianModel(
      random: Random(0),
      numberOfInterventions: 2,
      mean: 2.5, l: 5.0, alpha: 1.0, beta:1.0);
    final List<double> alternateOutcomes = [3, 3];
    final List<double> experimentOutcomes = [5, 4];
    gaussianModel.history = createDataFrame({0: alternateOutcomes, 1: alternateOutcomes});
    gaussianModel.sample();
    expect(listAlmostEquals(gaussianModel.maxProbabilities(), [0.5, 0.5], testEpsilon), true);
    gaussianModel.history = createDataFrame({0: alternateOutcomes, 1: experimentOutcomes});
    gaussianModel.sample();
    expect(listAlmostEquals(gaussianModel.maxProbabilities(), [0.3, 0.7], testEpsilon), true);
  });

  test('Samples should be identical if using same random seed', () {
    var gaussian = GaussianModel(numberOfInterventions: 2, mean: 2.9, l: 3.7, random: Random(0));
    // Without history samples will be empty
    gaussian.history = createDataFrame({0: [0], 1: [1]});
    gaussian.sample();
    final firstSample = gaussian.samples;
    gaussian.random = Random(0);
    gaussian.sample();
    final secondSample = gaussian.samples;
    expect(firstSample.isEmpty, false);
    expect(secondSample.isEmpty, false);
    expect(firstSample, secondSample);
  });

  test('Samples should be different if using different random seed', () {
    var gaussian = GaussianModel(numberOfInterventions: 2, mean: 2.9, l: 3.7, random: Random(0));
    // Without history samples will be empty
    gaussian.history = createDataFrame({0: [0], 1: [1]});
    gaussian.sample();
    final firstSample = gaussian.samples;
    gaussian.random = Random(1);
    gaussian.sample();
    final secondSample = gaussian.samples;
    expect(firstSample.isEmpty, false);
    expect(secondSample.isEmpty, false);
    for (int i = 0; i < 2; i++ ){
      expect(listAlmostEquals(firstSample[i], secondSample[i], testEpsilon), false);
    }
  });
}