import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MyButtonStyle extends ButtonStyle {
  static ButtonStyle raisedButtonStyle({Color color, Color textColor}) {
    return ElevatedButton.styleFrom(
      onPrimary: color ?? Colors.black87,
      primary: color ?? Colors.grey[300],
      textStyle: TextStyle(color: textColor ?? Colors.black),
      minimumSize: const Size(88, 36),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(2)),
      ),
    );
  }

  static ButtonStyle flatButtonStyle({Color color, Color textColor}) {
    return TextButton.styleFrom(
      primary: color ?? Colors.black87,
      textStyle: TextStyle(color: textColor ?? Colors.black),
      minimumSize: const Size(88, 36),
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(2.0)),
      ),
    );
  }
}