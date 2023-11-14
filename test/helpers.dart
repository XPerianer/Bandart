bool listAlmostEquals<T>(List<num>? a, List<num>? b, epsilon) {
  if (a == null) {
    return b == null;
  }
  if (b == null || a.length != b.length) {
    return false;
  }
  if (identical(a, b)) {
    return true;
  }
  for (int index = 0; index < a.length; index += 1) {
    if ((a[index] - b[index]).abs() > epsilon) {
      return false;
    }
  }
  return true;
}