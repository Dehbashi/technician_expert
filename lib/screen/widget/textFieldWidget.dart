import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFieldWidget extends StatelessWidget {
  // const TextFieldWidget({super.key});
  final String labelText;
  final icon;
  final bool obscureText;
  final suffixIcon;
  String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final TextInputType? keyboardType;

  TextFieldWidget({
    required this.labelText,
    required this.icon,
    required this.obscureText,
    required this.suffixIcon,
    required this.validator,
    required this.onSaved,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextFormField(
        keyboardType: keyboardType,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        validator: validator,
        onSaved: onSaved,
        style: TextStyle(
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontFamily: 'iranSans,'),
        textAlign: TextAlign.left,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(
            color: Color(0xFF037E85),
            fontFamily: 'iranSans',
          ),
          filled: true,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Colors.lightBlue,
            ),
          ),
          prefixIcon: Icon(
            icon,
            color: Color(0xFF037E85),
            size: 25,
          ),
          suffixIcon: Icon(
            suffixIcon,
            color: Colors.lightBlue,
            size: 16,
          ),
        ),
      ),
    );
  }
}
