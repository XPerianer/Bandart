import 'package:bandart/dataframe.dart';

abstract class Model {
  // array of floats
  DataFrame? _history;

  int numberOfInterventions;

  Model(this.numberOfInterventions);
  
  List<double> approximateProbabilites(Map context);
  List<double> meanInterventionEffect();
  
  set history(DataFrame newHistory);
  }
