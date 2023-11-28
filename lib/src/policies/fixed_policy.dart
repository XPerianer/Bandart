import 'package:bandart/src/exceptions.dart';
import 'package:bandart/bandart.dart';

/// FixedPolicy implements a fixed schedule that repeats the sequence of increasing interventions.
///
/// Example: If numberOfInterventions is 3, then the sequence of interventions will be 0, 1, 2, 0, 1, 2, ...
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
