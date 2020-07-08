import 'package:encrateia/utils/my_button.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/athlete.dart';
import 'package:encrateia/utils/icon_utils.dart';

class EditStandaloneAthleteWidget extends StatefulWidget {
  const EditStandaloneAthleteWidget({
    Key key,
    this.athlete,
  }) : super(key: key);

  final Athlete athlete;

  @override
  _EditStandaloneAthleteWidgetState createState() => _EditStandaloneAthleteWidgetState();
}

class _EditStandaloneAthleteWidgetState extends State<EditStandaloneAthleteWidget> {
  Flushbar<Object> flushbar = Flushbar<Object>();

  @override
  Widget build(BuildContext context) {
    return ListView(
        padding: const EdgeInsets.all(20),
        children: <Widget>[
          Card(
            child: ListTile(
              leading: MyIcon.running,
              title: const Text('Enter Your Name'),
            ),
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'First name'),
            initialValue: widget.athlete.firstName,
            onChanged: (String value) => widget.athlete.firstName = value,
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Last name'),
            initialValue: widget.athlete.lastName,
            onChanged: (String value) => widget.athlete.lastName = value,
          ),

          // Cancel and Save Card
          Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                MyButton.cancel(
                  onPressed: () => Navigator.of(context).pop(),
                ),
                Container(width: 20.0),
                MyButton.save(
                  onPressed: () => saveStandaloneUser(context),
                ),
              ],
            ),
          ),
        ],
      );
  }

  Future<void> saveStandaloneUser(BuildContext context) async {
    widget.athlete.firstName =
        widget.athlete.firstName ?? widget.athlete.firstName;
    widget.athlete.lastName =
        widget.athlete.lastName ?? widget.athlete.lastName;
    await widget.athlete.save();
    Navigator.of(context).pop();
  }
}
