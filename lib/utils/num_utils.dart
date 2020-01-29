extension DurationFormatters on num {
  toStringOrDashes(int precision) {
    if (this == -1) {
      return "- - -";
    } else {
      return this.toStringAsFixed(precision);
    }
  }
}