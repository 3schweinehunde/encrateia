class IntPlotPoint {
  IntPlotPoint({required this.domain, required this.measure});

  int domain;
  int measure;

  @override
  String toString() => '< IntPlotPoint | $domain | $measure >';
}

class DoublePlotPoint {
  DoublePlotPoint({required this.domain, required this.measure});

  int domain;
  double measure;

  @override
  String toString() => '< DoublePlotPoint | $domain | $measure >';
}

class EnergyPoint {
  EnergyPoint({required this.energy, required this.duration});

  int energy;
  int duration;

  @override
  String toString() => '< EnergyPlotPoint | $energy | $duration >';
}
