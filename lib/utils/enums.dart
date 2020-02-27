enum LapIntAttr {
  power,
  formPower,
  heartRate,
}

enum LapDoubleAttr {
  powerPerHeartRate,
  speedPerHeartRate,
  groundTime,
  strydCadence,
  verticalOscillation,
  legSpringStiffness,
  powerRatio,
  strideRatio,
}

enum ActivityAction {
  parse,
  download,
  delete,
  state,
}

enum ActivityAttr {
  avgPower,
  avgPowerPerHeartRate,
  avgSpeedPerHeartRate,
  avgPowerRatio,
  avgStrideRatio,
}
