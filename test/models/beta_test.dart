
import 'package:bandart/models/beta.dart';
import 'package:bandart/models/model.dart';
import 'package:bandart/dataframe.dart';
import 'package:flutter_test/flutter_test.dart';


import '../helpers.dart';

final test_epsilon = 0.01;

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

void main() {
  late Model betaModel;

  setUp(() => {
    betaModel = BetaModel(2)
  });

  test('Equal outcomes should lead to around 50% chance', () {
    final List<double> outcomes = [1, 2, 3, 4, 5, 3, 2, 1, 2, 3, 4, 5, 4, 3, 2, 1];
    betaModel.history = createDataFrame({0: outcomes, 1: outcomes});
    expect(listAlmostEquals(betaModel.approximateProbabilites({}), [0.5, 0.5], test_epsilon), true);
  });


  test('Empty records should lead to 50% chance', () {

    // Not setting a history
    final outcomes = [];
    expect(listAlmostEquals(betaModel.approximateProbabilites({}), [0.5, 0.5], test_epsilon), true);

    // Setting an empty history
    betaModel.history = createDataFrame({});
    expect(listAlmostEquals(betaModel.approximateProbabilites({}), [0.5, 0.5], test_epsilon), true);
  });

  test('Probabilities should be symmetric', () {
    final List<double> outcomesOne = [1, 2, 3, 4, 5];
    final List<double> outcomesTwo = [2, 3, 2, 3, 2];
    betaModel.history = createDataFrame({0: outcomesOne, 1: outcomesTwo});
    final probability = betaModel.approximateProbabilites({});
    betaModel.history = createDataFrame({1: outcomesOne, 0: outcomesTwo});
    final probabilitySwapped = betaModel.approximateProbabilites({});
    expect(probability[0], closeTo(probabilitySwapped[1], test_epsilon));
    expect(probability[1], closeTo(probabilitySwapped[0], test_epsilon));
  });


  test('Dominiks Meditation Example', () {
    final List<double> alternateOutcomes = [2, 4];
    final List<double> experimentOutcomes = [3, 3];
    betaModel.history = createDataFrame({0: alternateOutcomes, 1: experimentOutcomes});
    expect(listAlmostEquals(betaModel.approximateProbabilites({}), [0.2, 0.8], test_epsilon), true);
  });
}