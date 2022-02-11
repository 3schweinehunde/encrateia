import 'package:flutter/material.dart';

class MyButtonStyle extends ButtonStyle {
  static ButtonStyle raisedButtonStyle({Color color, Color textColor}) {
    return ElevatedButton.styleFrom(
      onPrimary: textColor ?? Colors.black,
      primary: color ?? Colors.grey[300],
      minimumSize: const Size(88, 36),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(2)),
      ),
    );
  }
}
