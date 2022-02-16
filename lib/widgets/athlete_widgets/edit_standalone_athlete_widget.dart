import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

import '/models/athlete.dart';
import '/models/power_zone_schema.dart';
import '/screens/onboarding_screens/onboarding_power_zone_schema_screen.dart';
import '/utils/icon_utils.dart';
import '/utils/my_button.dart';

class EditStandaloneAthleteWidget extends StatefulWidget {
  const EditStandaloneAthleteWidget({
    Key key,
    this.athlete,
  }) : super(key: key);

  final Athlete athlete;

  @override
  _EditStandaloneAthleteWidgetState createState() =>
      _EditStandaloneAthleteWidgetState();
}

class _EditStandaloneAthleteWidgetState
    extends State<EditStandaloneAthleteWidget> {
  Flushbar<Object> flushbar = Flushbar<Object>();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: <Widget>[
        const Card(
          child: ListTile(
            leading: MyIcon.running,
            title: Text('Enter Your Name'),
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

    final List<PowerZoneSchema> powerZoneSchemas =
        await widget.athlete.powerZoneSchemas;
    if (powerZoneSchemas.isEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute<BuildContext>(
          builder: (BuildContext _) =>
              OnBoardingPowerZoneSchemaScreen(athlete: widget.athlete),
        ),
      );
    } else {
      Navigator.of(context).pop();
    }
  }
}
