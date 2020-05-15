// To update model.g.dart and model.g.form.dart run in the console:
// flutter pub run build_runner build --delete-conflicting-outputs

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:sqfentity/sqfentity.dart';
import 'package:sqfentity_gen/sqfentity_gen.dart';

part 'model.g.dart';

const tableAthlete = SqfEntityTable(
  tableName: 'athletes',
  primaryKeyName: 'id',
  primaryKeyType: PrimaryKeyType.integer_auto_incremental,
  useSoftDeleting: false,
  modelName: 'DbAthlete',
  fields: [
    SqfEntityField('state', DbType.text, defaultValue: "new"),
    SqfEntityField('firstName', DbType.text),
    SqfEntityField('lastName', DbType.text),
    SqfEntityField('stravaUsername', DbType.text),
    SqfEntityField('photoPath', DbType.text),
    SqfEntityField('stravaId', DbType.integer),
    SqfEntityField('geoState', DbType.text),
    SqfEntityField('downloadInterval', DbType.integer),
    SqfEntityField('recordAggregationCount', DbType.integer),
  ],
);

const tableActivity = SqfEntityTable(
  tableName: 'activities',
  primaryKeyName: 'id',
  primaryKeyType: PrimaryKeyType.integer_auto_incremental,
  useSoftDeleting: false,
  modelName: 'DbActivity',
  fields: [
    SqfEntityField('state', DbType.text, defaultValue: "new"),
    SqfEntityField('path', DbType.text),
    SqfEntityField('stravaId', DbType.integer),
    SqfEntityField('name', DbType.text),
    SqfEntityField('movingTime', DbType.integer),
    SqfEntityField('type', DbType.text),
    SqfEntityField('distance', DbType.integer),
    SqfEntityField('serialNumber', DbType.integer),
    SqfEntityField('timeCreated', DbType.datetime),
    SqfEntityField('sportName', DbType.text),
    SqfEntityField('sport', DbType.text),
    SqfEntityField('subSport', DbType.text),
    SqfEntityField('timeStamp', DbType.datetime),
    SqfEntityField('startTime', DbType.datetime),
    SqfEntityField('startPositionLat', DbType.real),
    SqfEntityField('startPositionLong', DbType.real),
    SqfEntityField('event', DbType.text),
    SqfEntityField('eventType', DbType.text),
    SqfEntityField('eventGroup', DbType.integer),
    SqfEntityField('totalDistance', DbType.integer),
    SqfEntityField('totalStrides', DbType.integer),
    SqfEntityField('totalCalories', DbType.integer),
    SqfEntityField('avgSpeed', DbType.real),
    SqfEntityField('maxSpeed', DbType.real),
    SqfEntityField('totalAscent', DbType.integer),
    SqfEntityField('totalDescent', DbType.integer),
    SqfEntityField('maxRunningCadence', DbType.integer),
    SqfEntityField('trigger', DbType.text),
    SqfEntityField('avgTemperature', DbType.integer),
    SqfEntityField('maxTemperature', DbType.integer),
    SqfEntityField('avgFractionalCadence', DbType.real),
    SqfEntityField('maxFractionalCadence', DbType.real),
    SqfEntityField('totalFractionalCycles', DbType.real),
    SqfEntityField('avgStanceTimePercent', DbType.real),
    SqfEntityField('avgStanceTime', DbType.real),
    SqfEntityField('avgHeartRate', DbType.integer),
    SqfEntityField('maxHeartRate', DbType.integer),
    SqfEntityField('avgRunningCadence', DbType.real),
    SqfEntityField('avgVerticalOscillation', DbType.real),
    SqfEntityField('totalElapsedTime', DbType.integer),
    SqfEntityField('totalTimerTime', DbType.integer),
    SqfEntityField('totalTrainingEffect', DbType.integer),
    SqfEntityField('necLat', DbType.real),
    SqfEntityField('necLong', DbType.real),
    SqfEntityField('swcLat', DbType.real),
    SqfEntityField('swcLong', DbType.real),
    SqfEntityField('firstLapIndex', DbType.integer),
    SqfEntityField('numLaps', DbType.integer),
    SqfEntityField('numSessions', DbType.integer),
    SqfEntityField('localTimestamp', DbType.datetime),
    // Cached calculated values:
    SqfEntityField('avgPower', DbType.real),
    SqfEntityField('minPower', DbType.integer),
    SqfEntityField('maxPower', DbType.integer),
    SqfEntityField('sdevPower', DbType.real),
    SqfEntityField('avgGroundTime', DbType.real),
    SqfEntityField('sdevGroundTime', DbType.real),
    SqfEntityField('avgLegSpringStiffness', DbType.real),
    SqfEntityField('sdevLegSpringStiffness', DbType.real),
    SqfEntityField('avgFormPower', DbType.real),
    SqfEntityField('sdevFormPower', DbType.real),
    SqfEntityField('avgPowerRatio', DbType.real),
    SqfEntityField('sdevPowerRatio', DbType.real),
    SqfEntityField('avgStrideRatio', DbType.real),
    SqfEntityField('sdevStrideRatio', DbType.real),
    SqfEntityField('avgStrydCadence', DbType.real),
    SqfEntityField('sdevStrydCadence', DbType.real),
    SqfEntityField('sdevVerticalOscillation', DbType.real),

    SqfEntityFieldRelationship(
        parentTable: tableAthlete,
        deleteRule: DeleteRule.CASCADE,
        defaultValue: 0),
  ],
);

const tableEvent = SqfEntityTable(
  tableName: 'events',
  primaryKeyName: 'id',
  primaryKeyType: PrimaryKeyType.integer_auto_incremental,
  useSoftDeleting: false,
  modelName: 'DbEvent',
  fields: [
    SqfEntityField('event', DbType.text),
    SqfEntityField('eventType', DbType.text),
    SqfEntityField('eventGroup', DbType.integer),
    SqfEntityField('timerTrigger', DbType.text),
    SqfEntityField('timeStamp', DbType.datetime),
    SqfEntityField('positionLat', DbType.real),
    SqfEntityField('positionLong', DbType.real),
    SqfEntityField('distance', DbType.real),
    SqfEntityField('altitude', DbType.real),
    SqfEntityField('speed', DbType.real),
    SqfEntityField('heartRate', DbType.integer),
    SqfEntityField('cadence', DbType.real),
    SqfEntityField('fractionalCadence', DbType.real),
    SqfEntityField('power', DbType.integer),
    SqfEntityField('strydCadence', DbType.real),
    SqfEntityField('groundTime', DbType.real),
    SqfEntityField('verticalOscillation', DbType.real),
    SqfEntityField('formPower', DbType.integer),
    SqfEntityField('legSpringStiffness', DbType.real),
    SqfEntityField('data', DbType.real),
    SqfEntityFieldRelationship(
      parentTable: tableActivity,
      deleteRule: DeleteRule.CASCADE,
      defaultValue: 0,
    ),
    SqfEntityFieldRelationship(
      parentTable: tableLap,
      deleteRule: DeleteRule.CASCADE,
      defaultValue: 0,
    ),
  ],
);

const tableLap = SqfEntityTable(
  tableName: 'laps',
  primaryKeyName: 'id',
  primaryKeyType: PrimaryKeyType.integer_auto_incremental,
  useSoftDeleting: false,
  modelName: 'DbLap',
  fields: [
    SqfEntityField('timeStamp', DbType.datetime),
    SqfEntityField('startTime', DbType.datetime),
    SqfEntityField('startPositionLat', DbType.real),
    SqfEntityField('startPositionLong', DbType.real),
    SqfEntityField('endPositionLat', DbType.real),
    SqfEntityField('endPositionLong', DbType.real),
    SqfEntityField('avgHeartRate', DbType.integer),
    SqfEntityField('maxHeartRate', DbType.integer),
    SqfEntityField('avgRunningCadence', DbType.real),
    SqfEntityField('event', DbType.text),
    SqfEntityField('eventType', DbType.text),
    SqfEntityField('eventGroup', DbType.integer),
    SqfEntityField('sport', DbType.text),
    SqfEntityField('subSport', DbType.text),
    SqfEntityField('avgVerticalOscillation', DbType.real),
    SqfEntityField('totalElapsedTime', DbType.integer),
    SqfEntityField('totalTimerTime', DbType.integer),
    SqfEntityField('totalDistance', DbType.integer),
    SqfEntityField('totalStrides', DbType.integer),
    SqfEntityField('totalCalories', DbType.integer),
    SqfEntityField('avgSpeed', DbType.real),
    SqfEntityField('maxSpeed', DbType.real),
    SqfEntityField('totalAscent', DbType.integer),
    SqfEntityField('totalDescent', DbType.integer),
    SqfEntityField('avgStanceTimePercent', DbType.real),
    SqfEntityField('avgStanceTime', DbType.real),
    SqfEntityField('maxRunningCadence', DbType.integer),
    SqfEntityField('intensity', DbType.integer),
    SqfEntityField('lapTrigger', DbType.text),
    SqfEntityField('avgTemperature', DbType.integer),
    SqfEntityField('maxTemperature', DbType.integer),
    SqfEntityField('avgFractionalCadence', DbType.real),
    SqfEntityField('maxFractionalCadence', DbType.real),
    SqfEntityField('totalFractionalCycles', DbType.real),
    // Cached calculated values:
    SqfEntityField('avgPower', DbType.real),
    SqfEntityField('minPower', DbType.integer),
    SqfEntityField('maxPower', DbType.integer),
    SqfEntityField('sdevPower', DbType.real),
    SqfEntityField('avgGroundTime', DbType.real),
    SqfEntityField('sdevGroundTime', DbType.real),
    SqfEntityField('avgLegSpringStiffness', DbType.real),
    SqfEntityField('sdevLegSpringStiffness', DbType.real),
    SqfEntityField('avgFormPower', DbType.real),
    SqfEntityField('sdevFormPower', DbType.real),
    SqfEntityField('avgStrydCadence', DbType.real),
    SqfEntityField('sdevStrydCadence', DbType.real),
    SqfEntityField('sdevVerticalOscillation', DbType.real),
    SqfEntityField('avgPowerRatio', DbType.real),
    SqfEntityField('sdevPowerRatio', DbType.real),
    SqfEntityField('avgStrideRatio', DbType.real),
    SqfEntityField('sdevStrideRatio', DbType.real),

    SqfEntityFieldRelationship(
        parentTable: tableActivity,
        deleteRule: DeleteRule.CASCADE,
        defaultValue: 0),
  ],
);

const tableWeight = SqfEntityTable(
  tableName: 'weights',
  primaryKeyName: 'id',
  primaryKeyType: PrimaryKeyType.integer_auto_incremental,
  useSoftDeleting: false,
  modelName: 'DbWeight',
  fields: [
    SqfEntityField('date', DbType.date),
    SqfEntityField('value', DbType.real),
    SqfEntityFieldRelationship(
        parentTable: tableAthlete,
        deleteRule: DeleteRule.CASCADE,
        defaultValue: 0),
  ],
);

const tablePowerZoneSchema = SqfEntityTable(
  tableName: 'powerZoneSchemata',
  primaryKeyName: 'id',
  primaryKeyType: PrimaryKeyType.integer_auto_incremental,
  useSoftDeleting: false,
  modelName: 'DbPowerZoneSchema',
  fields: [
    SqfEntityField('date', DbType.date),
    SqfEntityField('name', DbType.text),
    SqfEntityField('base', DbType.integer),
    SqfEntityFieldRelationship(
        parentTable: tableAthlete,
        deleteRule: DeleteRule.CASCADE,
        defaultValue: 0),
  ],
);

const tablePowerZone = SqfEntityTable(
  tableName: 'powerZone',
  primaryKeyName: 'id',
  primaryKeyType: PrimaryKeyType.integer_auto_incremental,
  useSoftDeleting: false,
  modelName: 'DbPowerZone',
  fields: [
    SqfEntityField('name', DbType.text),
    SqfEntityField('lowerPercentage', DbType.integer),
    SqfEntityField('upperPercentage', DbType.integer),
    SqfEntityField('lowerLimit', DbType.integer),
    SqfEntityField('upperLimit', DbType.integer),
    SqfEntityField('color', DbType.integer),
    SqfEntityFieldRelationship(
        parentTable: tablePowerZoneSchema,
        deleteRule: DeleteRule.CASCADE,
        defaultValue: 0),
  ],
);

const tableHeartRateZoneSchema = SqfEntityTable(
  tableName: 'heartRateZoneSchemata',
  primaryKeyName: 'id',
  primaryKeyType: PrimaryKeyType.integer_auto_incremental,
  useSoftDeleting: false,
  modelName: 'DbHeartRateZoneSchema',
  fields: [
    SqfEntityField('date', DbType.date),
    SqfEntityField('name', DbType.text),
    SqfEntityField('base', DbType.integer),
    SqfEntityFieldRelationship(
        parentTable: tableAthlete,
        deleteRule: DeleteRule.CASCADE,
        defaultValue: 0),
  ],
);

const tableHeartRateZone = SqfEntityTable(
  tableName: 'heartRateZone',
  primaryKeyName: 'id',
  primaryKeyType: PrimaryKeyType.integer_auto_incremental,
  useSoftDeleting: false,
  modelName: 'DbHeartRateZone',
  fields: [
    SqfEntityField('name', DbType.text),
    SqfEntityField('lowerPercentage', DbType.integer),
    SqfEntityField('upperPercentage', DbType.integer),
    SqfEntityField('lowerLimit', DbType.integer),
    SqfEntityField('upperLimit', DbType.integer),
    SqfEntityField('color', DbType.integer),
    SqfEntityFieldRelationship(
        parentTable: tableHeartRateZoneSchema,
        deleteRule: DeleteRule.CASCADE,
        defaultValue: 0),
  ],
);

const tableTagGroup = SqfEntityTable(
  tableName: 'tagGroups',
  primaryKeyName: 'id',
  primaryKeyType: PrimaryKeyType.integer_auto_incremental,
  useSoftDeleting: false,
  modelName: 'DbTagGroup',
  fields: [
    SqfEntityField('name', DbType.text),
    SqfEntityField('color', DbType.integer),
    SqfEntityField('system', DbType.bool),
    SqfEntityFieldRelationship(
        parentTable: tableAthlete,
        deleteRule: DeleteRule.CASCADE,
        defaultValue: 0),
  ],
);

const tableTag = SqfEntityTable(
  tableName: 'tags',
  primaryKeyName: 'id',
  primaryKeyType: PrimaryKeyType.integer_auto_incremental,
  useSoftDeleting: false,
  modelName: 'DbTag',
  fields: [
    SqfEntityField('name', DbType.text),
    SqfEntityField('color', DbType.integer),
    SqfEntityField('system', DbType.bool),
    SqfEntityFieldRelationship(
        parentTable: tableTagGroup,
        deleteRule: DeleteRule.CASCADE,
        defaultValue: 0),
  ],
);

const tableLapTagging = SqfEntityTable(
  tableName: 'lapTaggings',
  primaryKeyName: 'id',
  primaryKeyType: PrimaryKeyType.integer_auto_incremental,
  useSoftDeleting: false,
  modelName: 'DbLapTagging',
  fields: [
    SqfEntityField('system', DbType.bool),
    SqfEntityFieldRelationship(
        parentTable: tableTag,
        deleteRule: DeleteRule.CASCADE,
        defaultValue: 0),
    SqfEntityFieldRelationship(
        parentTable: tableLap,
        deleteRule: DeleteRule.CASCADE,
        defaultValue: 0),
  ],
);

const tableActivityTagging = SqfEntityTable(
  tableName: 'activityTaggings',
  primaryKeyName: 'id',
  primaryKeyType: PrimaryKeyType.integer_auto_incremental,
  useSoftDeleting: false,
  modelName: 'DbActivityTagging',
  fields: [
    SqfEntityField('system', DbType.bool),
    SqfEntityFieldRelationship(
        parentTable: tableTag,
        deleteRule: DeleteRule.CASCADE,
        defaultValue: 0),
    SqfEntityFieldRelationship(
        parentTable: tableActivity,
        deleteRule: DeleteRule.CASCADE,
        defaultValue: 0),
  ],
);


@SqfEntityBuilder(encrateia)
const encrateia = SqfEntityModel(
  modelName: 'DbEncrateia', // optional
  databaseName: 'encrateia.db',
  databaseTables: [
    tableAthlete,
    tableActivity,
    tableEvent,
    tableLap,
    tableWeight,
    tableHeartRateZoneSchema,
    tableHeartRateZone,
    tablePowerZoneSchema,
    tablePowerZone,
    tableTag,
    tableTagGroup,
    tableLapTagging,
    tableActivityTagging,
  ],
  sequences: [],
  bundledDatabasePath: null,
);
