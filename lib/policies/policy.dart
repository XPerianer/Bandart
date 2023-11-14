import 'package:ml_dataframe/ml_dataframe.dart';

abstract class Policy {
  Policy();

  int choseAction(Map context, DataFrame history);
}