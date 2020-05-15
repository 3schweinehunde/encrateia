class IntPlotPoint {
  int domain;
  int measure;

  IntPlotPoint({this.domain, this.measure});

  String toString() => '< IntPlotPoint | $domain | $measure >';
}

class DoublePlotPoint {
  int domain;
  double measure;

  DoublePlotPoint({this.domain, this.measure});

  String toString() => '< DoublePlotPoint | $domain | $measure >';
}
