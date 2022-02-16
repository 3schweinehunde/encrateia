import 'package:flutter/material.dart';
// import '/utils/my_color.dart';

// ignore: avoid_classes_with_only_static_members
class MyColor {
  static Color blueJeans = const Color(0xFF4A89DC);
  static Color blueJeansAccent = const Color(0xFF5D9CEC);
  static Color aqua = const Color(0xFF3BAFDA);
  static Color aquaAccent = const Color(0xFF4FC1E9);
  static Color mint = const Color(0xFF37BC9B);
  static Color mintAccent = const Color(0xFF48CFAD);
  static Color grass = const Color(0xFF8CC152);
  static Color grassAccent = const Color(0xFFA0D468);
  static Color sunFlower = const Color(0xFFF6BB42);
  static Color sunFlowerAccent = const Color(0xFFFFCE54);
  static Color bitterSweet = const Color(0xFFE9573F);
  static Color bitterSweetAccent = const Color(0xFFFC6E51);
  static Color grapeFruit = const Color(0xFFDA4453);
  static Color grapeFruitAccent = const Color(0xFFED5565);
  static Color lavender = const Color(0xFF967ADC);
  static Color lavenderAccent = const Color(0xFFAC92EC);
  static Color pinkRose = const Color(0xFFD770AD);
  static Color pinkRoseAccent = const Color(0xFFEC87C0);
  static Color lightGray = const Color(0xFFE6E9ED);
  static Color lightGrayAccent = const Color(0xFFF5F7FA);
  static Color mediumGray = const Color(0xFFAAB2BD);
  static Color mediumGrayAccent = const Color(0xFFCCD1D9);
  static Color darkGray = const Color(0xFF434A54);
  static Color darkGrayAccent = const Color(0xFF656D78);
  static Color white = Colors.white;
  static Color black = Colors.black;

  static Color ecstasy = const Color(0xFFF9690E);
  static Color gamboge = const Color(0xFFFFB61E);
  static Color brightGoldenYellow = const Color(0xFFFFA400);

  static Color normal = mediumGray;
  static Color normalAccent = mediumGrayAccent;
  static Color defaultColor = white;
  static Color defaultAccent = mediumGrayAccent;
  static Color primary = gamboge;
  static Color primaryAccent = ecstasy;
  static Color success = grass;
  static Color successAccent = grassAccent;
  static Color info = mint;
  static Color infoAccent = mintAccent;
  static Color warning = sunFlower;
  static Color warningAccent = sunFlowerAccent;
  static Color danger = grapeFruit;
  static Color dangerAccent = grapeFruitAccent;
  static Color link = const Color(0x11ffffff);
  static Color linkAccent = const Color(0xAAffffff);

  static Color detail = brightGoldenYellow;
  static Color settings = lightGray;
  static Color add = mint;
  static Color copy = mintAccent;
  static Color save = success;
  static Color cancel = warning;
  static Color delete = danger;
  static Color edit = sunFlower;
  static Color navigate = brightGoldenYellow;
  static Color log = aquaAccent;
  static Color exclude = pinkRoseAccent;
  static Color include = mediumGray;

  static Color athlete = sunFlowerAccent;
  static Color activity = aquaAccent;
  static Color lap = grassAccent;
  static Color tag = lavender;
  static Color interval = pinkRose;

  static Color textColor({
    @required Color backgroundColor,
    bool selected = true,
  }) {
    if (selected) {
      if (ThemeData.estimateBrightnessForColor(backgroundColor) ==
          Brightness.light) {
        return black;
      } else {
        return white;
      }
    } else {
      return black;
    }
  }
}
