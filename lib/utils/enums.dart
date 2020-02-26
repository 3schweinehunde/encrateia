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
  powerRatio
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
}
