import 'package:flutter/material.dart';

import 'icon_utils.dart';
import 'my_button_style.dart';
import 'my_color.dart';

class MyButton extends ElevatedButton {
  MyButton.delete({Widget? child, VoidCallback? onPressed})
      : super(
          style: MyButtonStyle.raisedButtonStyle(
              color: MyColor.delete, textColor: Colors.white),
          child: child ?? const Text('Delete'),
          onPressed: onPressed,
        );

  MyButton.cancel({Widget? child, VoidCallback? onPressed})
      : super(
          style: MyButtonStyle.raisedButtonStyle(color: MyColor.cancel),
          child: child ?? const Text('Cancel'),
          onPressed: onPressed,
        );

  MyButton.edit({Widget? child, VoidCallback? onPressed})
      : super(
          style: MyButtonStyle.raisedButtonStyle(color: MyColor.edit),
          child: child ?? const Text('Edit'),
          onPressed: onPressed,
        );

  MyButton.save({Key? key, Widget? child, VoidCallback? onPressed})
      : super(key: key,
          style: MyButtonStyle.raisedButtonStyle(color: MyColor.save),
          child: child ?? const Text('Save'),
          onPressed: onPressed,
        );

  MyButton.add({Widget? child, VoidCallback? onPressed})
      : super(
          style: MyButtonStyle.raisedButtonStyle(color: MyColor.add),
          child: child ?? const Text('Add'),
          onPressed: onPressed,
        );

  MyButton.copy({Widget? child, VoidCallback? onPressed})
      : super(
          style: MyButtonStyle.raisedButtonStyle(color: MyColor.copy),
          child: child ?? MyIcon.copy,
          onPressed: onPressed,
        );

  MyButton.navigate({Widget? child, VoidCallback? onPressed})
      : super(
          style: MyButtonStyle.raisedButtonStyle(color: MyColor.navigate),
          child: child ?? const Text('Navigate'),
          onPressed: onPressed,
        );

  MyButton.detail({Widget? child, VoidCallback? onPressed})
      : super(
          style: MyButtonStyle.raisedButtonStyle(
              color: MyColor.detail, textColor: Colors.white),
          child: child ?? const Text('Detail'),
          onPressed: onPressed,
        );

  MyButton.log({Widget? child, VoidCallback? onPressed})
      : super(
          style: MyButtonStyle.raisedButtonStyle(
              color: MyColor.log, textColor: Colors.white),
          child: child ?? const Text('Log Entries'),
          onPressed: onPressed,
        );

  MyButton.activity({Widget? child, VoidCallback? onPressed})
      : super(
          style: MyButtonStyle.raisedButtonStyle(
              color: MyColor.activity, textColor: Colors.white),
          child: child ?? const Text('Activity'),
          onPressed: onPressed,
        );
}
