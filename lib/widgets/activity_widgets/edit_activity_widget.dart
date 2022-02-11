import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '/models/activity.dart';
import '/utils/date_time_utils.dart';
import '/utils/my_button.dart';

class EditActivityWidget extends StatefulWidget {
  const EditActivityWidget({
    Key key,
    @required this.activity,
  }) : super(key: key);

  final Activity activity;

  @override
  _EditActivityWidgetState createState() => _EditActivityWidgetState();
}

class _EditActivityWidgetState extends State<EditActivityWidget> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(labelText: 'Title'),
                onChanged: (String value) => widget.activity.name = value,
                initialValue: widget.activity.name,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Total Distance',
                  helperText: 'in m',
                ),
                onChanged: (String value) =>
                    widget.activity.totalDistance = int.parse(value),
                initialValue: widget.activity.totalDistance.toString(),
                keyboardType: TextInputType.number,
              ),
              DateTimeField(
                  decoration: const InputDecoration(
                    labelText: 'Time Stamp',
                    helperText: 'Tap to open Selector',
                  ),
                  format: DateFormat('yyyy-MM-dd HH:mm:SS'),
                  initialValue: widget.activity.timeStamp,
                  resetIcon: null,
                  onShowPicker:
                      (BuildContext context, DateTime currentValue) async {
                    final DateTime date = await showDatePicker(
                        context: context,
                        firstDate: DateTime(1969),
                        initialDate: currentValue ?? DateTime.now(),
                        lastDate: DateTime(2100));
                    if (date != null) {
                      final TimeOfDay time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(
                            currentValue ?? DateTime.now()),
                      );
                      return DateTimeField.combine(date, time);
                    } else {
                      return currentValue;
                    }
                  },
                  onChanged: (DateTime value) {
                    widget.activity.timeStamp = value;
                    widget.activity.timeCreated = value;
                  }),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Total Ascent',
                  helperText: 'in m',
                ),
                onChanged: (String value) =>
                    widget.activity.totalAscent = int.parse(value),
                initialValue: widget.activity.totalAscent.toString(),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Total Descent',
                  helperText: 'in m',
                ),
                onChanged: (String value) =>
                    widget.activity.totalDescent = int.parse(value),
                initialValue: widget.activity.totalDescent.toString(),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Average Heart Rate',
                  helperText: 'in bpm',
                ),
                onChanged: (String value) =>
                    widget.activity.avgHeartRate = int.parse(value),
                initialValue: widget.activity.avgHeartRate.toString(),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Average Power',
                  helperText: 'in W',
                ),
                onChanged: (String value) =>
                    widget.activity.avgPower = double.parse(value),
                initialValue: widget.activity.avgPower.toString(),
                keyboardType: TextInputType.number,
              ),
              Row(
                children: <Widget>[
                  const Text('Sport'),
                  const SizedBox(width: 20),
                  DropdownButton<String>(
                    value: widget.activity.sport ?? 'running',
                    icon: const Icon(Icons.arrow_downward),
                    onChanged: (String value) => widget.activity.sport = value,
                    items: <String>['running', 'cycling', 'swimming', 'other']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Sub Sport'),
                onChanged: (String value) => widget.activity.subSport = value,
                initialValue: widget.activity.subSport,
              ),
              Row(
                children: <Widget>[
                  Flexible(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Moving Time',
                        helperText: 'hours',
                      ),
                      onChanged: (String value) => widget.activity.movingTime =
                          widget.activity.movingTime.setHours(int.parse(value)),
                      initialValue: (widget.activity.movingTime ?? 0)
                          .fullHours
                          .toString(),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  Flexible(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Moving Time',
                        helperText: 'minutes',
                      ),
                      onChanged: (String value) => widget.activity.movingTime =
                          widget.activity.movingTime
                              .setMinutes(int.parse(value)),
                      initialValue: (widget.activity.movingTime ?? 0)
                          .fullMinutes
                          .toString(),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  Flexible(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Moving Time',
                        helperText: 'seconds',
                      ),
                      onChanged: (String value) => widget.activity.movingTime =
                          widget.activity.movingTime
                              .setSeconds(int.parse(value)),
                      initialValue: (widget.activity.movingTime ?? 0)
                          .fullSeconds
                          .toString(),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const Spacer(flex: 2),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: MyButton.save(
                  onPressed: () async {
                    await widget.activity.save();
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
