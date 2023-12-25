import 'package:flutter/material.dart';
import '../../constans.dart';

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onConfirm;

  const ConfirmationDialog({
    required this.title,
    required this.message,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Directionality(
        textDirection: TextDirection.rtl,
        child: Text(
          title,
          style: TextStyle(
            fontFamily: Constants.textFont,
          ),
        ),
      ),
      content: Directionality(
        textDirection: TextDirection.rtl,
        child: Text(
          message,
          style: TextStyle(
            fontFamily: Constants.textFont,
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: Text(
            'خیر',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            onConfirm();
            Navigator.of(context).pop(); // Close the dialog
          },
          child: Text(
            'بله',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
        ),
      ],
    );
  }
}
