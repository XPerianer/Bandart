import 'dart:math';

import 'package:bandart/bandart.dart';
import 'package:bandart/helpers.dart';

/// ThompsonSampling is a policy that picks an intervention based on the probability of it being the best intervention.
///
/// For example: If the probability of intervention 0 beeing the best intervention is 0.8, then ThompsonSampling will pick intervention 0 with a probability of 0.8.
class ThompsonSampling implements Policy {
  final SamplingModel model;
  final Random random;

  ThompsonSampling({required this.model, required this.random});

  @override
  int choseAction(Map context, history, {max = true}) {
    model.history = history;
    model.sample();
    final probabilities = model.getSampleProbabilities(max: max);
    return weightedRandom(probabilities, random);
  }
}
