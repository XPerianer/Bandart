import 'package:bandart/dataframe.dart';

abstract class Model {
  // array of floats
  DataFrame? history;

  int numberOfInterventions;

  Model(this.numberOfInterventions);
}
