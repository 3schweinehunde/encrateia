import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '/models/event.dart';
import '/utils/date_time_utils.dart';
import '/utils/my_button.dart';
import '/utils/my_color.dart';

class EditEventScreen extends StatefulWidget {
  const EditEventScreen({
    Key? key,
    this.record,
  }) : super(key: key);

  final Event? record;

  @override
  EditEventScreenState createState() => EditEventScreenState();
}

class EditEventScreenState extends State<EditEventScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColor.activity,
        title: const Text('Edit Record'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Event'),
                    onChanged: (String value) => widget.record!.event = value,
                    initialValue: widget.record!.event,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Event Type'),
                    onChanged: (String value) =>
                        widget.record!.eventType = value,
                    initialValue: widget.record!.eventType,
                  ),
                  TextFormField(
                      decoration:
                          const InputDecoration(labelText: 'Event Group'),
                      onChanged: (String value) =>
                          widget.record!.eventGroup = int.parse(value),
                      initialValue: widget.record!.eventGroup.toString(),
                      keyboardType: TextInputType.number),
                  TextFormField(
                    decoration:
                        const InputDecoration(labelText: 'Timer Trigger'),
                    onChanged: (String value) =>
                        widget.record!.timerTrigger = value,
                    initialValue: widget.record!.timerTrigger,
                  ),
                  DateTimeField(
                    decoration: const InputDecoration(labelText: 'Time Stamp'),
                    format: DateFormat('yyyy-MM-dd HH:mm:SS'),
                    initialValue: widget.record!.timeStamp,
                    resetIcon: null,
                    onShowPicker:
                        (BuildContext context, DateTime? currentValue) async {
                      final DateTime? date = await showDatePicker(
                          context: context,
                          firstDate: DateTime(1969),
                          initialDate: currentValue ?? DateTime.now(),
                          lastDate: DateTime(2100));
                      if (date != null) {
                        final TimeOfDay? time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(
                              currentValue ?? DateTime.now()),
                        );
                        return DateTimeField.combine(date, time);
                      } else {
                        return currentValue;
                      }
                    },
                    onChanged: (DateTime? value) =>
                        widget.record!.timeStamp = value,
                  ),
                  Row(children: <Widget>[
                    Flexible(
                      child: TextFormField(
                        decoration: const InputDecoration(
                            labelText: 'Latitude Degrees'),
                        onChanged: (String value) =>
                            widget.record!.positionLat = widget
                                .record!.positionLat!
                                .setDegrees(int.parse(value)),
                        initialValue:
                            widget.record!.positionLat!.fullDegrees.toString(),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    Flexible(
                      child: TextFormField(
                        decoration: const InputDecoration(
                            labelText: 'Latitude Minutes'),
                        onChanged: (String value) =>
                            widget.record!.positionLat = widget
                                .record!.positionLat!
                                .setMinutes(int.parse(value)),
                        initialValue:
                            widget.record!.positionLat!.fullMinutes.toString(),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    Flexible(
                      child: TextFormField(
                        decoration: const InputDecoration(
                            labelText: 'Latitude Seconds'),
                        onChanged: (String value) =>
                            widget.record!.positionLat = widget
                                .record!.positionLat!
                                .setSeconds(double.parse(value)),
                        initialValue:
                            widget.record!.positionLat!.seconds.toString(),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ]),
                  Row(children: <Widget>[
                    Flexible(
                      child: TextFormField(
                        decoration: const InputDecoration(
                            labelText: 'Longitude Degrees'),
                        onChanged: (String value) =>
                            widget.record!.positionLong = widget
                                .record!.positionLong!
                                .setDegrees(int.parse(value)),
                        initialValue:
                            widget.record!.positionLong!.fullDegrees.toString(),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    Flexible(
                      child: TextFormField(
                        decoration: const InputDecoration(
                            labelText: 'Longitude Minutes'),
                        onChanged: (String value) =>
                            widget.record!.positionLong = widget
                                .record!.positionLong!
                                .setMinutes(int.parse(value)),
                        initialValue:
                            widget.record!.positionLong!.fullMinutes.toString(),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    Flexible(
                      child: TextFormField(
                        decoration: const InputDecoration(
                            labelText: 'Longitude Seconds'),
                        onChanged: (String value) =>
                            widget.record!.positionLong = widget
                                .record!.positionLong!
                                .setSeconds(double.parse(value)),
                        initialValue:
                            widget.record!.positionLong!.seconds.toString(),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ]),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Distance'),
                    onChanged: (String value) =>
                        widget.record!.distance = double.parse(value),
                    initialValue: widget.record!.distance.toString(),
                    keyboardType: TextInputType.number,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Altitude'),
                    onChanged: (String value) =>
                        widget.record!.altitude = double.parse(value),
                    initialValue: widget.record!.altitude.toString(),
                    keyboardType: TextInputType.number,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Speed'),
                    onChanged: (String value) =>
                        widget.record!.speed = double.parse(value),
                    initialValue: widget.record!.speed.toString(),
                    keyboardType: TextInputType.number,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Heart Rate'),
                    onChanged: (String value) =>
                        widget.record!.heartRate = int.parse(value),
                    initialValue: widget.record!.heartRate.toString(),
                    keyboardType: TextInputType.number,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Cadence'),
                    onChanged: (String value) =>
                        widget.record!.cadence = double.parse(value),
                    initialValue: widget.record!.cadence.toString(),
                    keyboardType: TextInputType.number,
                  ),
                  TextFormField(
                    decoration:
                        const InputDecoration(labelText: 'Fractional Cadence'),
                    onChanged: (String value) =>
                        widget.record!.fractionalCadence = double.parse(value),
                    initialValue: widget.record!.fractionalCadence.toString(),
                    keyboardType: TextInputType.number,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Power'),
                    onChanged: (String value) =>
                        widget.record!.power = int.parse(value),
                    initialValue: widget.record!.power.toString(),
                    keyboardType: TextInputType.number,
                  ),
                  TextFormField(
                    decoration:
                        const InputDecoration(labelText: 'Stryd Cadence'),
                    onChanged: (String value) =>
                        widget.record!.strydCadence = double.parse(value),
                    initialValue: widget.record!.strydCadence.toString(),
                    keyboardType: TextInputType.number,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Ground Time'),
                    onChanged: (String value) =>
                        widget.record!.groundTime = double.parse(value),
                    initialValue: widget.record!.groundTime.toString(),
                    keyboardType: TextInputType.number,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                        labelText: 'Vertical Oscillation'),
                    onChanged: (String value) => widget
                        .record!.verticalOscillation = double.parse(value),
                    initialValue: widget.record!.verticalOscillation.toString(),
                    keyboardType: TextInputType.number,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Form Power'),
                    onChanged: (String value) =>
                        widget.record!.formPower = int.parse(value),
                    initialValue: widget.record!.formPower.toString(),
                    keyboardType: TextInputType.number,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                        labelText: 'Leg Spring Stiffness'),
                    onChanged: (String value) =>
                        widget.record!.legSpringStiffness = double.parse(value),
                    initialValue: widget.record!.legSpringStiffness.toString(),
                    keyboardType: TextInputType.number,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Data'),
                    onChanged: (String value) =>
                        widget.record!.data = double.parse(value),
                    initialValue: widget.record!.data.toString(),
                    keyboardType: TextInputType.number,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: MyButton.save(
                      onPressed: () async {
                        await widget.record!.save();
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
