import 'package:flutter/material.dart';

class MyButtonStyle extends ButtonStyle {
  static ButtonStyle raisedButtonStyle({Color? color, Color? textColor}) {
    return ElevatedButton.styleFrom(
      foregroundColor: textColor ?? Colors.black,
      backgroundColor: color ?? Colors.grey[300],
      minimumSize: const Size(88, 36),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(2)),
      ),
    );
  }
}
