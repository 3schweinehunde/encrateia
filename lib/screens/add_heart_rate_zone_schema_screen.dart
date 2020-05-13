import 'package:encrateia/utils/icon_utils.dart';
import 'package:encrateia/utils/my_button.dart';
import 'package:encrateia/utils/my_color.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/heart_rate_zone_schema.dart';
import 'package:encrateia/models/heart_rate_zone.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:encrateia/model/model.dart';
import 'add_heart_rate_zone_screen.dart';

class AddHeartRateZoneSchemaScreen extends StatefulWidget {
  final HeartRateZoneSchema heartRateZoneSchema;

  const AddHeartRateZoneSchemaScreen({Key key, this.heartRateZoneSchema})
      : super(key: key);

  @override
  _AddHeartRateZoneSchemaScreenState createState() =>
      _AddHeartRateZoneSchemaScreenState();
}

class _AddHeartRateZoneSchemaScreenState
    extends State<AddHeartRateZoneSchemaScreen> {
  List<HeartRateZone> heartRateZones = [];
  int offset = 0;
  int rows;

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColor.settings,
        title: Text('Add Heart Rate Zone Schema'),
      ),
      body: ListView(
        padding: EdgeInsets.only(left: 20, right: 20),
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(40),
            child: ListTile(
              leading: MyIcon.warning,
              title: Text("Instructions to update your current base value"),
              subtitle: Text(
                "1) Change the VALID FROM date to today to copy the heart rate zone schema.\n"
                "2) Edit the BASE VALUE to the new value.\n"
                "3) Click SAVE to persist your changes.",
              ),
            ),
          ),
          DateTimeField(
            decoration: InputDecoration(
              labelText: "Valid from",
            ),
            format: DateFormat("yyyy-MM-dd"),
            initialValue: widget.heartRateZoneSchema.db.date,
            onShowPicker: (context, currentValue) {
              return showDatePicker(
                context: context,
                firstDate: DateTime(1969),
                initialDate: DateTime.now(),
                lastDate: DateTime(2100),
              );
            },
            onChanged: (value) => copyHeartRateZoneSchema(date: value),
          ),
          TextFormField(
            decoration: InputDecoration(labelText: "Name"),
            initialValue: widget.heartRateZoneSchema.db.name,
            onChanged: (value) => widget.heartRateZoneSchema.db.name = value,
          ),
          TextFormField(
            decoration: InputDecoration(
              labelText: "Base value in bpm",
              helperText: "e.g. maximum heart rate, threshold heart rate",
            ),
            initialValue: widget.heartRateZoneSchema.db.base.toString(),
            keyboardType: TextInputType.number,
            onChanged: (value) =>
                updateHeartRateZoneBase(base: int.parse(value)),
          ),
          SizedBox(height: 10),
          DataTable(
            headingRowHeight: kMinInteractiveDimension * 0.80,
            dataRowHeight: kMinInteractiveDimension * 0.75,
            columnSpacing: 20,
            horizontalMargin: 10,
            columns: <DataColumn>[
              DataColumn(label: Text("Zone")),
              DataColumn(label: Text("Limits (W)")),
              DataColumn(label: Text("Color")),
              DataColumn(label: Text("Edit")),
            ],
            rows: heartRateZones.map((HeartRateZone heartRateZone) {
              return DataRow(
                key: Key(heartRateZone.db.id.toString()),
                cells: [
                  DataCell(Text(heartRateZone.db.name)),
                  DataCell(Text(heartRateZone.db.lowerLimit.toString() +
                      " - " +
                      heartRateZone.db.upperLimit.toString())),
                  DataCell(CircleColor(
                    circleSize: 20,
                    elevation: 0,
                    color: Color(heartRateZone.db.color),
                  )),
                  DataCell(
                    MyIcon.edit,
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddHeartRateZoneScreen(
                            heartRateZone: heartRateZone,
                            base: widget.heartRateZoneSchema.db.base,
                          ),
                        ),
                      );
                      getData();
                    },
                  )
                ],
              );
            }).toList(),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              MyButton.add(
                child: Text("Add heart rate zone"),
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddHeartRateZoneScreen(
                        heartRateZone: HeartRateZone(
                            heartRateZoneSchema: widget.heartRateZoneSchema),
                        base: widget.heartRateZoneSchema.db.base,
                      ),
                    ),
                  );
                  getData();
                },
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              MyButton.delete(
                onPressed: () => deleteHeartRateZoneSchema(
                  heartRateZoneSchema: widget.heartRateZoneSchema,
                ),
              ),
              SizedBox(width: 5),
              MyButton.cancel(onPressed: () => Navigator.of(context).pop()),
              SizedBox(width: 5),
              MyButton.save(onPressed: () => saveHeartRateZoneSchema(context)),
            ],
          ),
        ],
      ),
    );
  }

  saveHeartRateZoneSchema(BuildContext context) async {
    await widget.heartRateZoneSchema.db.save();
    await DbHeartRateZone().upsertAll(
        heartRateZones.map((heartRateZone) => heartRateZone.db).toList());
    Navigator.of(context).pop();
  }

  getData() async {
    heartRateZones = await widget.heartRateZoneSchema.heartRateZones;
    setState(() {});
  }

  deleteHeartRateZoneSchema({HeartRateZoneSchema heartRateZoneSchema}) async {
    await heartRateZoneSchema.delete();
    Navigator.of(context).pop();
  }

  updateHeartRateZoneBase({int base}) {
    setState(() {
      widget.heartRateZoneSchema.db.base = base;
      for (HeartRateZone heartRateZone in heartRateZones) {
        heartRateZone.db.lowerLimit =
            (heartRateZone.db.lowerPercentage * base / 100).round();
        heartRateZone.db.upperLimit =
            (heartRateZone.db.upperPercentage * base / 100).round();
      }
    });
  }

  copyHeartRateZoneSchema({DateTime date}) async {
    widget.heartRateZoneSchema.db
      ..date = date
      ..id = null;
    int heartRateZoneSchemaId = await widget.heartRateZoneSchema.db.save();
    for (HeartRateZone heartRateZone in heartRateZones) {
      heartRateZone.db
        ..heartRateZoneSchemataId = heartRateZoneSchemaId
        ..id = null;
    }
    await DbHeartRateZone().upsertAll(
        heartRateZones.map((heartRateZone) => heartRateZone.db).toList());
    await getData();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Heart Rate Zone Schema has been copied"),
        content: Text(
            "If you only wanted to fix the date you need to delete the old heart rate zone schema manually."),
        actions: [
          FlatButton(
            child: Text("OK"),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}
