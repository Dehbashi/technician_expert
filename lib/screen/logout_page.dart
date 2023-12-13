import 'package:flutter/material.dart';
import './homescreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> clearSharedPreferences(BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.clear();
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => HomeScreen()),
  );
}

Future<bool> showConfirmationDialog(BuildContext context) async {
  bool confirmed = await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          'خروج از سامانه',
          textAlign: TextAlign.right,
          style: TextStyle(
            // fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'iranSans',
            color: Color(0xFF037E85),
          ),
        ),
        content: Text(
          'آیا از تصمیم خود برای خروج از سامانه مطمئن هستید؟',
          style: TextStyle(
            // fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'iranSans',
            color: Color(0xFF037E85),
          ),
          textAlign: TextAlign.right,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: Text(
              'خیر',
              style: TextStyle(
                fontSize: 20,
                // fontWeight: FontWeight.bold,
                fontFamily: 'iranSans',
                color: Colors.black,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: Text(
              'بله',
              style: TextStyle(
                fontSize: 20,
                // fontWeight: FontWeight.bold,
                fontFamily: 'iranSans',
                color: Colors.black,
              ),
            ),
          ),
        ],
      );
    },
  );

  return confirmed == true;
}
