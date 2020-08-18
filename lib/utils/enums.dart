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
  pace,
  speed,
  altitude,
}

enum ActivityAttr {
  avgPower,
  avgPowerPerHeartRate,
  avgSpeedPerHeartRate,
  avgPowerRatio,
  avgStrideRatio,
  ecor,
  avgPace,
  avgHeartRate,
  avgDoubleStrydCadence,
  ftp,
}

enum IntervalBoundary {
  left,
  right,
}

enum DateTimeFormat {
  shortDate,
  shortTime,
  longDate,
  shortDateTime,
  longDateTime,
}

enum PQ {
  dateTime,
  distance,
  power,
  pace,
  heartRate,
  ecor,
  powerPerHeartRate,
  calories,
  elevation,
  cadence,
  duration,
  trainingEffect,
  text,
  temperature,
  verticalOscillation,
  cycles,
  integer,
  fractionalCadence,
  stanceTime,
  percentage,
  longitude,
  latitude,
  speed,
  speedPerHeartRate,
  weight,
}
