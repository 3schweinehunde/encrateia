extension DurationFormatters on num {
  String toStringOrDashes(int precision) {
    if (this == -1 || this == null) {
      return '- - -';
    } else {
      return toStringAsFixed(precision);
    }
  }
}
