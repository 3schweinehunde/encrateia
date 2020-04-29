import 'package:encrateia/utils/my_color.dart';
import 'package:flutter/material.dart';

class MyTheme {
  static call() {
    var redness = MyColor.primary.red;
    var greenness = MyColor.primary.green;
    var blueness = MyColor.primary.blue;
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: MyColor.primary,
      primarySwatch: MaterialColor(
        MyColor.sunFlowerAccent.value,
        {
          50: Color.fromRGBO(redness, greenness, blueness, .1),
          100: Color.fromRGBO(redness, greenness, blueness, .2),
          200: Color.fromRGBO(redness, greenness, blueness, .3),
          300: Color.fromRGBO(redness, greenness, blueness, .4),
          400: Color.fromRGBO(redness, greenness, blueness, .5),
          500: Color.fromRGBO(redness, greenness, blueness, .6),
          600: Color.fromRGBO(redness, greenness, blueness, .7),
          700: Color.fromRGBO(redness, greenness, blueness, .8),
          800: Color.fromRGBO(redness, greenness, blueness, .9),
          900: Color.fromRGBO(redness, greenness, blueness, 1),
        },
      ),
      // #ff9800
      accentColor: MyColor.primaryAccent,
      fontFamily: 'Ubuntu',
    );
  }
}
