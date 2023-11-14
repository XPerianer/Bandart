class DataFrame {
  Map data;
  
  DataFrame(this.data);

  get shape => [data.length, data.values.first.length];

  List<num> operator [](String key) {
    return data[key];
  }

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