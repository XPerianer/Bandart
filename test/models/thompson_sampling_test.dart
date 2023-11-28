import 'dart:math';

import 'package:bandart/bandart.dart';
import 'package:test/test.dart';

import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

// Generate a Model that we can control to test how ThompsonSampling Behaves
@GenerateNiceMocks([MockSpec<BetaModel>()])
import 'thompson_sampling_test.mocks.dart';

void main() {
  DataFrame emptyHistory = DataFrame({});

  test('Should select the outcome with 1.0 probability', () {
    var mockModel = MockBetaModel();
    when(mockModel.getSampleProbabilities()).thenReturn([1.0, 0.0]);

    var thompsonSampling =
        ThompsonSampling(model: mockModel, random: Random(0));
    expect(thompsonSampling.choseAction({}, emptyHistory), 0);

    when(mockModel.maxProbabilities()).thenReturn([0.0, 1.0]);
    expect(thompsonSampling.choseAction({}, emptyHistory), 1);
  });

  test('Should run the example from the readme', () {
    // We use more extreme values for the outcomes there to make sure the model
    // gives the probabilities close to [0, 1.0] and 1 is picked.
    var history = DataFrame({
      'intervention': [0, 0, 1, 1],
      'outcome': [-100.0, -100.0, 10.0, 100.0]
    });

    // Mean and L are priors for the normal model
    var gaussianModel = GaussianModel(
        numberOfInterventions: 2, mean: 1.0, l: 1.0, random: Random(0));

    var policy = ThompsonSampling(model: gaussianModel, random: Random(0));

    expect(policy.choseAction({}, history), 1);
  });
}
