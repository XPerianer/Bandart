// Create a simple adaptive simulation using a Gaussian Model
// Example can be run with dart run example/main.dart
// Example output:
// ```
// Chose intervention 0 and got outcome 0.3
// Chose intervention 1 and got outcome 0.9
// Chose intervention 1 and got outcome 0.9
// Chose intervention 1 and got outcome 0.9
// Chose intervention 1 and got outcome 0.9
// Chose intervention 0 and got outcome 0.3
// Chose intervention 1 and got outcome 0.9
// Chose intervention 1 and got outcome 0.9
// Chose intervention 1 and got outcome 0.9
// Chose intervention 1 and got outcome 0.9
// ```
// Intervention 1 is sampled more often, as it gets better outcomes.

import 'dart:math';

import 'package:bandart/bandart.dart';

void main() {
  var model = GaussianModel(
      numberOfInterventions: 2,
      mean: 0.0,
      l: 1.0,
      random: Random(42),
      sampleSize: 10000,
      alpha: 1.0,
      beta: 1.0);

  var policy = ThompsonSampling(model: model, random: Random(42));

  var history = DataFrame({
    'intervention': [0, 0, 1, 1],
    'outcome': [1.0, 1.0, 2.0, 2.0]
  });

  // Usually, new outcomes are measured outside, like click rates in an AB testing. For simplicity, we just use some random numbers here.
  final new_outcomes_for_interventions = [0.3, 0.9];
  for (int i = 0; i < 10; i++) {
    // Select which action to chose:
    var intervention = policy.choseAction({}, history);
    var outcome = new_outcomes_for_interventions[intervention];

    // Add datapoint
    history['intervention'].add(intervention);
    history['outcome'].add(outcome);
    print("Chose intervention $intervention and got outcome $outcome");
  }
}
