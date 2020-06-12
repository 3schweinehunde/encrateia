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

enum ActivityAttr {
  avgPower,
  avgPowerPerHeartRate,
  avgSpeedPerHeartRate,
  avgPowerRatio,
  avgStrideRatio,
  ecor,
}

enum OnBoardingStep {
  introduction,
  createUser,
  credentials,
  weight,
  powerZones,
  heartRateZones,
  finished,
}
