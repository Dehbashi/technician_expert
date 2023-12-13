import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  // const ButtonWidget({super.key});
  final String title;
  final bool hasBorder;
  ButtonWidget({required this.title, required this.hasBorder});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
            color: hasBorder ? Colors.white : Color(0xFF037E85),
            borderRadius: BorderRadius.circular(10),
            border: hasBorder
                ? Border.all(color: Colors.lightBlue)
                : Border.fromBorderSide(BorderSide.none)),
        height: 50,
        width: 175,
        child: Container(
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(
              color: hasBorder ? Colors.lightBlue : Colors.white,
              fontFamily: 'iranSans',
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
