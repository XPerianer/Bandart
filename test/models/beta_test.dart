import 'dart:math';

import 'package:bandart/models/beta.dart';
import 'package:bandart/dataframe.dart';
import 'package:bandart/models/sampling_model.dart';
import 'package:test/test.dart';

import '../helpers.dart';

final testEpsilon = 0.01;

DataFrame createDataFrame(Map<int, List<double>> interventionToOutcomes) {
  List<int> interventionSeries = [];
  List<double> outcomeSeries = [];
  interventionToOutcomes.forEach((intervention, outcomes) {
    for (var outcome in outcomes) {
      interventionSeries.add(intervention);
      outcomeSeries.add(outcome);
    }
  });
  return DataFrame(
      {'intervention': interventionSeries, 'outcome': outcomeSeries});
}

void main() {
  late SamplingModel betaModel;

  setUp(() => {
        betaModel = BetaModel(
            numberOfInterventions: 2, a: 1.0, b: 1.0, random: Random(0))
      });

  test('Equal outcomes should lead to around 50% chance', () {
    final List<double> outcomes = [
      1,
      2,
      3,
      4,
      5,
      3,
      2,
      1,
      2,
      3,
      4,
      5,
      4,
      3,
      2,
      1
    ];
    betaModel.history = createDataFrame({0: outcomes, 1: outcomes});
    betaModel.sample();
    expect(
        listAlmostEquals(betaModel.maxProbabilities(), [0.5, 0.5], testEpsilon),
        true);
  });

  test('Empty records should lead to 50% chance', () {
    // Not setting a history
    betaModel.sample();
    expect(
        listAlmostEquals(betaModel.maxProbabilities(), [0.5, 0.5], testEpsilon),
        true);

    // Setting an empty history
    betaModel.history = createDataFrame({});
    betaModel.sample();
    expect(
        listAlmostEquals(betaModel.maxProbabilities(), [0.5, 0.5], testEpsilon),
        true);
  });

  test('Probabilities should be symmetric', () {
    final List<double> outcomesOne = [1, 2, 3, 4, 5];
    final List<double> outcomesTwo = [2, 3, 2, 3, 2];
    betaModel.history = createDataFrame({0: outcomesOne, 1: outcomesTwo});
    betaModel.sample();
    final probability = betaModel.maxProbabilities();
    betaModel.history = createDataFrame({1: outcomesOne, 0: outcomesTwo});
    betaModel.sample();
    final probabilitySwapped = betaModel.maxProbabilities();
    expect(probability[0], closeTo(probabilitySwapped[1], testEpsilon));
    expect(probability[1], closeTo(probabilitySwapped[0], testEpsilon));
  });

  test('Numerical Example', () {
    final List<double> alternateOutcomes = [2, 4];
    final List<double> experimentOutcomes = [3, 3];
    betaModel.history =
        createDataFrame({0: alternateOutcomes, 1: experimentOutcomes});
    betaModel.sample();
    expect(
        listAlmostEquals(betaModel.maxProbabilities(), [0.2, 0.8], testEpsilon),
        true);
  });

  test('Samples should be identical if using same random seed', () {
    var beta =
        BetaModel(numberOfInterventions: 2, a: 2.9, b: 3.7, random: Random(0));
    // Without history samples will be empty
    beta.history = createDataFrame({
      0: [0],
      1: [1]
    });
    beta.sample();
    final firstSample = beta.samples;
    beta.random = Random(0);
    beta.sample();
    final secondSample = beta.samples;
    expect(firstSample.isEmpty, false);
    expect(secondSample.isEmpty, false);
    expect(firstSample, secondSample);
  });
}
