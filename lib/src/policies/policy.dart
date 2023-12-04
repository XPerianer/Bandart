import 'package:bandart/bandart.dart';

/// Policy is an abstract class that implements the logic for choosing an intervention in a bandit setting.
abstract class Policy {
  Policy();

  int choseAction(Map context, DataFrame history);
}
