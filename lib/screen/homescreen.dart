import 'package:flutter/material.dart';
import './enter_cellphone.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './admin_page.dart';
import './header.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // const HomeScreen({super.key});

  bool isFirstTimeUser = false;

  @override
  void initState() {
    checkFirstTimeUser();
    super.initState();
  }

  void checkFirstTimeUser() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final id = prefs.getInt('id');
    setState(() {
      isFirstTimeUser = token == null || id == null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: isFirstTimeUser ? CellEnter() : AdminPage(),
      body: AdminPage(),
    );
  }
}
