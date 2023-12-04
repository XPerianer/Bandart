/// A DataFrame is a data structure that stores data in a tabular format
class DataFrame {
  Map data;

  DataFrame(this.data);

  get shape => [data.length, data.values.first.length];

  List<num> operator [](String key) {
    return data[key];
  }

  /// Returns a map of the values in the column [column] grouped by the values in the column [key]
  /// Example:
  /// ```dart
  /// var df = DataFrame({'a': [0, 0, 1, 1], 'b': [1, 2, 3, 4]})
  /// df.groupBy('a', 'b') // {0: [1, 2], 1: [3, 4]}
  /// ```
  Map<num, List<num>> groupBy(String key, String column) {
    Map<num, List<num>> values = {};
    var keyValues = data[key];
    for (int i = 0; i < keyValues.length; i++) {
      var keyValue = keyValues[i];
      if (!values.containsKey(keyValue)) {
        values[keyValue] = [];
      }
      values[keyValue]!.add(data[column][i]);
    }
    return values;
  }
}
