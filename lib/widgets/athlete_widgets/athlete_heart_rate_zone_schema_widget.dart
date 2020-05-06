import 'package:encrateia/screens/add_heart_rate_zone_schema_screen.dart';
import 'package:encrateia/utils/my_button.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/athlete.dart';
import 'package:encrateia/models/heart_rate_zone_schema.dart';
import 'package:encrateia/utils/icon_utils.dart';
import 'package:intl/intl.dart';

class AthleteHeartRateZoneSchemaWidget extends StatefulWidget {
  final Athlete athlete;

  AthleteHeartRateZoneSchemaWidget({this.athlete});

  @override
  _AthleteHeartRateZoneSchemaWidgetState createState() =>
      _AthleteHeartRateZoneSchemaWidgetState();
}

class _AthleteHeartRateZoneSchemaWidgetState
    extends State<AthleteHeartRateZoneSchemaWidget> {
  List<HeartRateZoneSchema> heartRateZoneSchemas = [];
  int offset = 0;
  int rows;

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(context) {
    if (heartRateZoneSchemas != null) {
      if (heartRateZoneSchemas.length > 0) {
        rows =
            (heartRateZoneSchemas.length < 8) ? heartRateZoneSchemas.length : 8;
        return ListView(
          children: <Widget>[
            Center(
              child: Text(
                "\nHeart Rate Zone Schemas ${offset + 1} - ${offset + rows} "
                "of ${heartRateZoneSchemas.length}",
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
              rows: heartRateZoneSchemas
                  .sublist(offset, offset + rows)
                  .map((HeartRateZoneSchema heartRateZoneSchema) {
                return DataRow(
                  key: Key(heartRateZoneSchema.db.id.toString()),
                  cells: [
                    DataCell(Text(DateFormat("d MMM yyyy")
                        .format(heartRateZoneSchema.db.date))),
                    DataCell(Text(heartRateZoneSchema.db.name)),
                    DataCell(Text(heartRateZoneSchema.db.base.toString())),
                    DataCell(
                      MyIcon.edit,
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddHeartRateZoneSchemaScreen(
                              heartRateZoneSchema: heartRateZoneSchema,
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
                          builder: (context) => AddHeartRateZoneSchemaScreen(
                            heartRateZoneSchema:
                                HeartRateZoneSchema(athlete: widget.athlete),
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
                  onPressed: (offset + rows == heartRateZoneSchemas.length)
                      ? null
                      : () => setState(() {
                            offset + rows < heartRateZoneSchemas.length - rows
                                ? offset = offset + rows
                                : offset = heartRateZoneSchemas.length - rows;
                          }),
                ),
                Spacer(),
              ],
            ),
            templateButtons(),
          ],
        );
      } else {
        return Padding(
          padding: EdgeInsets.all(25.0),
          child: ListView(
            children: <Widget>[
              Text('''
No heart rate schema defined so far:
                
You can easily start with a pre defined heartRate schema,
just click on the button below und go from there.

You could also create a schema from scratch.

'''),
              RaisedButton(
                color: Colors.green,
                child: Text("New schema"),
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddHeartRateZoneSchemaScreen(
                        heartRateZoneSchema:
                            HeartRateZoneSchema(athlete: widget.athlete),
                      ),
                    ),
                  );
                  getData();
                },
              ),
              templateButtons(),
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
    heartRateZoneSchemas = await athlete.heartRateZoneSchemas;
    setState(() {});
  }

  likeGarmin() async {
    Athlete athlete = widget.athlete;
    var heartRateZoneSchema = HeartRateZoneSchema.likeGarmin(athlete: athlete);
    await heartRateZoneSchema.db.save();
    await heartRateZoneSchema.addGarminZones();
    await getData();
  }

  likeStefanDillinger() async {
    Athlete athlete = widget.athlete;
    var heartRateZoneSchema =
        HeartRateZoneSchema.likeStefanDillinger(athlete: athlete);
    await heartRateZoneSchema.db.save();
    await heartRateZoneSchema.addStefanDillingerZones();
    await getData();
  }

  templateButtons() {
    return Column(children: [
      Divider(),
      Text("Add heart rate zone schema from template:"),
      RaisedButton(
        // MyIcon.downloadLocal,
        color: Colors.orange,
        child: Text("like Garmin"),
        onPressed: () => likeGarmin(),
      ),
      RaisedButton(
        // MyIcon.downloadLocal,
        color: Colors.orange,
        child: Text("like Stefan Dillinger"),
        onPressed: () => likeStefanDillinger(),
      ),
    ]);
  }
}
