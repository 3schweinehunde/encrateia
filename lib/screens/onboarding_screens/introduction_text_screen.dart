import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

import '/utils/my_color.dart';

class IntroductionTextScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Introduction'),
        backgroundColor: MyColor.primary,
      ),
      body: SafeArea(
        child: Markdown(
          onTapLink: (String url) => launch(url),
          data: '''
## What is Encrateia?

Encrateia is a mobile application that wants to help you analyse your activity 
tracking data. In particular Encrateia analyzes .fit-Files that are created by 
many fitness trackers by default.

Encrateia is quite a sophisticated piece of application with 20+ charts, and 
10+ reports, so we thought, we'd share the rationale behind Encrateia and what 
it actually does:

## Using Encrateia with Strava

A lot of runners and cyclists upload their activity data to Strava, to be able 
to share and analyse and because storage capacity on tracking devices is 
limited. Old tracking data is typically deleted from your device without asking 
you for 
consent.

We want to provide a possibility for you to get all your fitness data back and 
because you already own a smart phone or tablet we went the route to create this 
app.

Encrateia helps you download your original tracking data - the .fit-files from 
Strava, also for activities, that are no longer on your tracker.

To get your data, we fetch information about your activities via the Strava 
API. You have to authorize the Encrateia app to do so. As the .fit-files can 
only be downloaded from the web site (and not via the API) you have to provide 
your Strava credentials a second time.

Then you can use the [Download from Strava]-Button on the Athlete Screen to 
download the latest of your activities. They are stored on your device (and you 
could create a backup manually, if you like).
Then that .fit-files are parsed and the data is stored in a local SQLite 
database on the device. This takes quite some time, parsing is quick, but 
storing is 20 to 30 seconds per activity. 
However, that makes later analysis a lot quicker and it has only to be done 
once.

## Using Encrateia without Strava

If you do not have a Strava account, you can still use Encrateia importing your 
.fit-files manually.

Create a users with the second option "Create a Standalone User". Then put your 
.fit-files into the documents directory of the Encrateia app on your mobile 
device. You can download the .fit files from e.g. Garmin Connect via batch 
export. To help you identify that directory, we placed a file named 
put_your_fit_files_here.txt there.

Finally, use the Button "Import from Local Directory" on the athlete detail 
screen to actually upload the tracking data into Encrateia.

## Why should I trust you?

No activity data is leaving your device, neither to the developer of Encrateia, 
nor to any third party service. We believe, your activity data should be 
strictly yours.
Have a look at our 
[privacy statement for the app](https://encrateia.informatom.com/privacy_app).

Encrateia is, while not for free, an open source application. Have a look at 
our [web site](https://encrateia.informatom.com/source), if you want to check 
it out and/or compile Encrateia yourself.

If you have any questions regarding Encrateia, feel free to write us an 
e-mail: <mailto:encrateia@informatom.com>.
''',
        ),
      ),
    );
  }
}
