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
  ecor,
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
  ecor,
}
