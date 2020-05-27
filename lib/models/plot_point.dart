class IntPlotPoint {
  IntPlotPoint({this.domain, this.measure});

  int domain;
  int measure;

  @override
  toString() => '< IntPlotPoint | $domain | $measure >';
}

class DoublePlotPoint {
  DoublePlotPoint({this.domain, this.measure});

  int domain;
  double measure;

  @override
  toString() => '< DoublePlotPoint | $domain | $measure >';
}
