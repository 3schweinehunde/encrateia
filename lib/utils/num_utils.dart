extension DurationFormatters on num {
  toStringOrDashes(int precision) {
    if (this == -1 || this == null) {
      return "- - -";
    } else {
      return this.toStringAsFixed(precision);
    }
  }
}
