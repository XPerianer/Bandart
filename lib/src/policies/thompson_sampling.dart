import 'dart:math';

import 'package:bandart/bandart.dart';
import 'package:bandart/helpers.dart';

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
