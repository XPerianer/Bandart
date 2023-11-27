import 'package:bandart/dataframe.dart';
import 'package:bandart/exceptions.dart';
import 'package:bandart/policies/policy.dart';

class FixedPolicy implements Policy {
  final int numberOfInterventions;

  FixedPolicy(this.numberOfInterventions);

  @override
  int choseAction(Map context, DataFrame history) {
    if (!context.containsKey("decisionPoint")) {
      throw ArgumentException("Did not provide number of decision point");
    }
    return context["decisionPoint"] % numberOfInterventions;
  }
}
