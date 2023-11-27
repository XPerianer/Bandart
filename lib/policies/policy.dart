import 'package:bandart/dataframe.dart';

abstract class Policy {
  Policy();

  int choseAction(Map context, DataFrame history);
}
