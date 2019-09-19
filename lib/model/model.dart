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
      SqfEntityField('firstName', DbType.text),
      SqfEntityField('lastName', DbType.text),
      SqfEntityField('stravaUsername', DbType.text),
      SqfEntityField('photoPath', DbType.text),
      SqfEntityField('stravaId', DbType.integer),
    ]
);

@SqfEntityBuilder(encrateia)
const encrateia = SqfEntityModel(
    modelName: 'DbEncrateia', // optional
    databaseName: 'encrateia.db',
    databaseTables: [tableAthlete],
    sequences: [],
    bundledDatabasePath: null
);