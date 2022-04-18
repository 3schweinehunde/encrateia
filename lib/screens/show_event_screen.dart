import 'package:flutter/material.dart';
import '/models/event.dart';
import '/utils/pg_text.dart';
import '/utils/enums.dart';
import '/utils/my_button.dart';
import '/utils/my_color.dart';
import 'edit_event_screen.dart';

class ShowEventScreen extends StatelessWidget {
  const ShowEventScreen({
    Key? key,
    this.record,
  }) : super(key: key);

  final Event? record;

  List<Widget> tiles({required BuildContext context}) {
    return <Widget>[
      ListTile(
        title: Text(record!.event!),
        subtitle: const Text('Event'),
      ),
      ListTile(
        title: PQText(value: record!.eventType, pq: PQ.text),
        subtitle: const Text('Event Type'),
      ),
      ListTile(
        title: PQText(value: record!.eventGroup, pq: PQ.integer),
        subtitle: const Text('Event Group'),
      ),
      ListTile(
        title: PQText(value: record!.timerTrigger, pq: PQ.text),
        subtitle: const Text('Timer Trigger'),
      ),
      ListTile(
        title: PQText(
          value: record!.timeStamp,
          pq: PQ.dateTime,
          format: DateTimeFormat.longDateTime,
        ),
        subtitle: const Text('Time Stamp'),
      ),
      ListTile(
        title: PQText(
          value: record!.timeStamp.toString(),
          pq: PQ.text,
        ),
        subtitle: const Text('Time Stamp'),
      ),
      ListTile(
        title: PQText(
          value: record!.positionLat,
          pq: PQ.latitude,
        ),
        subtitle: const Text('Latitude'),
      ),
      ListTile(
        title: PQText(
          value: record!.positionLong,
          pq: PQ.longitude,
        ),
        subtitle: const Text('Longitude'),
      ),
      ListTile(
        title: PQText(
          value: record!.distance,
          pq: PQ.distanceInMeters,
        ),
        subtitle: const Text('Distance'),
      ),
      ListTile(
        title: PQText(
          value: record!.altitude,
          pq: PQ.elevation,
        ),
        subtitle: const Text('Altitude'),
      ),
      ListTile(
        title: PQText(
          value: record!.speed,
          pq: PQ.speed,
        ),
        subtitle: const Text('Speed'),
      ),
      ListTile(
        title: PQText(
          value: record!.heartRate,
          pq: PQ.heartRate,
        ),
        subtitle: const Text('Heart Rate'),
      ),
      ListTile(
        title: PQText(
          value: record!.cadence,
          pq: PQ.cadence,
        ),
        subtitle: const Text('Cadence'),
      ),
      ListTile(
        title: PQText(
          value: record!.fractionalCadence,
          pq: PQ.percentage,
        ),
        subtitle: const Text('Fractional Cadence'),
      ),
      ListTile(
        title: PQText(
          value: record!.power,
          pq: PQ.power,
        ),
        subtitle: const Text('Power'),
      ),
      ListTile(
        title: PQText(
          value: record!.strydCadence,
          pq: PQ.cadence,
        ),
        subtitle: const Text('Stryd Cadence'),
      ),
      ListTile(
        title: PQText(
          value: record!.groundTime,
          pq: PQ.groundTime,
        ),
        subtitle: const Text('Ground Time'),
      ),
      ListTile(
        title: PQText(
          value: record!.verticalOscillation,
          pq: PQ.verticalOscillation,
        ),
        subtitle: const Text('Vertical Oscillation'),
      ),
      ListTile(
        title: PQText(
          value: record!.formPower,
          pq: PQ.power,
        ),
        subtitle: const Text('Form Power'),
      ),
      ListTile(
        title: PQText(
          value: record!.legSpringStiffness,
          pq: PQ.legSpringStiffness,
        ),
        subtitle: const Text('Leg Spring Stiffness'),
      ),
      ListTile(
        title: PQText(
          value: record!.data,
          pq: PQ.integer,
        ),
        subtitle: const Text('Data'),
      ),
      MyButton.edit(onPressed: () async {
        await Navigator.push(
          context,
          MaterialPageRoute<BuildContext>(
              builder: (BuildContext context) =>
                  EditEventScreen(record: record)),
        );
      })
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: MyColor.activity,
          title: Text('Event ${record!.timeStamp.toString()} /'
              ' ${record!.distance} m')),
      body: SafeArea(
          child: GridView.extent(
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        maxCrossAxisExtent: 350,
        childAspectRatio: 5,
        children: tiles(context: context),
      )),
    );
  }
}
