import 'package:encrateia/screens/add_power_zone_schema_screen.dart';
import 'package:encrateia/utils/my_button.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/athlete.dart';
import 'package:encrateia/models/power_zone_schema.dart';
import 'package:encrateia/utils/icon_utils.dart';
import 'package:intl/intl.dart';

class AthletePowerZoneSchemaWidget extends StatefulWidget {
  final Athlete athlete;

  AthletePowerZoneSchemaWidget({this.athlete});

  @override
  _AthletePowerZoneSchemaWidgetState createState() =>
      _AthletePowerZoneSchemaWidgetState();
}

class _AthletePowerZoneSchemaWidgetState
    extends State<AthletePowerZoneSchemaWidget> {
  List<PowerZoneSchema> powerZoneSchemas = [];
  int offset = 0;
  int rows;

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(context) {
    if (powerZoneSchemas != null) {
      if (powerZoneSchemas.length > 0) {
        rows = (powerZoneSchemas.length < 8) ? powerZoneSchemas.length : 8;
        return ListView(
          children: <Widget>[
            Center(
              child: Text(
                "\nPowerZoneSchemas ${offset + 1} - ${offset + rows} "
                "of ${powerZoneSchemas.length}",
                style: Theme.of(context).textTheme.title,
              ),
            ),
            DataTable(
              headingRowHeight: kMinInteractiveDimension * 0.80,
              dataRowHeight: kMinInteractiveDimension * 0.80,
              columnSpacing: 9,
              columns: <DataColumn>[
                DataColumn(label: Text("Date")),
                DataColumn(label: Text("Name")),
                DataColumn(
                  label: Text("Base (W)"),
                  numeric: true,
                ),
                DataColumn(label: Text("Edit")),
              ],
              rows: powerZoneSchemas
                  .sublist(offset, offset + rows)
                  .map((PowerZoneSchema powerZoneSchema) {
                return DataRow(
                  key: Key(powerZoneSchema.db.id.toString()),
                  cells: [
                    DataCell(Text(DateFormat("d MMM yyyy")
                        .format(powerZoneSchema.db.date))),
                    DataCell(Text(powerZoneSchema.db.name)),
                    DataCell(Text(powerZoneSchema.db.base.toString())),
                    DataCell(
                      MyIcon.edit,
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddPowerZoneSchemaScreen(
                              powerZoneSchema: powerZoneSchema,
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
            SizedBox(height: 20),
            Row(
              children: <Widget>[
                Spacer(),
                MyButton.add(
                    child: Text("New schema"),
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddPowerZoneSchemaScreen(
                            powerZoneSchema:
                                PowerZoneSchema(athlete: widget.athlete),
                          ),
                        ),
                      );
                      getData();
                    }),
                Spacer(),
                MyButton.navigate(
                  child: Text("<<"),
                  onPressed: (offset == 0)
                      ? null
                      : () => setState(() {
                            offset > 8 ? offset = offset - rows : offset = 0;
                          }),
                ),
                Spacer(),
                MyButton.navigate(
                  child: Text(">>"),
                  onPressed: (offset + rows == powerZoneSchemas.length)
                      ? null
                      : () => setState(() {
                            offset + rows < powerZoneSchemas.length - rows
                                ? offset = offset + rows
                                : offset = powerZoneSchemas.length - rows;
                          }),
                ),
                Spacer(),
              ],
            ),
          ],
        );
      } else {
        return Padding(
          padding: EdgeInsets.all(25.0),
          child: ListView(
            children: <Widget>[
              Text('''
No power schema defined so far:
                
You can easily start with one of the three pre defined power schemas,
just click on one of the the buttons und go from there.

You could also create a schema from scratch.

'''),
              RaisedButton(
                color: Colors.green,
                child: Text("New schema"),
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddPowerZoneSchemaScreen(
                        powerZoneSchema:
                            PowerZoneSchema(athlete: widget.athlete),
                      ),
                    ),
                  );
                  getData();
                },
              ),
              RaisedButton(
                // MyIcon.downloadLocal,
                color: Colors.orange,
                child: Text("Zone schema like Stryd"),
                onPressed: () => likeStryd(),
              ),
              RaisedButton(
                // MyIcon.downloadLocal,
                color: Colors.orange,
                child: Text("Zone schema like Jim Vance"),
                onPressed: () => likeJimVance(),
              ),
              RaisedButton(
                // MyIcon.downloadLocal,
                color: Colors.orange,
                child: Text("Zone schema like Stefan Dillinger"),
                onPressed: () => likeStefanDillinger(),
              ),
            ],
          ),
        );
      }
    } else {
      return Center(child: Text("loading"));
    }
  }

  getData() async {
    Athlete athlete = widget.athlete;
    powerZoneSchemas = await athlete.powerZoneSchemas;
    setState(() {});
  }

  likeStryd() async {
    Athlete athlete = widget.athlete;
    var powerZoneSchema = PowerZoneSchema.likeStryd(athlete: athlete);
    await powerZoneSchema.db.save();
    await powerZoneSchema.addStrydZones();
    await getData();
  }

  likeJimVance() async {
    Athlete athlete = widget.athlete;
    var powerZoneSchema = PowerZoneSchema.likeJimVance(athlete: athlete);
    await powerZoneSchema.db.save();
    await powerZoneSchema.addJimVanceZones();
    await getData();
  }

  likeStefanDillinger() async {
    Athlete athlete = widget.athlete;
    var powerZoneSchema = PowerZoneSchema.likeStefanDillinger(athlete: athlete);
    await powerZoneSchema.db.save();
    await powerZoneSchema.addStefanDillingerZones();
    await getData();
  }
}
