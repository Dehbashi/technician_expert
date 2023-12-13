import 'package:flutter/material.dart';

class Header extends StatelessWidget implements PreferredSizeWidget {
  // const Header({Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Directionality(
        textDirection: TextDirection.rtl,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'صفحه مدیریت سرویسکار',
              style: TextStyle(
                color: Color(0xFF037E85),
                fontFamily: 'iranSans',
                fontWeight: FontWeight.bold,
              ),
            ),
            Image.asset(
              'assets/images/logo.png',
              width: 121,
              height: 68,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
