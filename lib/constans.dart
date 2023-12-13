import 'package:flutter/material.dart';

enum ButtonType { accept, cancel, details }

class Constants {
  static const String textFont = 'iranSans';
  static const double buttonWidth = 220;
  static const double buttonHeight = 70;
  static ButtonStyle getElevatedButtonStyle(ButtonType type) {
    Color backgroundColor;
    Color foregroundColor = Colors.white;
    switch (type) {
      case ButtonType.accept:
        backgroundColor = Colors.green;
        break;
      case ButtonType.cancel:
        backgroundColor = Colors.red;
        break;
      case ButtonType.details:
        backgroundColor = Colors.grey;
        break;
    }
    return ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(backgroundColor),
      foregroundColor: MaterialStateProperty.all<Color>(foregroundColor),
      textStyle: MaterialStateProperty.all<TextStyle>(
        TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
          fontFamily: textFont,
        ),
      ),
      padding: MaterialStateProperty.all<EdgeInsets>(
        EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
      ),
    );
  }
}
