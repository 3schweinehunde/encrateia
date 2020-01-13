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
    SqfEntityField('startTime', DbType.text),
    SqfEntityField('distance', DbType.integer),
    SqfEntityField('serialNumber', DbType.integer),
    SqfEntityField('timeCreated', DbType.datetime),
    SqfEntityFieldRelationship(
        parentTable: tableAthlete,
        deleteRule: DeleteRule.CASCADE,
        defaultValue: '0'),
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
    SqfEntityFieldRelationship(
        parentTable: tableActivity,
        deleteRule: DeleteRule.CASCADE,
        defaultValue: '0'),
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
    ],
    sequences: [],
    bundledDatabasePath: null);
