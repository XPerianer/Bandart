import 'package:bandart/bandart.dart';

/// Abstract class with capabilities to model data analysis in a bandit setting
abstract class Model {
  /// The history is the sequence of interventions and outcomes the model can use to learn which interventions have which effects
  DataFrame? history;

  /// The number of interventions are the interventions the model will analyze between [0, numberOfInterventions)
  int numberOfInterventions;

  Model(this.numberOfInterventions);
}
